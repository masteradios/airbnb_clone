import 'dart:convert';

import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/booked_trip.dart';
import '../providers/date_provider.dart';
import '../providers/guestCount_provider.dart';
import '../screens/home_screen.dart';

class TripService {
  Future<void> bookATrip(
      {required BookedTrip bookedTrip,
      required BuildContext context,
      required String text}) async {
    try {
      http.Response res = await http.post(Uri.parse('$url/users/booktrip'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "hotel": bookedTrip.place.toMap(),
            "totalAmount": bookedTrip.totalAmount,
            "numberOfDays": bookedTrip.numberOfDays,
            "userid": bookedTrip.userid,
            "numberOfGuests": bookedTrip.numberOfGuests,
            "startDate": bookedTrip.startDate,
            "endDate": bookedTrip.endDate
          }));
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            sendEmail(text: text, context: context);
          });
    } catch (err) {
      print(err.toString());
    }
  }

  Future<List<BookedTrip>> getUserTrips(
      {required String userid, required BuildContext context}) async {
    List<BookedTrip> bookedTrips = [];
    try {
      http.Response res = await http.post(Uri.parse('$url/users/getusertrips'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"userid": userid}));
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0;
                i < jsonDecode(res.body)['bookedTrips'].length;
                i++) {
              BookedTrip trip =
                  BookedTrip.fromMap(jsonDecode(res.body)['bookedTrips'][i]);
              bookedTrips.add(trip);
            }
            print(bookedTrips);
          });
    } catch (err) {
      print(err.toString());
    }
    return bookedTrips;
  }
}

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

void sendEmail({required String text, required BuildContext context}) async {
  final GoogleSignInAccount? user = await GoogleAuthApi().signIn();
  final email = user!.email;
  final auth = await user.authentication;
  final token = auth.accessToken;
  final smtpServer = gmailSaslXoauth2(email, token!);
  final message = Message()
    ..from = Address(email, 'Aditya')
    ..recipients = ['reachadikush@gmail.com', '2021.groupminiproject@gmail.com']
    ..subject = 'Product Orders'
    ..text = text;
  showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Lottie.asset('assets/animations/dots.json'),
        );
      });
  try {
    await send(message, smtpServer);

    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload["data"] = "content";
    AlertController.show("Success", "Reservations confirmed Successfully!!",
        TypeAlert.success, payload);
  } on MailerException catch (err) {
    print('mail error$err');
  }
  Provider.of<DateProvider>(context, listen: false).updateRange(null, null);
  Provider.of<GuestCountProvider>(context, listen: false)
      .upGuestCount(adult: 1, children: 0);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    return HomeScreen();
  }), (route) => false);
}
