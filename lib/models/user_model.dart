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
    this.phone       = '',
    this.location    = '',
    this.totalTurnos  = 0,
    this.activeTurnos = 0,
    this.favorites   = 0,
  });

  UserModel copyWith({String? name, String? email, String? phone, String? location}) {
    return UserModel(
      id: id, name: name ?? this.name, email: email ?? this.email,
      phone: phone ?? this.phone, location: location ?? this.location,
      totalTurnos: totalTurnos, activeTurnos: activeTurnos, favorites: favorites,
    );
  }
}