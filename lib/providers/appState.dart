import 'package:expenseapp/models/user.dart';
import 'package:flutter/material.dart';

class Appstate extends ChangeNotifier {
  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setState(bool newState) {
    _isUpdated = newState;
    notifyListeners();
  }
}