import '../core/network/rest/api_client.dart';
import '../models/client_model.dart';
import '../models/login_result.dart';
import '../models/user_model.dart';
import '../requests/client_request.dart';
import '../requests/user_request.dart';

class AuthRepositoryImpl {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  /// =========================
  /// SIGNUP CLIENTE
  /// =========================
  Future<ClientModel> signupClient(
      ClientRequest request,
      ) async {
    final decoded = await _apiClient.post(
      '/auth/signup/client',
      body: request.toJson(),
    );

    return ClientModel.fromJson(
      decoded['data']['user'],
    );
  }

  /// =========================
  /// SIGNUP SERVICIO
  /// =========================
  Future<UserModel> signupService(
      UserRequest request,
      ) async {
    final decoded = await _apiClient.post(
      '/auth/signup/service',
      body: request.toJson(),
    );

    return UserModel.fromJson(
      decoded['data']['user'],
    );
  }

  /// =========================
  /// LOGIN
  /// =========================
  Future<LoginResult> login(
      String email,
      String password,
      ) async {
    final decoded = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final role = decoded['data']['role'];
    final userJson = decoded['data']['user'];

    if (role == 'SERVICE') {
      return LoginResult(
        role: role,
        service: UserModel.fromJson(userJson),
      );
    }

    return LoginResult(
      role: role,
      client: ClientModel.fromJson(userJson),
    );
  }
}