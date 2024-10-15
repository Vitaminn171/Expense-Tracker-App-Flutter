
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/apis.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/views/register.dart' show RegisterWidget;
import 'package:flutter/material.dart';

import 'package:expenseapp/models/user.dart';

class RegisterViewModel extends FlutterFlowModel<RegisterWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController3Validator;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final UserProvider userProvider;

  RegisterViewModel(this.userProvider);

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }

  Future<bool> checkRegister() async {
    _errorMessage = '';

    String name = textController1.text;
    String email = textController2.text;
    String password = textController3.text;

    if(email.isEmpty || password.isEmpty || name.isEmpty) {
      _errorMessage = 'Không để trống thông tin đăng nhập!';
      return false;
    }

    if(!Utils.isValidEmail(email)) {
      _errorMessage = 'Sai định dạng email!';
      return false;
    }

    final querySnapshot = await Api.getUserData(email);
    if(querySnapshot.size > 0){
      _errorMessage = 'Tài khoản đã được đăng ký!';
      return false;
    }

    User user = User(
      name: name,
      email: email,
      password: password,
      totalCash: 0,
      imgPath: 'user'

    );
    userProvider.setUser(user);
    return true;
  }


}
