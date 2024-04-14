import 'dart:convert';

import 'package:airbnb_clone/constants.dart';
import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';

class AuthService {
  Future<void> signUpUser(
      {required BuildContext context,
      required String username,
      required String email,
      required String password}) async {
    ModelUser user = ModelUser(
        id: '',
        token: '',
        username: username,
        email: email,
        password: password,
        address: '');
    try {
      http.Response res = await http.post(Uri.parse('$url/users/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toMap()));
      Navigator.of(context).pop();
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () async {
            displaySnackBar(
                content: jsonDecode(res.body)['message'], context: context);
            Provider.of<UserProvider>(context, listen: false)
                .updateUserDetails(jsonDecode(res.body)['user']);
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.setString('auth-token', jsonDecode(res.body)['token']);

            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          });
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$url/users/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"email": email, "password": password}));
      Navigator.pop(context);
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            Provider.of<UserProvider>(context, listen: false)
                .updateUserDetails(jsonDecode(res.body));

            displaySnackBar(
                content: jsonDecode(res.body)['message'], context: context);

            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          });
    } catch (err) {
      print(err.toString());
    }
  }
}
