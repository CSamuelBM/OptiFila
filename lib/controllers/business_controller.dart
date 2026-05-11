import 'package:flutter/material.dart';
import '../enum/turn_status_enum.dart';
import '../models/turn_model.dart';
import '../models/client_model.dart';

class BusinessController extends ChangeNotifier {
  // ─── Métricas (temporal mock, luego backend) ───
  int _currentTurn = 38;
  int _inQueue = 4;
  int _avgMinutes = 8;
  int _attendedToday = 24;
  double _satisfaction = 0.98;

  String _clientSearch = '';

  int get currentTurn => _currentTurn;
  int get inQueue => _inQueue;
  int get avgMinutes => _avgMinutes;
  int get attendedToday => _attendedToday;
  double get satisfaction => _satisfaction;

  // ─── Cola (sigue mock por ahora) ───
  List<TurnModel> _queue = [
    TurnModel(
      id: 'q1',
      number: 39,
      businessName: 'Mi Negocio',
      businessType: 'Restaurante',
      address: '',
      dateTime: DateTime(2026, 5, 2, 14, 10),
      status: TurnStatus.inProgress,
    ),
    TurnModel(
      id: 'q2',
      number: 40,
      businessName: 'Mi Negocio',
      businessType: 'Restaurante',
      address: '',
      dateTime: DateTime(2026, 5, 2, 14, 15),
      status: TurnStatus.inProgress,
    ),
  ];

  // ─── Clientes (YA CON ClientModel REAL) ───
  final List<ClientModel> _clients = [
    ClientModel(
      id: 'c1',
      firstName: 'María',
      lastName: 'González',
      secondLastName: '',
      email: 'maria@email.com',
    ),
    ClientModel(
      id: 'c2',
      firstName: 'Carlos',
      lastName: 'Rodríguez',
      secondLastName: '',
      email: 'carlos@email.com',
    ),
    ClientModel(
      id: 'c3',
      firstName: 'Ana',
      lastName: 'Martínez',
      secondLastName: '',
      email: 'ana@email.com',
    ),
  ];

  List<TurnModel> get queue => _queue;

  // ─── Búsqueda adaptada al modelo real ───
  List<ClientModel> get filteredClients {
    if (_clientSearch.isEmpty) return _clients;

    final q = _clientSearch.toLowerCase();

    return _clients.where((c) {
      final fullName =
      '${c.firstName} ${c.lastName} ${c.secondLastName}'.toLowerCase();
      return fullName.contains(q) || c.email.toLowerCase().contains(q);
    }).toList();
  }

  int get totalClients => _clients.length;

  // ─── Acciones ───
  void nextTurn() {
    if (_queue.isNotEmpty) {
      _currentTurn = _queue.first.number;
      _queue = _queue.sublist(1);
      _inQueue = _queue.length;
      _attendedToday++;
      notifyListeners();
    }
  }

  void searchClients(String q) {
    _clientSearch = q;
    notifyListeners();
  }
}