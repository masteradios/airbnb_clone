import 'dart:convert';
import 'package:airbnb_clone/constants.dart';
import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
          body: jsonEncode(
              {"email": email, "password": password, "username": username}));
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () async {
            displaySnackBar(
                content: jsonDecode(res.body)['message'], context: context);
            //print(jsonDecode(res.body)['user']);
            // Provider.of<UserProvider>(context, listen: false)
            //     .updateUserDetails(jsonDecode(res.body)['user']);
            // print(user);
          });
    } catch (err) {
      print(err.toString());
    }
  }
}
