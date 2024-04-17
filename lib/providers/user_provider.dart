import 'package:airbnb_clone/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  ModelUser _user = ModelUser(
      id: '',
      token: '',
      username: '',
      email: '',
      address: '',
      password: '',
      wishList: []);
  ModelUser get user => _user;

  void updateUserDetails(Map<String, dynamic> user) {
    _user = ModelUser.fromMap(user);
    notifyListeners();
  }

  void setUserFromModel(ModelUser user) {
    _user = user;
    notifyListeners();
  }
}
