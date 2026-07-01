import 'package:flutter/cupertino.dart';
import 'package:optifila/models/service/service_model.dart';
import 'package:optifila/models/service/ticket_queue_client.dart';

import '../../core/network/rest/api_client.dart';
import '../../models/business_model.dart';
import '../../models/dto/ticket_status_request.dart';
import '../business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final ApiClient _apiClient;
  BusinessRepositoryImpl(this._apiClient);

  @override
  Future<List<BusinessModel>> getBusiness() async {
    return [];
  }

  @override
  Future<List<TicketQueueClient>> getClientsInQueue(String businessId) async {
    final decoded = await _apiClient.get(
      '/service/$businessId/active-queue',
    );
    return (decoded['data'] as List)
        .map((json) => TicketQueueClient.fromJson(json))
        .toList();
  }

  @override
  Future<bool> callNextClient(String serviceId) async {
    final decoded = await _apiClient.patch(
      '/service/$serviceId/call-next',
    );
    return (decoded['success'] == true);
  }

  @override
  Future<bool> cancelClientQueue(String serviceId, String clientId) async {
    try {
      final request = UpdateTicketStatusRequest(clientId: clientId);

      await _apiClient.patch(
        '/tickets/$serviceId/cancel',
        body: request.toJson(),
      );
      return true;
    } catch (e) {
      debugPrint('Error al cancelar turno: $e');
      return false;
    }
  }

  @override
  Future<bool> markClientAsNoShow(String serviceId, String clientId) async {
    try {
      final request = UpdateTicketStatusRequest(clientId: clientId);

      await _apiClient.patch(
        '/tickets/$serviceId/no-show',
        body: request.toJson(),
      );
      return true;
    } catch (e) {
      debugPrint('Error al marcar como No Show: $e');
      return false;
    }
  }

  @override
  Future<bool> markClientAsServed(String serviceId, String clientId) async {
    try {
      final request = UpdateTicketStatusRequest(clientId: clientId);

      await _apiClient.patch(
        '/tickets/$serviceId/complete',
        body: request.toJson(),
      );
      return true;
    } catch (e) {
      debugPrint('Error al marcar como atendido: $e');
      return false;
    }
  }

  @override
  Future<List<ServiceModel>> getServices(String? categoryName) async {
    try {
      final queryParams = categoryName != null ? {'category': categoryName} : null;
      return _apiClient.get('/service', queryParams: queryParams).then((decoded) {
        final List list = decoded['data'];
        return list.map((e) => ServiceModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error al obtener servicios: $e');
      return Future.value([]);
    }
  }

  @override
  Future<TicketQueueClient> joinQueueService(String serviceId, String clientId) {
    try {
      return _apiClient.post(
        '/tickets/join/$serviceId',
        body: {'clientId': clientId},
      ).then((decoded) {
        return TicketQueueClient.fromJson(decoded['data']);
      });
    } catch (e) {
      debugPrint('Error al unirse a la cola: $e');
      return Future.error(e);
    }
  }
}