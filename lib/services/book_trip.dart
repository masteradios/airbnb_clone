import 'dart:convert';

import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/booked_trip.dart';

Future<void> bookATrip(
    {required BookedTrip bookedTrip, required BuildContext context}) async {
  try {
    http.Response res = await http.post(Uri.parse('$url/booktrip'),
        body: jsonEncode(bookedTrip.toMap()));
    httpErrorHandle(
        res: res,
        context: context,
        onSuccess: () {
          displaySnackBar(
              content: 'Trip Booked Successfully!!', context: context);
        });
  } catch (err) {
    print(err.toString());
  }
}
