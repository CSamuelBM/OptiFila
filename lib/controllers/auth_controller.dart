import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/login_result.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository_impl.dart';
import '../requests/client_request.dart';
import '../requests/user_request.dart';

class AuthController extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  ClientModel? _client;
  UserModel? _service;

  bool _isService = false;
  bool _loading = false;
  String? _error;

  /// ─── GETTERS ──────────────────────────────────────────
  ClientModel? get client => _client;
  UserModel? get service => _service;
  bool get isService => _isService;
  bool get isLoading => _loading;
  String? get error => _error;

  Object? get user => null;

  /// ─── LOGIN ────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final LoginResult result =
      await _authRepository.login(email, password);

      _isService = result.role == 'SERVICE';

      if (_isService) {
        _service = result.service;
        _client = null;
      } else {
        _client = result.client;
        _service = null;
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// ─── SIGNUP CLIENTE ───────────────────────────────────
  Future<bool> registerClient({
    required String firstName,
    required String lastName,
    required String secondLastName,
    required String email,
    required String password, required String name,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final request = ClientRequest(
        firstName: firstName,
        lastName: lastName,
        secondLastName: secondLastName,
        email: email,
        password: password,
      );

      _client = await _authRepository.signupClient(request);
      _service = null;
      _isService = false;

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// ─── SIGNUP SERVICIO ──────────────────────────────────
  Future<bool> registerService({
    required String serviceName,
    required String email,
    required String password,
    required String categoryId,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final request = UserRequest(
        serviceName: serviceName,
        email: email,
        password: password,
        categoryId: categoryId,
      );

      _service = await _authRepository.signupService(request);
      _client = null;
      _isService = true;

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// ─── LOGOUT ───────────────────────────────────────────
  void logout() {
    _client = null;
    _service = null;
    _isService = false;
    notifyListeners();
  }

  Future<Object?> registerBusiness({required String name, required String email, required String password, required String businessName, required String category}) async {}
}