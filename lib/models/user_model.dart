class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final int totalTurnos;
  final int activeTurnos;
  final int favorites;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone        = '',
    this.location     = '',
    this.totalTurnos  = 0,
    this.activeTurnos = 0,
    this.favorites    = 0,
  });

  //FROM JSON (Backend → App)
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone']?.toString() ?? '',
        location: json['location'] ?? '',
        totalTurnos: json['total_turnos'] ?? 0,
        activeTurnos: json['active_turnos'] ?? 0,
        favorites: json['favorites'] ?? 0);
  }

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'email' : email,
      'phone' : phone,
      'location' : location,
      'total_turnos' : totalTurnos,
      'active_turnos' : activeTurnos,
      'favorites' : favorites,
    };
  }

  // COPY WITH (Estado local)
  UserModel copyWith({String? name, String? email, String? phone, String? location,
                      int? totalTurnos, int? activeTurnos, int? favorites}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      totalTurnos: totalTurnos ?? this.totalTurnos,
      activeTurnos: activeTurnos ?? this.activeTurnos,
      favorites: favorites ?? this.favorites,
    );
  }
}