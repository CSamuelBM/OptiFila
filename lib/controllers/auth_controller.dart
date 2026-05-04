import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _user;
  bool       _isBusiness = false;
  bool       _loading    = false;
  String?    _error;

  UserModel? get user        => _user;
  bool       get isBusiness  => _isBusiness;
  bool       get isLoading   => _loading;
  String?    get error       => _error;

  Future<bool> login(String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));

    if (email.isEmpty || password.isEmpty) {
      _error = 'Completa todos los campos'; _loading = false; notifyListeners(); return false;
    }
    _isBusiness = email == 'negocio@email.com';
    _user = _isBusiness
      ? const UserModel(id: '1', name: 'Mi Negocio',  email: 'negocio@email.com', phone: '+1 234 567 8900', location: 'Ciudad, País')
      : const UserModel(id: '2', name: 'Usuario',      email: 'usuario@email.com',  phone: '+1 234 567 8900', location: 'Ciudad, País', totalTurnos: 24, activeTurnos: 1, favorites: 5);
    _loading = false; notifyListeners(); return true;
  }

  Future<bool> registerBusiness({
    required String name, required String email,
    required String password, required String businessName, required String category,
  }) async {
    _loading = true; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _isBusiness = true;
    _user = UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, email: email);
    _loading = false; notifyListeners(); return true;
  }

  Future<bool> registerClient({required String name, required String email, required String password}) async {
    _loading = true; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _isBusiness = false;
    _user = UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, email: email);
    _loading = false; notifyListeners(); return true;
  }

  void logout() { _user = null; _isBusiness = false; notifyListeners(); }
}