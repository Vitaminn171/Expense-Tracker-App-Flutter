import 'package:expenseapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],);

  GoogleSignIn get googleSignIn => _googleSignIn;

}