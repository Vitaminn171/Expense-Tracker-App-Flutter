import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/apis.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/views/otp.dart' show RegisterOTPWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:email_otp/email_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../models/user.dart';

class RegisterOTPViewModel extends FlutterFlowModel<RegisterOTPWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  final UserProvider userProvider;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  RegisterOTPViewModel(this.userProvider);

  @override
  Future<void> initState(BuildContext context) async {
    pinCodeController = TextEditingController();

    String? email = userProvider.user!.email;
    if (await EmailOTP.sendOTP(email: email!)) {
      toastification.show(
        context: context,
        title: Text('OTP đã được gửi đến email!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      toastification.show(
        context: context,
        title: Text('OTP gửi thất bại! Vui lòng thử lại.'),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    pinCodeController?.dispose();
  }

  Future<bool> checkPin() async {
    _errorMessage = '';
    if (!EmailOTP.verifyOTP(otp: pinCodeController.text)) {
      _errorMessage = 'Xác thực thất bại! Vui lòng nhập lại mã.';
      return false;
    }
    await register();
    return true;
  }

  Future<void> register() async {

    String? email = userProvider.user!.email;
    try{

      final userDoc = Api.usersCollection.doc(); // Generate a unique document ID
      final userData = {
        'email': userProvider.user!.email,
        'name': userProvider.user!.name,
        'password': Utils.generateMd5(userProvider.user!.password.toString()),
        'imgPath': userProvider.user!.imgPath
      };
      await userDoc.set(userData);

      final walletDoc = Api.walletsCollection.doc(); // Generate a unique document ID

      final walletData = {
        'email': userProvider.user!.email,
        'cash': 0,
      };

      await walletDoc.set(walletData);


      await storeUser(User(name: userProvider.user!.name, email: userProvider.user!.email, totalCash: userProvider.user!.totalCash, imgPath: 'user'));
    }catch(e){
      print(e);
    }

  }

  Future<void> storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('this_email', user.email);
    await prefs.setString('this_username', user.name);
    await prefs.setInt('this_totalCash', user.totalCash);
  }

}
