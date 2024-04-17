import 'package:airbnb_clone/models/booked_trip.dart';
import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/guestCount_provider.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/services/book_trip.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/date_provider.dart';
import '../utils.dart';
import 'calendar_page.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final ModelPlace place;

  ConfirmOrderScreen({Key? key, required this.place}) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int tax = 1000;
  final TextEditingController _upiController = TextEditingController();
  //String s = DateFormat('dd MMMM yyyy').format(_rangeStart!);

  final _paymentKey = GlobalKey<FormState>();

  void confirmOrder(
      {required String text, required BookedTrip bookedTrip}) async {
    await TripService()
        .bookATrip(bookedTrip: bookedTrip, context: context, text: text);
  }

  void _warning({required String content}) {
    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload["data"] = "content";
    AlertController.show("Warning", "$content", TypeAlert.error, payload);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _upiController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlertController.onTabListener(
        (Map<String, dynamic>? payload, TypeAlert type) {
      print("$payload - $type");
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = Provider.of<DateProvider>(context).rangeStart;
    DateTime? endDate = Provider.of<DateProvider>(context).rangeEnd;
    int numberOfDays = Provider.of<DateProvider>(context).differenceInDays;
    int sum = widget.place.price.toInt() * numberOfDays;
    ModelUser user = Provider.of<UserProvider>(context).user;
    int totalAmount = sum + tax;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          'Confirm and Pay',
          style: GoogleFonts.getFont('Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildPlace(place: widget.place),
            Divider(
              thickness: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BuildTripDetails(
                place: widget.place,
                startDate: (startDate == null || endDate == null)
                    ? '-'
                    : DateFormat('dd MMMM yyyy').format(startDate!),
                endDate: (startDate == null || endDate == null)
                    ? '-'
                    : DateFormat('dd MMMM yyyy').format(endDate!),
              ),
            ),
            Divider(
              thickness: 6,
            ),
            BuildPriceDetails(
              place: widget.place,
              sum: sum,
              numberOfDays: numberOfDays,
              tax: tax,
              totalAmount: totalAmount,
            ),
            Divider(
              thickness: 6,
            ),
            Form(
              key: _paymentKey,
              child: BuildPaySection(
                controller: _upiController,
              ),
            ),
            Divider(
              thickness: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                rules,
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Bounce(
              onTap: () {
                if (_paymentKey.currentState!.validate()) {
                  if (numberOfDays != 0) {
                    String text = prepareEmailBody(
                        name: widget.place.hotelName,
                        duration:
                            '${DateFormat('dd MMMM yyyy').format(startDate!)}- ${DateFormat('dd MMMM yyyy').format(endDate!)}',
                        totalAmount: totalAmount,
                        upiId: _upiController.text.trim());

                    BookedTrip bookedTrip = BookedTrip(
                        tripid: '',
                        userid: user.id,
                        numberOfGuests: 1,
                        numberOfDays: numberOfDays,
                        place: widget.place,
                        totalAmount: totalAmount,
                        startDate: DateFormat('dd MMMM yyyy').format(startDate),
                        endDate: DateFormat('dd MMMM yyyy').format(endDate));
                    confirmOrder(text: text, bookedTrip: bookedTrip);
                  } else {
                    _warning(content: "Select proper stay dates");
                  }
                }
              },
              child: Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 10),
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Confirm and Pay',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPlace extends StatelessWidget {
  final ModelPlace place;
  const BuildPlace({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(place.imageUrl), fit: BoxFit.fill)),
            // child: ClipRRect(
            //   child: Image.network(
            //     place.imageUrl,
            //     fit: BoxFit.fill,
            //   ),
            //   borderRadius: BorderRadius.circular(10),
            // ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    place.hotelName,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text('Room in bed and breakfast',
                    style: GoogleFonts.getFont('Poppins', fontSize: 15)),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      place.numberOfReviews.toString(),
                      style: GoogleFonts.getFont('Poppins', fontSize: 15),
                    )
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

class BuildTripDetails extends StatelessWidget {
  final ModelPlace place;
  final String startDate;
  final String endDate;
  const BuildTripDetails(
      {Key? key,
      required this.place,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int guestCount =
        Provider.of<GuestCountProvider>(context).getTotalGuestCount;
    int adult = Provider.of<GuestCountProvider>(context).adultCount;
    int children = Provider.of<GuestCountProvider>(context).childCount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Your Trip',
            style: GoogleFonts.getFont('Poppins',
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => CalendarPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Dates',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${startDate}-${endDate}',
                  style: GoogleFonts.poppins(color: Colors.grey.shade700),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                trailing: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext bc) {
                          return BuildBottomSheet();
                        });
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                    ),
                  ),
                ),
                title: Text(
                  'Guests',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${guestCount.toString()} ($adult Adults and $children children)',
                  style: GoogleFonts.poppins(color: Colors.grey.shade700),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BuildBottomSheet extends StatelessWidget {
  const BuildBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int adult = Provider.of<GuestCountProvider>(context).adultCount;
    int children = Provider.of<GuestCountProvider>(context).childCount;
    return Wrap(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<GuestCountProvider>(context,
                                      listen: false)
                                  .upGuestCount(adult: 1, children: 0);
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Guests',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This place has a maximum limit of 4 guests, not including infants.',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                            ),
                          ),
                          BuildGuestCountTile(
                            title: 'Adults',
                            condition: 'Age 13+',
                            count: adult.toString(),
                            incrementCallBack: () {
                              Provider.of<GuestCountProvider>(context,
                                      listen: false)
                                  .upGuestCount(
                                      adult: adult + 1, children: children);
                            },
                            decrementCallBack: () {
                              if (!(adult <= 1)) {
                                Provider.of<GuestCountProvider>(context,
                                        listen: false)
                                    .upGuestCount(
                                        adult: adult - 1, children: children);
                              }
                            },
                          ),
                          BuildGuestCountTile(
                            title: 'Children',
                            condition: 'Age 2-12',
                            count: children.toString(),
                            incrementCallBack: () {
                              Provider.of<GuestCountProvider>(context,
                                      listen: false)
                                  .upGuestCount(
                                      adult: adult, children: children + 1);
                            },
                            decrementCallBack: () {
                              if (!(children <= 0)) {
                                Provider.of<GuestCountProvider>(context,
                                        listen: false)
                                    .upGuestCount(
                                        adult: adult, children: children - 1);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 10),
                  width: 100,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class BuildGuestCountTile extends StatelessWidget {
  final String title;
  final String condition;
  final String count;
  final VoidCallBack decrementCallBack;
  final VoidCallBack incrementCallBack;
  const BuildGuestCountTile(
      {super.key,
      required this.incrementCallBack,
      required this.decrementCallBack,
      required this.title,
      required this.count,
      required this.condition});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Container(
        width: 126,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  decrementCallBack();
                },
                icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black12,
                    child: Icon(
                      Icons.remove,
                      size: 18,
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                count,
                style: GoogleFonts.poppins(fontSize: 17),
              ),
            ),
            IconButton(
                onPressed: () {
                  incrementCallBack();
                },
                icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black12,
                    child: Icon(
                      Icons.add,
                      size: 18,
                    ))),
          ],
        ),
      ),
      titleAlignment: ListTileTitleAlignment.center,
      subtitle: Text(condition,
          style: GoogleFonts.poppins(color: Colors.black87, fontSize: 12)),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class BuildPriceDetails extends StatelessWidget {
  final int sum;
  final int tax;
  final int numberOfDays;
  final int totalAmount;

  final ModelPlace place;
  BuildPriceDetails(
      {super.key,
      required this.place,
      required this.sum,
      required this.numberOfDays,
      required this.tax,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Price Details',
              style: GoogleFonts.getFont('Poppins',
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.titleHeight,
              trailing: Text('₹' + sum.toString(),
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade700, fontSize: 15)),
              contentPadding: EdgeInsets.zero,
              title: Text(
                '₹${place.price} x ${numberOfDays} nights',
                style: GoogleFonts.poppins(color: Colors.grey.shade700),
              ),
            ),
            ListTile(
              minVerticalPadding: 0,
              titleAlignment: ListTileTitleAlignment.titleHeight,
              trailing: Text('₹' + tax.toString(),
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade700, fontSize: 15)),
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Taxes',
                style: GoogleFonts.poppins(color: Colors.grey.shade700),
              ),
            ),
            Divider(
              thickness: 0.8,
            ),
            ListTile(
              minVerticalPadding: 0,
              titleAlignment: ListTileTitleAlignment.titleHeight,
              trailing: Text(
                '₹' + totalAmount.toString(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Total',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPaySection extends StatelessWidget {
  final TextEditingController controller;
  const BuildPaySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Pay With',
            style: GoogleFonts.getFont('Poppins',
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'UPI',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              buildUpiTextField(
                controller: controller,
              )
            ],
          )
        ],
      ),
    );
  }
}

class buildUpiTextField extends StatelessWidget {
  final TextEditingController controller;
  const buildUpiTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your UPI ID';
        }
        return null;
      },
      // to trigger disabledBorder
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.black)),
        hintText: "UPI ID",
        hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
      ),
    );
  }
}
