import '../models/service/ticket_queue_client.dart';

abstract class TicketRepository {

  // El que ya tienes:
  Future<List<TicketQueueClient>> getClientTickets(String? clientId);

  // EL NUEVO MÉTODO A AGREGAR:
  Future<TicketQueueClient> getTicketPosition(String serviceId, String? clientId);
}