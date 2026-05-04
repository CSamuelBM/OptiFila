enum TurnStatus {
  active, completed, cancelled;

  static TurnStatus fromBackend(String value){
    switch(value){
      case 'active':
        return TurnStatus.active;
      case 'completed':
        return TurnStatus.completed;
      case 'cancelled':
        return TurnStatus.cancelled;
      default:
        return TurnStatus.active;
    }
  }

  // Texto para la UI (NO backend)
  String toSpanish(){
    switch(this){
      case TurnStatus.active:
        return 'Activo';
      case TurnStatus.completed:
        return 'Completado';
      case TurnStatus.cancelled:
        return 'Cancelado';
    }
  }

  // Enviar status al backend
  String toBackend(){
    return name;
  }
}

class TurnModel {
  final String     id;
  final int        number;
  final String     businessName;
  final String     businessType;
  final String     address;
  final DateTime   dateTime;
  final TurnStatus status;
  final int?       waitMinutes;

  const TurnModel({
    required this.id,
    required this.number,
    required this.businessName,
    required this.businessType,
    required this.address,
    required this.dateTime,
    required this.status,
    this.waitMinutes,
  });

  //FROM JSON (Backend → App)
  factory TurnModel.fromJson(Map<String, dynamic> json){
    return TurnModel(
        id: json['id']?.toString() ?? '',
        number: json['number'] ?? 0,
        businessName: json['business_name'] ?? '',
        businessType: json['business_type'] ?? '',
        address: json['address'] ?? '',
        dateTime: DateTime.parse(json['date_time']),
        status: TurnStatus.fromBackend(json['status']),
        waitMinutes: json['wait_minutes']);
  }

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'number' : number,
      'business_name' : businessName,
      'business_type' : businessType,
      'address' : address,
      'date_time' : dateTime.toIso8601String(),
      'status' : status.toBackend(),
      'wait_minutes' : waitMinutes,
    };
  }
}