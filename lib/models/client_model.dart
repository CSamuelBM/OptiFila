class ClientModel {
  final String   id;
  final String   name;
  final String   email;
  final String   phone;
  final DateTime lastVisit;
  final int      totalVisits;
  final bool     isInTurn;

  const ClientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.lastVisit,
    required this.totalVisits,
    this.isInTurn = false,
  });
}