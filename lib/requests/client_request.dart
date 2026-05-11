class ClientRequest {
  final String firstName;
  final String lastName;
  final String secondLastName;
  final String email;
  final String password;


  const ClientRequest({
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.email,
    required this.password,
  });

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson() {
    return {
      'firstName':      firstName,
      'lastName':       lastName,
      'secondLastName': secondLastName,
      'email':          email,
      'password':       password,
    };
  }

}