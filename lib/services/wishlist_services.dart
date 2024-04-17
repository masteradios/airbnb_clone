import 'dart:convert';

import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/models/places.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/user.dart';

class WishListServices {
  Future<void> addToWishlists(
      {required BuildContext context,
      required ModelPlace place,
      required String userid}) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(Uri.parse('$url/users/addToWishList'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'auth-token': userProvider.user.token
          },
          body: jsonEncode({
            "hotel": place.toMap(),
            "userid": userid,
          }));
      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            //map=jsonDecode(res.body);
            ModelUser user = userProvider.user.copyWith(
                wishList: List<ModelPlace>.from(
              jsonDecode(res.body)['wishList'].map(
                (x) => ModelPlace.fromMap(x['hotel']),
              ),
            ));
            userProvider.setUserFromModel(user);
            //print(jsonDecode(res.body)['wishList']);
          });
    } catch (err) {
      print(err.toString());
    }
  }
}
