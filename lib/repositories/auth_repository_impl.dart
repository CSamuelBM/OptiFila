import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_model.dart';
import '../models/login_result.dart';
import '../models/user_model.dart';
import '../requests/client_request.dart';
import '../requests/user_request.dart';

class AuthRepositoryImpl {
  static const String _baseUrl =
      'https://backi251-optifila-backend.hf.space/api/v1';

  /// ✅ SIGNUP CLIENTE
  Future<ClientModel> signupClient(ClientRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup/client'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al crear cliente');
    }

    final decoded = jsonDecode(response.body);
    return ClientModel.fromJson(decoded['data']['user']);
  }

  /// ✅ SIGNUP SERVICIO
  Future<UserModel> signupService(UserRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup/service'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al registrar negocio');
    }

    final decoded = jsonDecode(response.body);
    return UserModel.fromJson(decoded['data']['user']);
  }

  /// ✅ LOGIN (cliente o servicio)
  Future<LoginResult> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Credenciales incorrectas');
    }

    final decoded = jsonDecode(response.body);
    final role = decoded['data']['role'];
    final userJson = decoded['data']['user'];

    if (role == 'SERVICE') {
      return LoginResult(
        role: role,
        service: UserModel.fromJson(userJson),
      );
    } else {
      return LoginResult(
        role: role,
        client: ClientModel.fromJson(userJson),
      );
    }
  }
}