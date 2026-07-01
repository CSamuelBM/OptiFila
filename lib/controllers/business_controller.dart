import 'dart:convert';
import 'package:flutter/material.dart';
import '../app_controllers.dart';
import '../core/di/injection_dart.dart';
import '../core/network/ws/stomp_service.dart';
import '../models/service/ticket_queue_client.dart';
import '../repositories/api_rest/business_repository_imp.dart';

class BusinessController extends ChangeNotifier
    with WidgetsBindingObserver {
  final BusinessRepositoryImpl _repository = getIt<BusinessRepositoryImpl>();
  final StompService _wsService = getIt<StompService>();
  String? _currentBusinessId;
  List<TicketQueueClient> _activeQueue = [];
  bool _isLoading = false;

  List<TicketQueueClient> get activeQueue => _activeQueue;

  bool get isLoading => _isLoading;

  List<TicketQueueClient> get servingTickets => _activeQueue
      .where(
        (t) =>
    t.status.toLowerCase() == 'serving' ||
        t.status.toLowerCase() == 'in_progress',
  )
      .toList();

  List<TicketQueueClient> get waitingTickets =>
      _activeQueue.where((t) => t.status.toLowerCase() == 'waiting').toList();

  int get inQueueCount => waitingTickets.length;

  String get currentTurnLabel => servingTickets.isNotEmpty
      ? servingTickets.first.position.toString()
      : '--';
  BusinessController() {
    WidgetsBinding.instance.addObserver(this);
  }
  // ─── CARGA INICIAL (REST) ───
  Future<void> loadDashboardData() async {
    final businessId = AppControllers.auth.service?.id ?? '';
    _currentBusinessId = businessId;
    if (businessId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Loading queue data for business ID: $businessId');
      _activeQueue = await _repository.getClientsInQueue(businessId);
    } catch (e) {
      debugPrint('Error loading queue: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {

    if (state == AppLifecycleState.resumed) {

      debugPrint(
        '🔄 Business app resumed -> reconectando WS',
      );

      if (!_wsService.isConnected &&
          _currentBusinessId != null &&
          _currentBusinessId!.isNotEmpty) {

        _wsService.connect(
          onConnected: () {

            debugPrint(
              '✅ Business WS reconectado',
            );

            initRealTimeUpdates();

            loadDashboardData();
          },
        );
      }
    }

    if (state == AppLifecycleState.paused) {

      debugPrint(
        '⏸️ Business app en background',
      );
    }
  }

  // ─── LÓGICA DE TIEMPO REAL (WS - MVP) ───

  void initRealTimeUpdates() {

    final businessId =
        AppControllers.auth.service?.id ?? '';

    _currentBusinessId = businessId;

    if (businessId.isEmpty) return;

    if (_wsService.isConnected) {

      _subscribeToTopics(businessId);

      return;
    }

    _wsService.connect(
      onConnected: () {

        _subscribeToTopics(businessId);
      },
    );
  }

  void _handleQueueUpdatedEvent(String rawJson) {
    try {
      final Map<String, dynamic> data = json.decode(rawJson);

      if (data['type'] == 'QUEUE_UPDATED') {
        debugPrint('WS: Cola actualizada globalmente. Sincronizando datos...');
        loadDashboardData();
      }
    } catch (e) {
      debugPrint('Error al procesar mensaje WS (QUEUE_UPDATED): $e');
    }
  }
  void _subscribeToTopics(String businessId) {

    // Actualizaciones globales
    _wsService.subscribe(
      '/topic/service/$businessId/update',
          (message) {

        if (message != null &&
            message.isNotEmpty) {

          _handleQueueUpdatedEvent(message);
        }
      },
    );

    // Nuevos tickets
    _wsService.subscribe(
      '/topic/service/$businessId',
          (message) {

        if (message != null &&
            message.isNotEmpty) {

          _handleNewClientJoinedEvent(message);
        }
      },
    );

    debugPrint(
      '✅ Business subscriptions activas',
    );
  }

  void _handleNewClientJoinedEvent(String rawJson) {
    try {
      final Map<String, dynamic> payload = json.decode(rawJson);

      // Verificamos si es el evento correcto y si trae la data del ticket
      if (payload['type'] == 'TICKET_CREATED' && payload.containsKey('data')) {
        final ticketData = payload['data'];
        final newTicket = TicketQueueClient.fromJson(ticketData);

        // Validar si el ID viene vacío por error de parseo o diferencia con la BD
        if (newTicket.ticketId.isEmpty) {
          debugPrint('WS: El nuevo cliente llegó con ID vacío. Se fuerza recarga completa para asegurar datos consistentes.');
          loadDashboardData();
          return;
        }

        // Verificamos que no esté duplicado antes de agregarlo
        final isDuplicate = _activeQueue.any((t) => t.ticketId == newTicket.ticketId);
        debugPrint('WS: Nuevo cliente recibido: ${newTicket.client.fullName} (ID: ${newTicket.ticketId}). ¿Duplicado? $isDuplicate');

        if (!isDuplicate) {
          _activeQueue.add(newTicket);
          debugPrint('WS: Nuevo cliente agregado localmente a la cola: ${newTicket.client.fullName}');
          notifyListeners(); // Actualiza la UI de inmediato
        }
      } else {
        // Si llega otro tipo de mensaje o no trae la info necesaria, sincronizamos
        debugPrint('WS: Mensaje recibido no es TICKET_CREATED o falta data. Sincronizando datos...');
        loadDashboardData();
      }

    } catch (e) {
      debugPrint('Error al procesar nuevo cliente WS. Recargando datos de respaldo... Error: $e');
      loadDashboardData();
    }
  }

  // ─── ACCIONES ───
  Future<void> completeTicket(String clientId) async {
    final businessId = AppControllers.auth.service?.id ?? '';
    try {
      bool success = await _repository.markClientAsServed(businessId, clientId);
      if (success) {
        debugPrint('Cliente marcado como atendido: $clientId');
        await loadDashboardData();
      } else {
        debugPrint('Error al marcar cliente como atendido: $clientId');
      }
    } catch (e) {
      debugPrint('Error completing ticket: $e');
    }
  }

  Future<void> cancelTicket(String clientId) async {
    final businessId = AppControllers.auth.service?.id ?? '';
    try {
      bool success = await _repository.cancelClientQueue(businessId, clientId);
      if (success) {
        debugPrint('Cliente marcado como cancelado: $clientId');
        await loadDashboardData();
      } else {
        debugPrint('Error al marcar cliente como cancelado: $clientId');
      }
    } catch (e) {
      debugPrint('Error cancelling ticket: $e');
    }
  }

  Future<void> nextTicket() async {
    final businessId = AppControllers.auth.service?.id ?? '';
    try {
      bool success = await _repository.callNextClient(businessId);
      if (success) {
        debugPrint('Siguiente cliente llamado.');
        await loadDashboardData();
      } else {
        debugPrint('Error al llamar al siguiente cliente');
      }
    } catch (e) {
      debugPrint('Error calling ticket: $e');
    }
  }

  Future<void> missedTicket(String clientId) async {
    final businessId = AppControllers.auth.service?.id ?? '';
    try {
      bool success = await _repository.markClientAsNoShow(businessId, clientId);
      if (success) {
        debugPrint('Cliente marcado como perdido: $clientId');
        await loadDashboardData();
      } else {
        debugPrint('Error al marcar cliente como perdido: $clientId');
      }
    } catch (e) {
      debugPrint('Error completing ticket: $e');
    }
  }
  /// Limpia las conexiones de red y resetea la memoria local sin destruir el controlador
  void clearConnectionsAndData() {
    // 1. Desconectamos totalmente el WebSocket
    if (_wsService.isConnected) {
      _wsService.disconnect();
    }

    // 2. Reiniciamos la lista de turnos y estado de carga
    _activeQueue.clear();
    _isLoading = false;

    // 3. Notificamos a la UI para que vuelva a su estado por defecto
    notifyListeners();

    debugPrint('✅ Conexiones cerradas y memoria del BusinessController limpiada.');
  }
  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    _wsService.disconnect();

    super.dispose();
  }
}