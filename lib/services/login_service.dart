import 'dart:convert';

import 'package:airbnb_clone/constants.dart';
import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService {
  void signUpUser(BuildContext context) async {
    try
    {

      http.Response res = await http.get(
        Uri.parse('$url/users/test'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(res: res, context: context, onSuccess: ()
      {
        print("resa");
        print(res.statusCode.toString()+"sdd");
      });
    }catch(err)
    {
      print(err.toString());
    }

  }
}
