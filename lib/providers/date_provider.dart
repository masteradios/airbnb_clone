import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  // Getter for _rangeStart
  DateTime? get rangeStart => _rangeStart;

  // Getter for _rangeEnd
  DateTime? get rangeEnd => _rangeEnd;

  // Method to update the rangeStart and rangeEnd values
  void updateRange(DateTime? start, DateTime? end) {
    _rangeStart = start;
    _rangeEnd = end;
    notifyListeners(); // Notify listeners of changes
  }

  int get differenceInDays {
    if (_rangeStart != null && _rangeEnd != null) {
      return _rangeEnd!.difference(_rangeStart!).inDays;
    } else {
      return 0; // Return 0 if either _rangeStart or _rangeEnd is null
    }
  }
}
