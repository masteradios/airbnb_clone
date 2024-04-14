import 'dart:math';

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
