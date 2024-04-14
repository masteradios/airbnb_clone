import 'dart:math';

import 'package:geolocator/geolocator.dart';

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

// Function to calculate distance between two points in kilometers
double calculateDistance(LatLng pointA, LatLng pointB) {
  const int earthRadius = 6371; // Radius of the Earth in kilometers
  double latDistance = degreesToRadians(pointB.lat - pointA.lat);
  double lngDistance = degreesToRadians(pointB.lng - pointA.lng);
  double a = sin(latDistance / 2) * sin(latDistance / 2) +
      cos(degreesToRadians(pointA.lat)) *
          cos(degreesToRadians(pointB.lat)) *
          sin(lngDistance / 2) *
          sin(lngDistance / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

// Helper function to convert degrees to radians
double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

String prepareEmailBody(String name, String duration, num price) {
  String emailBody = '''
  Hello,

  Here are the details of the booking:
  
  Name: $name
  Duration: $duration
  
  Price: '₹$price'

  Thank you.
  ''';

  return emailBody;
}
