class UserRequest {
  final String serviceName;
  final String categoryId;
  final String email;
  final String password;

  const UserRequest({
    required this.serviceName,
    required this.categoryId,
    required this.email,
    required this.password,
  });

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson() {
    return {
      'serviceName':    serviceName,
      'categoryId':     categoryId,
      'email':          email,
      'password':       password,
    };
  }
}