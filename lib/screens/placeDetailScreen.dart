import 'dart:io';
import 'dart:typed_data';

import 'package:airbnb_clone/models/places.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final ModelPlace place;
  PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool _isLoading = false;
  Future<void> saveAndShare(Uint8List? bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes!);
    await Share.shareFiles(
      [image.path],
      text: widget.place.hotelName,
      subject: 'Hotel',
    );
  }

  void redirectToURL(
      {required BuildContext context,
      required String lat,
      required String long}) async {
    setState(() {
      _isLoading = true;
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          });
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) {
      //       return Scaffold(
      //         backgroundColor: Colors.transparent,
      //         body: Center(
      //           child: CircularProgressIndicator(
      //             color: greenColor,
      //           ),
      //         ),
      //       );
      //     }));
    });

// This is the 255th attempt to try to understand what's happening
    //increase counter if you failed to understand
    //counter=255
    var url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$long");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Hero(
                  tag: '${widget.place.hotelName}',
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.place.imageUrl),
                            fit: BoxFit.fill)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Text(
                  widget.place.hotelName,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Divider(
                  color: Colors.grey,
                  thickness: 0.9,
                ),
              ),
            ],
          ),
          Positioned(
              top: 30,
              left: 10,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Bounce(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Bounce(
                          onTap: () async {
                            redirectToURL(
                                context: context,
                                lat: widget.place.lat.toString(),
                                long: widget.place.long.toString());
                          },
                          child: Icon(Iconsax.map),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Bounce(
                            onTap: () async {
                              final image =
                                  await screenshotController.capture();
                              saveAndShare(image);
                            },
                            child: Icon(Icons.share)),
                      ),
                    ],
                  )
                ],
              )),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        ' ₹${widget.place.price} night',
                        style: GoogleFonts.getFont('Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Bounce(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'Reserve',
                          style: GoogleFonts.getFont('Poppins',
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
