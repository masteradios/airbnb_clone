import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/screens/placeDetailScreen.dart';
import 'package:airbnb_clone/screens/searchScreen.dart';
import 'package:airbnb_clone/services/wishlist_services.dart';
import 'package:airbnb_clone/widgets/buildShimmer.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils.dart';

class ExploreScreen extends StatefulWidget {
  final List<ModelPlace> modelPlaces;
  final Position position;
  ExploreScreen({super.key, required this.modelPlaces, required this.position});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        buildSearchTile(),
        buildRecommenededPlaces(
          modelPlaces: widget.modelPlaces,
          position: widget.position,
          user: user,
        )
      ],
    );
  }
}

class buildRecommenededPlaces extends StatefulWidget {
  final Position position;
  final ModelUser user;
  const buildRecommenededPlaces(
      {super.key,
      required this.modelPlaces,
      required this.position,
      required this.user});

  final List<ModelPlace> modelPlaces;

  @override
  State<buildRecommenededPlaces> createState() =>
      _buildRecommenededPlacesState();
}

class _buildRecommenededPlacesState extends State<buildRecommenededPlaces> {
  List<bool> isFav = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void addToWishlists(
      {required ModelPlace place, required String userid}) async {
    await WishListServices()
        .addToWishlists(context: context, place: place, userid: userid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initiate();
  }

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return buildPlaceTile(
            place: widget.modelPlaces[index],
            position: widget.position,
            isFav: false,
            callBack: () {
              // for (int i = 0; i < widget.modelPlaces.length; i++) {
              //   if (widget.modelPlaces[index].id == user.wishList[i].id) {
              //     setState(() {
              //       isFav[index] = true;
              //     });
              //   }
              // }
              addToWishlists(place: widget.modelPlaces[index], userid: user.id);
            },
          );
        },
        itemCount: widget.modelPlaces.length,
      ),
    );
  }
}

class buildPlaceTile extends StatelessWidget {
  final ModelPlace place;
  final Position position;
  final VoidCallback callBack;
  final bool isFav;
  buildPlaceTile(
      {super.key,
      required this.isFav,
      required this.place,
      required this.position,
      required this.callBack});
  String calculateTotalDistance({required LatLng pointB}) {
    LatLng pointA = LatLng(position.latitude, position.longitude);
    double distance = calculateDistance(pointA, pointB);
    return distance.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            place.imageUrl,
            height: 300,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // Image has finished loading, return the actual image
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PlaceDetailsScreen(
                        place: place,
                      );
                    }));
                  },
                  child: Stack(
                    children: [
                      Hero(
                        tag: '${place.hotelName}',
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: child),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Bounce(
                          scaleFactor: 1.6,
                          onTap: () {
                            callBack();
                          },
                          child: (isFav)
                              ? Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Colors.redAccent,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Image is still loading, show the shimmer effect
                return BuildShimmer();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 280,
                      child: Text(
                        place.hotelName,
                        style: GoogleFonts.getFont('Poppins',
                            fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                          place.numberOfReviews.toString(),
                          style: GoogleFonts.getFont('Poppins', fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${calculateTotalDistance(pointB: LatLng((place.lat), (place.long)))} km away',
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.grey, fontSize: 13),
                )
              ],
            ),
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
