import 'dart:math';

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

  //FROM JSON (Backend → App)
  factory ClientModel.fromJson(Map<String, dynamic> json){
    return ClientModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone']?.toString() ?? '',
        lastVisit: DateTime.parse(json['last_visit']),
        totalVisits: json['total_visits'] ?? 0,
        isInTurn: json['is_in_turn'] ?? false);
  }

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'name' : name,
      'email' : email,
      'phone' : phone,
      'last_visit' : lastVisit,
      'total_visits' : totalVisits,
      'is_in_turn' : isInTurn,
    };
  }
}