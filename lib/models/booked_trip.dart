import 'package:airbnb_clone/models/places.dart';

class BookedTrip {
  final String tripid;
  final String userid;
  final int numberOfGuests;
  final int numberOfDays;
  final ModelPlace place;
  final int totalAmount;

  BookedTrip(
      {required this.tripid,
      required this.userid,
      required this.numberOfGuests,
      required this.numberOfDays,
      required this.place,
      required this.totalAmount});

  Map<String, dynamic> toMap() {
    return {
      'tripid': tripid,
      'userid': userid,
      'numberOfGuests': numberOfGuests,
      'numberOfDays': numberOfDays,
      'place': place.toMap(),
      'totalAmount': totalAmount,
    };
  }

  factory BookedTrip.fromMap(Map<String, dynamic> map) {
    return BookedTrip(
        tripid: map['_id'] ?? '',
        userid: map['userid'] ?? '',
        numberOfGuests: map['numberOfGuests'] ?? '',
        numberOfDays: map['numberOfDays'] ?? '',
        place: map['place']?.map(
          (x) => ModelPlace.fromMap(x['place']),
        ),
        totalAmount: map['totalAmount'] ?? '');
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
