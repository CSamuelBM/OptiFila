import 'package:optifila/models/business_model.dart';
import 'package:optifila/models/service/ticket_queue_client.dart';

import '../models/client_model.dart';
import '../models/service/service_model.dart';

abstract class BusinessRepository {
  Future<List<BusinessModel>> getBusiness();
  Future<List<TicketQueueClient>> getClientsInQueue(String businessId);
  Future<bool> callNextClient(String serviceId);
  Future<bool> markClientAsServed(String serviceId, String clientId);
  Future<bool> cancelClientQueue(String serviceId, String clientId);
  Future<bool> markClientAsNoShow(String serviceId, String clientId);
  Future<List<ServiceModel>> getServices(String? categoryId);
  Future<TicketQueueClient> joinQueueService(String serviceId, String clientId);
}