class ModelPlace {
  final String id;
  final String hotelName;
  final num price;
  final int numberOfReviews;
  final double lat;
  final double long;
  final String imageUrl;

  ModelPlace({
    required this.id,
    required this.hotelName,
    required this.price,
    required this.numberOfReviews,
    required this.lat,
    required this.long,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hotelName': hotelName,
      'price': price,
      'number_of_reviews': numberOfReviews,
      'lat': lat,
      'long': long,
      'image_url': imageUrl,
    };
  }

  factory ModelPlace.fromMap(Map<String, dynamic> map) {
    return ModelPlace(
      id: map['_id'] ?? '',
      hotelName: map['hotelName'] ?? '',
      price: map['price'] ?? 0,
      numberOfReviews: map['number_of_reviews'] ?? 0,
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
      imageUrl: map['image_url'] ?? '',
    );
  }
}
