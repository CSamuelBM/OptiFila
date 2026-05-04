import 'package:flutter/material.dart';
import '../models/turn_model.dart';
import '../models/client_model.dart';

class BusinessController extends ChangeNotifier {
  int    _currentTurn    = 38;
  int    _inQueue        = 4;
  int    _avgMinutes     = 8;
  int    _attendedToday  = 24;
  double _satisfaction   = 0.98;
  String _clientSearch   = '';

  int    get currentTurn   => _currentTurn;
  int    get inQueue        => _inQueue;
  int    get avgMinutes     => _avgMinutes;
  int    get attendedToday  => _attendedToday;
  double get satisfaction   => _satisfaction;

  List<TurnModel> _queue = [
    TurnModel(id:'q1', number:39, businessName:'Mi Negocio', businessType:'Restaurante', address:'', dateTime: DateTime(2026,5,2,14,10), status: TurnStatus.active),
    TurnModel(id:'q2', number:40, businessName:'Mi Negocio', businessType:'Restaurante', address:'', dateTime: DateTime(2026,5,2,14,15), status: TurnStatus.active),
    TurnModel(id:'q3', number:41, businessName:'Mi Negocio', businessType:'Restaurante', address:'', dateTime: DateTime(2026,5,2,14,20), status: TurnStatus.active),
    TurnModel(id:'q4', number:42, businessName:'Mi Negocio', businessType:'Restaurante', address:'', dateTime: DateTime(2026,5,2,14,25), status: TurnStatus.active),
  ];

  final List<ClientModel> _clients = [
    ClientModel(id:'c1', name:'María González',  email:'maria@email.com',  phone:'+1 234 567 8901', lastVisit: DateTime.now(),                             totalVisits:12, isInTurn:true),
    ClientModel(id:'c2', name:'Carlos Rodríguez',email:'carlos@email.com', phone:'+1 234 567 8902', lastVisit: DateTime.now().subtract(const Duration(days:1)), totalVisits:8),
    ClientModel(id:'c3', name:'Ana Martínez',    email:'ana@email.com',    phone:'+1 234 567 8903', lastVisit: DateTime.now().subtract(const Duration(days:3)), totalVisits:5),
    ClientModel(id:'c4', name:'Luis García',     email:'luis@email.com',   phone:'+1 234 567 8904', lastVisit: DateTime.now().subtract(const Duration(days:7)), totalVisits:3),
  ];

  List<TurnModel>   get queue           => _queue;
  List<ClientModel> get filteredClients {
    if (_clientSearch.isEmpty) return _clients;
    return _clients.where((c) =>
      c.name.toLowerCase().contains(_clientSearch.toLowerCase()) ||
      c.email.toLowerCase().contains(_clientSearch.toLowerCase())
    ).toList();
  }
  int get totalClients    => _clients.length;
  int get todayClients    => _clients.where((c) => _isToday(c.lastVisit)).length;
  int get weekClients     => 40;

  bool _isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  void nextTurn() {
    if (_queue.isNotEmpty) {
      _currentTurn = _queue.first.number;
      _queue = _queue.sublist(1);
      _inQueue = _queue.length;
      _attendedToday++;
      notifyListeners();
    }
  }
  void searchClients(String q) { _clientSearch = q; notifyListeners(); }
}