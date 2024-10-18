import 'package:expenseapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  bool _isChanged = false;
  bool get isChanged => _isChanged;

  void setChanged(bool newValue) {
    _isChanged = newValue;
    notifyListeners();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],);

  GoogleSignIn get googleSignIn => _googleSignIn;

  GoogleSignInAccount? _userGoogle;
  GoogleSignInAccount get userGoogle => _userGoogle!;

  void setUserGoogle(GoogleSignInAccount? newUser) {
    _userGoogle = newUser;
    notifyListeners();
  }


  void logout(){
    _user = null;
    _googleSignIn.signOut();
    setUserGoogle(null);
  }

}