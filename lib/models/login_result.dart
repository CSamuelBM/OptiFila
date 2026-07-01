import 'package:optifila/models/user_model.dart';
import 'client_model.dart';

class LoginResult {
  final String role;
  final ClientModel? client;
  final UserModel? service;

  const LoginResult({
    required this.role,
    this.client,
    this.service,
  });
}