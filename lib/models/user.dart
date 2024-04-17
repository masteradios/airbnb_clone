import 'package:airbnb_clone/models/places.dart';

class ModelUser {
  final String id;
  final String token;
  final String username;
  final String email;
  final String password;
  final String address;
  final List<ModelPlace> wishList;
  ModelUser(
      {required this.id,
      required this.token,
      required this.wishList,
      required this.username,
      required this.email,
      required this.password,
      required this.address});

  ModelUser copyWith({
    String? id,
    String? token,
    String? username,
    String? email,
    String? password,
    String? address,
    List<ModelPlace>? wishList,
  }) {
    return ModelUser(
        id: id ?? this.id,
        token: token ?? this.token,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        address: address ?? this.address,
        wishList: wishList ?? this.wishList);
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'wishlist': wishList
    };
  }

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
        wishList: List<ModelPlace>.from(
          map['wishList'].map(
            (x) => ModelPlace.fromMap(x['hotel']),
          ),
        ),
        id: map['_id'] ?? '',
        token: map['token'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        address: map['address'] ?? '');
  }

  // ModelUser copyWith(
  //     {String? id,
  //     String? token,
  //     String? username,
  //     String? email,
  //     String? password,
  //     String? address}) {
  //   return ModelUser(
  //     id: id ?? this.id,
  //     token: token ?? this.token,
  //     username: username ?? this.username,
  //     email: email ?? this.email,
  //     password: password ?? this.password,
  //     address: address ?? this.address,
  //   );
  // }
}
