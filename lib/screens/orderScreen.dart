import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/screens/home_screen.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';
import '../providers/date_provider.dart';
import '../utils.dart';

CalendarFormat _calendarFormat = CalendarFormat.month;
RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
DateTime _focusedDay = DateTime.now();

DateTime kFirstDay = DateTime.now();

class GoogleAuthApi {
  final _googleSignIn = GoogleSignIn(scopes: ['https://mail.google.com/']);
  Future<GoogleSignInAccount?> signIn() async {
    try {
      {
        return await _googleSignIn.signIn();
      }
    } catch (err) {
      print('google error' + err.toString());
    }
  }
}

class ConfirmOrderScreen extends StatefulWidget {
  final ModelPlace place;

  ConfirmOrderScreen({Key? key, required this.place}) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int tax = 1000;
  //String s = DateFormat('dd MMMM yyyy').format(_rangeStart!);

  final _paymentKey = GlobalKey<FormState>();
  void _sendEmail({required String text}) async {
    final GoogleSignInAccount? user = await GoogleAuthApi().signIn();
    final email = user!.email;
    final auth = await user.authentication;
    final token = auth.accessToken;
    final smtpServer = gmailSaslXoauth2(email, token!);
    final message = Message()
      ..from = Address(email, 'Aditya')
      ..recipients = ['reachadikush@gmail.com']
      ..subject = 'Product Orders'
      ..text = text;
    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservations Confirmed!!')));
    } on MailerException catch (err) {
      print('mail error$err');
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }), (route) => false);
  }

  final TextEditingController _upiController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _upiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = Provider.of<DateProvider>(context).rangeStart;
    DateTime? endDate = Provider.of<DateProvider>(context).rangeEnd;
    int numberOfDays = Provider.of<DateProvider>(context).differenceInDays;
    int sum = widget.place.price.toInt() * numberOfDays;
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
                String text = prepareEmailBody(
                    widget.place.hotelName,
                    '${DateFormat('dd MMMM yyyy').format(startDate!)}- ${DateFormat('dd MMMM yyyy').format(endDate!)}',
                    totalAmount,
                    _upiController.text.trim());
                if (_paymentKey.currentState!.validate()) {
                  _sendEmail(text: text);
                  Provider.of<DateProvider>(context, listen: false)
                      .updateRange(null, null);
                }
                //_sendEmail(text: text);
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

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    DateTime kLastDay =
        DateTime(kFirstDay.year, kFirstDay.month + 3, kFirstDay.day);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        )),
                  ),
                  Expanded(
                    child: TableCalendar(
                      calendarStyle: CalendarStyle(
                          rangeHighlightColor: Colors.grey.shade300,
                          isTodayHighlighted: false,
                          todayDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          rangeEndDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          rangeStartDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          markerDecoration: BoxDecoration(color: Colors.black)),
                      headerStyle: HeaderStyle(formatButtonVisible: false),
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        }
                      },
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _selectedDay = null;
                          _focusedDay = focusedDay;
                          _rangeStart = start;
                          _rangeEnd = end;
                          _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: (_rangeStart == null || _rangeEnd == null)
                        ? null
                        : () {
                            Provider.of<DateProvider>(context, listen: false)
                                .updateRange(_rangeStart!, _rangeEnd!);
                            Navigator.pop(context);
                          },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 2, bottom: 10),
                      width: 100,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: (_rangeStart == null || _rangeEnd == null)
                              ? Colors.grey
                              : Colors.black,
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
          ),
        ),
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
                  onTap: () {},
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
                  '1 guest',
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
