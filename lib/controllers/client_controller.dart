import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../core/services/notification_service.dart';
import '../core/network/ws/stomp_service.dart';
import '../core/di/injection_dart.dart';

import '../models/service/ticket_queue_client.dart';

import '../repositories/category_repository.dart';
import '../repositories/api_rest/business_repository_imp.dart';
import '../repositories/ticket_repository.dart';

import '../models/service/service_model.dart';
import '../models/category_model.dart';

class ClientController extends ChangeNotifier with WidgetsBindingObserver {
  ClientController() {
    WidgetsBinding.instance.addObserver(this);
  }
  CategoryModel? _selectedCategory;
  String? _currentClientId;
  String _search = '';

  List<CategoryModel> _categories = [];

  List<ServiceModel> _services = [];

  List<TicketQueueClient> _tickets = [];

  final Set<String> _activeWsSubscriptions = {};

  bool _isClientTopicSubscribed = false;

  bool isLoading = false;

  CategoryModel? get selectedCategory => _selectedCategory;

  List<CategoryModel> get categories => _categories;

  List<ServiceModel> get allServices => _services;

  List<TicketQueueClient> get allTickets => _tickets;

  List<TicketQueueClient> get activeTickets => _tickets
      .where((t) => t.status == 'WAITING' || t.status == 'IN_PROGRESS')
      .toList();

  List<TicketQueueClient> get completedTickets =>
      _tickets.where((t) => t.status == 'COMPLETED').toList();

  List<TicketQueueClient> get cancelledTickets => _tickets
      .where((t) => t.status == 'CANCELLED' || t.status == 'CANCELED')
      .toList();

