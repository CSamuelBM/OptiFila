class UpdateTicketStatusRequest {
  final String clientId;

  UpdateTicketStatusRequest({required this.clientId});

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
    };
  }
}