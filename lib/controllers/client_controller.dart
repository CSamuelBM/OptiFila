import 'package:flutter/material.dart';
import '../enum/turn_status_enum.dart';
import '../models/business_model.dart';
import '../models/turn_model.dart';

class ClientController extends ChangeNotifier {
  String _category = 'Todos';
  String _search   = '';

  String get selectedCategory => _category;

  static final List<BusinessModel> _allBusinesses = [
    const BusinessModel(id:'1', name:'Cafetería Central',    category:'Restaurante', address:'Av. Principal 123',    rating:4.8, queueCount:5,  waitMinutes:10),
    const BusinessModel(id:'2', name:'Salón Belleza Total',  category:'Belleza',     address:'Calle Bella 456',       rating:4.9, queueCount:10, waitMinutes:25),
    const BusinessModel(id:'3', name:'Banco Nacional',       category:'Banco',       address:'Avenida Bancaria 789',  rating:4.5, queueCount:3,  waitMinutes:15),
    const BusinessModel(id:'4', name:'Clínica Salud',        category:'Médico',      address:'Calle Médica 101',      rating:4.7, queueCount:15, waitMinutes:30),
  ];

  final List<TurnModel> _turns = [
    TurnModel(id:'t1', number:42, businessName:'Restaurante El Buen Sabor', businessType:'Restaurante', address:'Av. Principal 456',   dateTime: DateTime.now(),                                    status: TurnStatus.inProgress,    waitMinutes:12),
    TurnModel(id:'t2', number:15, businessName:'Salón de Belleza Elegance', businessType:'Belleza',     address:'Calle Secundaria 789', dateTime: DateTime.now().subtract(const Duration(days:1, hours:13)), status: TurnStatus.completed),
    TurnModel(id:'t3', number:28, businessName:'Banco Nacional',            businessType:'Banco',       address:'Plaza Central 123',   dateTime: DateTime(2026,3,15,10,15),                         status: TurnStatus.completed),
    TurnModel(id:'t4', number:7,  businessName:'Centro Médico Salud',       businessType:'Médico',      address:'Av. Médica 321',      dateTime: DateTime(2026,3,10,15,45),                         status: TurnStatus.canceled),
  ];

  List<BusinessModel> get filteredBusinesses {
    var list = _allBusinesses.toList();
    if (_category != 'Todos') {
      final map = {'Restaurantes':'Restaurante','Belleza':'Belleza','Bancos':'Banco'};
      list = list.where((b) => b.category == (map[_category] ?? '')).toList();
    }
    if (_search.isNotEmpty) list = list.where((b) => b.name.toLowerCase().contains(_search.toLowerCase())).toList();
    return list;
  }

  List<TurnModel> get allTurns       => _turns;
  List<TurnModel> get activeTurns    => _turns.where((t) => t.status == TurnStatus.inProgress).toList();
  List<TurnModel> get completedTurns => _turns.where((t) => t.status == TurnStatus.completed).toList();
  List<TurnModel> get cancelledTurns => _turns.where((t) => t.status == TurnStatus.canceled).toList();

  void setCategory(String c) { _category = c; notifyListeners(); }
  void setSearch(String s)   { _search = s;   notifyListeners(); }
}