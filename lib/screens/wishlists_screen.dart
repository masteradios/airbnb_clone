import 'package:airbnb_clone/screens/placeDetailScreen.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/places.dart';
import '../models/user.dart';
import '../widgets/buildShimmer.dart';

class WishListsScreen extends StatelessWidget {
  final ModelUser user;
  const WishListsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (user.wishList.isEmpty)
          ? Center(
              child: Text('No'),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return buildPlaceTile(
                    place: user.wishList[index],
                    callBack: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PlaceDetailsScreen(place: user.wishList[index]);
                      }));
                    });
              },
              itemCount: user.wishList.length,
            ),
    );
  }
}

class buildPlaceTile extends StatelessWidget {
  final ModelPlace place;
  final VoidCallback callBack;
  buildPlaceTile({super.key, required this.place, required this.callBack});

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
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.redAccent,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
