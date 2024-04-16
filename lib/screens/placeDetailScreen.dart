import 'dart:io';
import 'dart:typed_data';

import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/screens/orderScreen.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
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
      text:
          'Check this hotel out on airBnB clone !!\n' + widget.place.hotelName,
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
    });

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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                BuildBody(
                    screenshotController: screenshotController, widget: widget),
                Positioned(
                  top: 30,
                  left: 10,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildAppBarButton(
                          callback: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icons.arrow_back),
                      Row(
                        children: [
                          BuildAppBarButton(
                              callback: () {}, icon: Icons.favorite_border),
                          const SizedBox(
                            width: 15,
                          ),
                          BuildAppBarButton(
                              callback: () async {
                                redirectToURL(
                                    context: context,
                                    lat: widget.place.lat.toString(),
                                    long: widget.place.long.toString());
                              },
                              icon: Iconsax.map),
                          const SizedBox(
                            width: 15,
                          ),
                          BuildAppBarButton(
                              callback: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Lottie.asset(
                                            'assets/animations/dots.json'),
                                      );
                                    });
                                final image =
                                    await screenshotController.capture();
                                Navigator.pop(context);
                                saveAndShare(image);
                              },
                              icon: Icons.share)
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    ' ₹${widget.place.price}/night',
                    style: GoogleFonts.getFont('Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Bounce(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ConfirmOrderScreen(place: widget.place);
                    }));
                  },
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
          ),
        ],
      ),
    );
  }
}

class BuildAppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback callback;
  const BuildAppBarButton(
      {super.key, required this.callback, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      scaleFactor: 1.3,
      onTap: () {
        callback();
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: Icon(icon),
      ),
    );
  }
}

class BuildBody extends StatelessWidget {
  const BuildBody({
    super.key,
    required this.screenshotController,
    required this.widget,
  });

  final ScreenshotController screenshotController;
  final PlaceDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.place.hotelName,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.9,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 20,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hosted by ${widget.place.owner}',
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          '3 years hosting',
                          style: GoogleFonts.getFont('Poppins',
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Divider(
                  color: Colors.grey,
                  thickness: 0.9,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.place.description,
                    style: GoogleFonts.getFont('Poppins', fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
