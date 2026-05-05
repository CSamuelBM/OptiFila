import 'dart:math';

class ClientModel {
  final String   id;
  final String   firstName;
  final String   lastName;
  final String   secondLastName;
  final String   email;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.email,
  });

  //FROM JSON (Backend → App)
  factory ClientModel.fromJson(Map<String, dynamic> json){
    return ClientModel(
        id: json['id']?.toString() ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        secondLastName: json['secondLastName'] ?? '',
        email: json['email'] ?? '',
    );
  }

}