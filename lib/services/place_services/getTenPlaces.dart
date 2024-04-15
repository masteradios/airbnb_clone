import 'dart:convert';

import 'package:airbnb_clone/httpErrorHandle.dart';
import 'package:airbnb_clone/models/places.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class PlaceServices {
  Future<List<ModelPlace>> getTopTenPlaces(
      {required BuildContext context}) async {
    List<ModelPlace> modelPlaces = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$url/places/allplaces'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      httpErrorHandle(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body)['places'].length; i++) {
              modelPlaces
                  .add(ModelPlace.fromMap(jsonDecode(res.body)['places'][i]));
            }
          });
    } catch (err) {
      print(err.toString());
      //displaySnackBar(content: 'Network Error', context: context);
    }
    return modelPlaces;
  }
}
