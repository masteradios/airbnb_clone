class ModelUser {
  final String id;
  final String token;
  final String username;
  final String email;
  final String password;
  final String address;

  ModelUser(
      {required this.id,
      required this.token,
      required this.username,
      required this.email,
      required this.password,
      required this.address});

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
    };
  }

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
        id: map['_id'] ?? '',
        token: map['token'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        password: map['password']?? '',
        address: map['address'] ?? '');
  }
}
