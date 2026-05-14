class ClientSummary {
  final String clientId;
  final String fullName;

  const ClientSummary({
    required this.clientId,
    required this.fullName,
   });

  factory ClientSummary.fromJson(Map<String, dynamic> json){
    return ClientSummary(
      clientId: json['clientId']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}