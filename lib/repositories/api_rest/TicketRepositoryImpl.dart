import 'package:optifila/core/network/rest/api_client.dart';
import 'package:optifila/models/service/ticket_queue_client.dart';
import 'package:optifila/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {

  final ApiClient _apiClient;

  TicketRepositoryImpl(this._apiClient);

  @override
  Future<List<TicketQueueClient>> getClientTickets(
      String? clientId,
      ) async {

    final decoded = await _apiClient.get(
      '/tickets/details/$clientId',
    );

    final List list = decoded['data'];

    return list
        .map((e) => TicketQueueClient.fromJson(e))
        .toList();
  }

  @override
  Future<TicketQueueClient> getTicketPosition(
      String serviceId,
      String? clientId,
      ) async {

    final decoded = await _apiClient.get(
      '/tickets/$serviceId/position/$clientId',
    );

    return TicketQueueClient.fromJson(
      decoded['data'],
    );
  }
}