import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/screens/placeDetailScreen.dart';
import 'package:airbnb_clone/screens/searchScreen.dart';
import 'package:airbnb_clone/services/book_trip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../models/booked_trip.dart';
import '../widgets/buildShimmer.dart';

class MyTrips extends StatefulWidget {
  final ModelUser user;
  const MyTrips({super.key, required this.user});

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  List<BookedTrip> bookedTrips = [];
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserTrips();
  }

  void getUserTrips() async {
    setState(() {
      _isLoading = true;
    });
    bookedTrips = await TripService()
        .getUserTrips(userid: widget.user.id, context: context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(
            child: Lottie.asset('assets/animations/dots.json'),
          )
        : (bookedTrips.isEmpty)
            ? BuildNoTripsBody()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      'My Trips',
                      style: GoogleFonts.poppins(fontSize: 26),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: bookedTrips.length,
                        itemBuilder: (context, index) {
                          return buildTripTile(trip: bookedTrips[index]);
                        }),
                  ),
                ],
              );
    ;
  }
}

class BuildNoTripsBody extends StatelessWidget {
  const BuildNoTripsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trips',
            style:
                GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: const Divider(
              thickness: 0.7,
              color: Colors.grey,
            ),
          ),
          Text(
            'No trips booked...yet',
            style: GoogleFonts.poppins(fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Time to dust off your bags and start planning your next adventure',
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey)),
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchScreen();
                  }));
                },
                child: Text(
                  'Start Searching',
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class buildTripTile extends StatelessWidget {
  final BookedTrip trip;
  buildTripTile({super.key, required this.trip});

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
            trip.place.imageUrl,
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
                        place: trip.place,
                      );
                    }));
                  },
                  child: Hero(
                    tag: '${trip.place.hotelName}',
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), child: child),
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
                        trip.place.hotelName,
                        style: GoogleFonts.getFont('Poppins',
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text('No. of guests: ${trip.numberOfGuests}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
          Text('${trip.startDate}-${trip.endDate} (${trip.numberOfDays} days)',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black45)),
          Text(
            '₹' + trip.totalAmount.toString(),
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
