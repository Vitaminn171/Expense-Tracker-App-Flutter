import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/apis.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/views/otp.dart' show RegisterOTPWidget;
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'package:expenseapp/models/user.dart';

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
        title: const Text('OTP đã được gửi đến email!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      toastification.show(
        context: context,
        title: const Text('OTP gửi thất bại! Vui lòng thử lại.'),
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
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
