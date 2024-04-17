import 'package:airbnb_clone/models/booked_trip.dart';
import 'package:airbnb_clone/models/places.dart';
import 'package:flutter/cupertino.dart';

class BookedTripProvider extends ChangeNotifier {
  List<BookedTrip> _tripList = [
    BookedTrip(
        tripid: '',
        userid: '',
        numberOfGuests: 0,
        numberOfDays: 0,
        place: ModelPlace(
            id: '',
            owner: '',
            hotelName: '',
            price: 0,
            numberOfReviews: 0,
            lat: 0,
            long: 0,
            imageUrl: '',
            description: ''),
        totalAmount: 0,
        startDate: '',
        endDate: '')
  ];
  List<BookedTrip> get tripList => _tripList;

  void getTripDetails(List<BookedTrip> tripList) {
    _tripList.remove(_tripList.first);
    _tripList = tripList;
    notifyListeners();
  }
}