  List<ServiceModel> get filteredServices {
    var list = _services.toList();

    if (_selectedCategory != null) {
      list = list.where((s) => s.category.id == _selectedCategory!.id).toList();
    }

    if (_search.isNotEmpty) {
      list = list
          .where(
            (s) => s.serviceName.toLowerCase().contains(_search.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  void setCategory(CategoryModel? c) {
    _selectedCategory = c;
    notifyListeners();
  }

  void setSearch(String s) {
    _search = s;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    final wsService = getIt<StompService>();

    if (state == AppLifecycleState.resumed) {

      debugPrint('🔄 App resumed -> reconectando WS');

      if (!wsService.isConnected &&
          _currentClientId != null &&
          _currentClientId!.isNotEmpty) {

        disposeSubscriptions();

        wsService.connect(
          onConnected: () {

            debugPrint('✅ WS reconectado');

            _subscribeToWebSockets(_currentClientId!);
          },
        );
      }
    }

    if (state == AppLifecycleState.paused) {
      debugPrint('⏸️ App en background');
    }
  }

  Future<void> loadInitialData(String? clientId) async {
    isLoading = true;
    _currentClientId = clientId;
    notifyListeners();

    try {
      final catRepo = getIt<CategoryRepository>();

      final businessRepo = getIt<BusinessRepositoryImpl>();

      final ticketRepo = getIt<TicketRepository>();

      _categories = await catRepo.getCategories();

      _services = await businessRepo.getServices(null);

      if (clientId != null && clientId.isNotEmpty) {
        _tickets = await ticketRepo.getClientTickets(clientId);

        _subscribeToWebSockets(clientId);
      }
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> joinQueue(String serviceId, String clientId) async {
    isLoading = true;

    notifyListeners();

    try {
      final repo = getIt<BusinessRepositoryImpl>();

      final newTicket = await repo.joinQueueService(serviceId, clientId);

      _tickets.add(newTicket);

      final wsService = getIt<StompService>();

      if (!_activeWsSubscriptions.contains(serviceId)) {
        _activeWsSubscriptions.add(serviceId);

        if (wsService.isConnected) {
          wsService.subscribe('/topic/service/$serviceId/update', (message) {
            if (message.isNotEmpty) {
              _handleQueueUpdatedEvent(message);
            }
          });
        }
      }

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error joinQueue: $e');

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void _subscribeToWebSockets(String clientId) {
    final wsService = getIt<StompService>();

    void doSubscribe() {
      if (!_isClientTopicSubscribed) {
        _isClientTopicSubscribed = true;

        wsService.subscribe('/topic/client/$clientId', (message) {
          if (message.isNotEmpty) {
            _handleClientTopicEvent(message);
          }
        });
      }

      for (var ticket in activeTickets) {
        final serviceId = ticket.service.serviceId;

        if (!_activeWsSubscriptions.contains(serviceId)) {
          _activeWsSubscriptions.add(serviceId);

          wsService.subscribe('/topic/service/$serviceId/update', (message) {
            if (message.isNotEmpty) {
              _handleQueueUpdatedEvent(message);
            }
          });
        }
      }
    }

    if (wsService.isConnected) {
      doSubscribe();
    } else {
      wsService.connect(onConnected: doSubscribe);
    }
  }

  void _handleClientTopicEvent(String rawJson) {
    try {
      final Map<String, dynamic> payload = json.decode(rawJson);

      if (payload['type'] == 'YOUR_TURN' && payload.containsKey('data')) {
        final updatedTicket = TicketQueueClient.fromJson(payload['data']);

        _updateLocalTicket(updatedTicket);

        NotificationService.showNotification(
          id: updatedTicket.ticketId.hashCode,
          title: '¡Es tu turno en ${updatedTicket.service.serviceName}!',
          body: '¡Es tu turno! Por favor dirígete al mostrador.',
        );
      }
    } catch (e) {
      debugPrint('Error WS client topic: $e');
    }
  }

  Future<void> _handleQueueUpdatedEvent(String rawJson) async {
    try {
      final Map<String, dynamic> payload = json.decode(rawJson);

      if (payload['type'] != 'QUEUE_UPDATED') {
        return;
      }

      // Solo refrescamos posiciones locales
      // NO actualizamos directamente el ticket recibido por WS
      // porque puede pertenecer a otro usuario
      if (payload.containsKey('data')) {
        final updatedTicket = TicketQueueClient.fromJson(payload['data']);

        await _refreshServiceQueuePositions(
          updatedTicket.service.serviceId,
        );
      }
    } catch (e) {
      debugPrint('Error QUEUE_UPDATED: $e');
    }
  }

  Future<void> _refreshServiceQueuePositions(
      String serviceId,
      ) async {
    try {
      final ticketRepo = getIt<TicketRepository>();

      final serviceTickets = _tickets.where(
            (t) =>
        t.service.serviceId == serviceId &&
            t.status == 'WAITING',
      );

      for (final localTicket in serviceTickets) {
        try {
          final updated = await ticketRepo.getTicketPosition(
            serviceId,
            localTicket.client.clientId,
          );

          final index = _tickets.indexWhere(
                (t) => t.ticketId == localTicket.ticketId,
          );

          if (index == -1) {
            continue;
          }

          // Protección extra:
          // ignorar respuestas corruptas o de otros tickets
          if (updated.ticketId != localTicket.ticketId) {
            continue;
          }

          _tickets[index] = updated;
        } catch (e) {
          debugPrint(
            'Error actualizando posiciones: $e',
          );
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error refresh positions: $e');
    }
  }

  void _updateLocalTicket(
      TicketQueueClient updatedTicket,
      ) {
    final index = _tickets.indexWhere(
          (t) => t.ticketId == updatedTicket.ticketId,
    );

    // Ignorar tickets que no son míos
    if (index == -1) {
      return;
    }

    final currentTicket = _tickets[index];

    // Protección:
    // evitar reemplazar con tickets corruptos
    if (updatedTicket.ticketId.isEmpty) {
      return;
    }

    _tickets[index] = currentTicket.copyWith(
      status: updatedTicket.status,
      position: updatedTicket.position,
      joinedAt: updatedTicket.joinedAt,
      service: updatedTicket.service,
      client: updatedTicket.client,
    );

    notifyListeners();

    debugPrint(
      'WS actualizado: '
          '${updatedTicket.ticketId} '
          '${updatedTicket.status}',
    );
  }

  Future<bool> cancelTicket(String clientId) async {
    try {
      final index = _tickets.indexWhere(
        (t) => t.client.clientId == clientId && t.status == 'WAITING',
      );

      if (index == -1) {
        return false;
      }

      final originalTicket = _tickets[index];

      // UPDATE INMEDIATO UI
      _tickets[index] = originalTicket.copyWith(
        status: 'CANCELLED',
        position: 0,
      );

      notifyListeners();

      final repo = getIt<BusinessRepositoryImpl>();

      final success = await repo.cancelClientQueue(
        originalTicket.service.serviceId,
        clientId,
      );

      // ROLLBACK
      if (!success) {
        _tickets[index] = originalTicket;

        notifyListeners();

        return false;
      }

      debugPrint('Cancelación enviada correctamente');

      return true;
    } catch (e) {
      debugPrint('Error cancelando ticket: $e');

      return false;
    }
  }

  void disposeSubscriptions() {
    final wsService = getIt<StompService>();

    for (var serviceId in _activeWsSubscriptions) {
      try {
        wsService.unsubscribe('/topic/service/$serviceId/update');
      } catch (_) {}
    }

    _activeWsSubscriptions.clear();

    _isClientTopicSubscribed = false;
  }

  /// Limpia las conexiones de red y resetea la memoria local sin destruir el controlador
  void clearConnectionsAndData() {
    // 1. Limpiamos las suscripciones a los tópicos
    disposeSubscriptions();

    // 2. Desconectamos totalmente el WebSocket
    final wsService = getIt<StompService>();
    if (wsService.isConnected) {
      wsService.disconnect();
    }

    // 3. Reiniciamos todas las variables y listas del estado
    _selectedCategory = null;
    _search = '';
    _categories.clear();
    _services.clear();
    _tickets.clear();
    isLoading = false;

    // 4. Notificamos a la UI para que se refresque (en caso de que siga escuchando)
    notifyListeners();

    debugPrint('✅ Conexiones cerradas y memoria del ClientController limpiada.');
  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    disposeSubscriptions();

    super.dispose();
  }
}
