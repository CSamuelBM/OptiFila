class UserModel {
  final String id;
  final String serviceName;
  final String categoryId;
  final String email;

  const UserModel({
    required this.id,
    required this.serviceName,
    required this.categoryId,
    required this.email,
  });

  //FROM JSON (Backend → App)
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        id: json['id']?.toString() ?? '',
        serviceName: json['serviceName'] ?? '',
        categoryId: json['serviceCategory']?['categoryId']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
    );
  }

  // COPY WITH (Estado local)
  UserModel copyWith({String? serviceName, String? categoryId, String? email}) {
    return UserModel(
      id: id,
      serviceName: serviceName ?? this.serviceName,
      categoryId: categoryId ??   this.categoryId,
      email: email ??             this.email,
    );
  }
}