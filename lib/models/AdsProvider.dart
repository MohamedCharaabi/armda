import 'package:flutter/material.dart';

class AdsProvider extends ChangeNotifier {
  int count = 0;

  void addCount() {
    count++;
    notifyListeners();
  }
}
