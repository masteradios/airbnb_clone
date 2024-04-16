import 'package:flutter/cupertino.dart';

class GuestCountProvider extends ChangeNotifier {
  int _adultCount = 1;
  int _childCount = 0;
  int get adultCount => _adultCount;
  int get childCount => _childCount;

  void upGuestCount({required int adult, required int children}) {
    _adultCount = adult;
    _childCount = children;
    notifyListeners();
  }

  int get getTotalGuestCount => _adultCount + _childCount;
}
