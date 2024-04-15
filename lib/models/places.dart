class ModelPlace {
  final String id;
  final String hotelName;
  final num price;
  final int numberOfReviews;
  final double lat;
  final double long;
  final String owner;
  final String imageUrl;
  final String description;

  ModelPlace(
      {required this.id,
      required this.owner,
      required this.hotelName,
      required this.price,
      required this.numberOfReviews,
      required this.lat,
      required this.long,
      required this.imageUrl,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hotelName': hotelName,
      'price': price,
      'number_of_reviews': numberOfReviews,
      'lat': lat,
      'long': long,
      'owner': owner,
      'image_url': imageUrl,
    };
  }

  factory ModelPlace.fromMap(Map<String, dynamic> map) {
    return ModelPlace(
        owner: map['owner'] ?? '',
        id: map['_id'] ?? '',
        hotelName: map['hotelName'] ?? '',
        price: map['price'] ?? 0,
        numberOfReviews: map['number_of_reviews'] ?? 0,
        lat: map['lat'] ?? '',
        long: map['long'] ?? '',
        imageUrl: map['image_url'] ?? '',
        description: '''
Welcome to ${map['hotelName']}, your home away from home! Nestled in the heart of Jaipur, our hotel offers a perfect blend of comfort, convenience, and style for your stay.

Indulge in our well-appointed rooms, each designed with modern amenities to ensure a relaxing and enjoyable experience. From plush bedding to sleek furnishings, every detail is crafted to provide you with a restful retreat after a day of exploration.

Start your day with a complimentary continental breakfast served in our elegant dining area, or savor a cup of freshly brewed coffee at our cozy on-site cafe.

Explore the vibrant neighborhood with ease, as we are conveniently located near beautiful attractions. Whether you're here for business or leisure, our friendly staff is dedicated to making your stay unforgettable.

Book your stay at ${map['hotelName']} today and discover the perfect blend of comfort and convenience for your next trip to Jaipur.
''');
  }
}
