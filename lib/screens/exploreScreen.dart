import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/screens/searchScreen.dart';
import 'package:airbnb_clone/widgets/buildShimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({
    super.key,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<ModelPlace> modelPlaces = [];
  Future<void> fetchImageDetails() async {
    // Simulate fetching image details from an API
    // Replace this with your actual API call
    // For simplicity, using a delayed Future

    await Future.delayed(Duration(seconds: 1));
    modelPlaces = [
      ModelPlace(
          id: '12',
          hotelName: 'Aditya',
          price: 200,
          numberOfReviews: 1232,
          lat: '34.0522',
          long: '-118.2437',
          imageUrl:
              'https://delhitourism.gov.in/dttdc/img/new/lotustemple.jpg'),
      ModelPlace(
          id: '12',
          hotelName: 'Kushwaha',
          price: 200,
          numberOfReviews: 1232,
          lat: '34.0522',
          long: '-118.2437',
          imageUrl:
              'https://delhitourism.gov.in/dttdc/img/new/lotustemple.jpg'),
      ModelPlace(
          id: '12',
          hotelName: 'Aditya',
          price: 200,
          numberOfReviews: 1232,
          lat: '34.0522',
          long: '-118.2437',
          imageUrl:
              'https://delhitourism.gov.in/dttdc/img/new/lotustemple.jpg'),
      ModelPlace(
          id: '12',
          hotelName: 'Kushwaha',
          price: 200,
          numberOfReviews: 1232,
          lat: '34.0522',
          long: '-118.2437',
          imageUrl: 'https://delhitourism.gov.in/dttdc/img/new/lotustemple.jpg')
    ];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImageDetails();
  }

  double value = 0;

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return (modelPlaces.isEmpty)
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          )
        : Column(
            children: [
              buildSearchTile(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return buildPlaceTile(
                      snapshot: modelPlaces[index],
                    );
                  },
                  itemCount: modelPlaces.length,
                ),
              )
            ],
          );
  }
}

class buildPlaceTile extends StatelessWidget {
  final ModelPlace snapshot;
  const buildPlaceTile({super.key, required this.snapshot});
  String calculateTotalDistance(
      {required LatLng pointA, required LatLng pointB}) {
    double distance = calculateDistance(pointA, pointB);
    return distance.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            snapshot.imageUrl,
            height: 300,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // Image has finished loading, return the actual image
                return Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20), child: child),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Image is still loading, show the shimmer effect
                return BuildShimmer();
              }
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    snapshot.hotelName,
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '5.0',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${calculateTotalDistance(pointA: LatLng(40.7128, -74.0060), pointB: LatLng(double.parse(snapshot.lat), double.parse(snapshot.long)))} km away',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}

class buildSearchTile extends StatelessWidget {
  const buildSearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 20,
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen();
              }));
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where to?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Anywhere'),
                    Text('Anytime'),
                    Text('Add Guests'),
                  ],
                )
              ],
            ),
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 35,
            ),
          )),
    );
  }
}
