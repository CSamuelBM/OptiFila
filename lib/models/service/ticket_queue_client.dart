import 'package:optifila/models/service/client_summary.dart';
import 'package:optifila/models/service/service_model.dart';

class TicketQueueClient {
  final String ticketId;

  final ClientSummary client;

  final ServiceModel service;

  final String status;

  final DateTime joinedAt;

  final int position;

  TicketQueueClient({
    required this.ticketId,
    required this.service,
    required this.client,
    required this.status,
    required this.joinedAt,
    required this.position,
  });

  factory TicketQueueClient.fromJson(
      Map<String, dynamic> json,
      ) {
    return TicketQueueClient(
      ticketId: json['ticket_id'] ?? '',

      service: ServiceModel.fromJson(
        json['service'] ?? {},
      ),

      client: ClientSummary.fromJson(
        json['client'] ?? {},
      ),

      status: json['status'] ?? '',

      joinedAt: DateTime.parse(
        json['joinedAt'] ??
            DateTime.now().toIso8601String(),
      ),

      position: json['position'] ?? 0,
    );
  }

  TicketQueueClient copyWith({
    String? ticketId,
    ClientSummary? client,
    ServiceModel? service,
    String? status,
    DateTime? joinedAt,
    int? position,
  }) {
    return TicketQueueClient(
      ticketId: ticketId ?? this.ticketId,

      service: service ?? this.service,

      client: client ?? this.client,

      status: status ?? this.status,

      joinedAt: joinedAt ?? this.joinedAt,

      position: position ?? this.position,
    );
  }
}