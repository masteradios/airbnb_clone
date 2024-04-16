import 'dart:convert';

import 'package:airbnb_clone/constants.dart';
import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/screens/login_screen.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

            // final prefs = await SharedPreferences.getInstance();
            // await prefs.setString('auth-token', jsonDecode(res.body)['token']);

            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
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
          onSuccess: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth-token', jsonDecode(res.body)['token']);
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

  Future<String> validateToken({required BuildContext context}) async {
    String res = 'success';
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString('auth-token');
      if (token == null) {
        prefs.setString('auth-token', '');
      }
      http.Response tokenRes = await http.post(
        Uri.parse('${url}/users/tokenValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${url}/users/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'auth-token': token
          },
        );

        //get user data
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider..updateUserDetails(jsonDecode(userRes.body));
        httpErrorHandle(res: userRes, context: context, onSuccess: () {});
      }
    } catch (e) {
      print('error while getting data: ' + e.toString());
    }
    return res;
  }

  void logOutUser(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth-token', '');
      displaySnackBar(context: context, content: 'Log Out successful');
    } catch (err) {
      displaySnackBar(context: context, content: err.toString());
    }
  }
}
