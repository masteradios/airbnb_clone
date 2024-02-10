import 'dart:convert';

import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle(
    {required http.Response res,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (res.statusCode) {
    case 200:
      onSuccess();
      break;
    case 500:
      displaySnackBar(context: context, content: "Something went wrong");
    default:
      displaySnackBar(
          context: context, content: jsonDecode(res.body)['message']);
      break;
  }
}
