import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenseapp/main.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:expenseapp/viewmodels/login_viewmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
export 'package:expenseapp/viewmodels/login_viewmodel.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginViewModel _model;
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  NumberFormat _numberFormat = NumberFormat.currency(
    locale: 'vi_VN', // Adjust the locale as needed
    symbol: '\$',
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => LoginViewModel(context.read<UserProvider>()));

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  Future<void> _performLoadingTask() async {
    isLoading = true;

    // Show the loading dialog
    showLoadingDialog(context);

    if ((await _model.checkLogin()) == false) {
      toastification.show(
        context: context,
        title: Text(_model.errorMessage),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 4),
      );
      Navigator.pop(context);
    } else {
      toastification.show(
        context: context,
        title: Text('Đăng nhập thành công!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.popAndPushNamed(context, '/Home');
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      showLoadingDialog(context);
      final GoogleSignInAccount? googleUser = await _model.userProvider.googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // final credential = googleAuth.credential(
        //   accessToken: googleAuth.accessToken,
        //   idToken: googleAuth.idToken,
        // );

        final String name = googleUser.displayName!;
        final String email = googleUser.email!;
        final String photoUrl = googleUser.photoUrl!;

        print('Google email: $email');

        toastification.show(
          context: context,
          title: Text(email),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
        );
        await _model.loginGoogle(email, name, photoUrl);
        Navigator.popAndPushNamed(context, '/Home');
        // Use the credential to sign-in to Firebase or your backend
        // ...
      }else{
        Navigator.pop(context);
      }
    } catch (error) {
      print("Sign-in error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Đăng nhập',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 35,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        color: textPrimary),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: false,
                        obscureText: false,
                        // inputFormatters: <TextInputFormatter>[
                        //   CurrencyTextInputFormatter.currency(
                        //     enableNegative: false,
                        //     decimalDigits: 0,
                        //     symbol: ''
                        //   ),
                        // ],
                        // keyboardType: TextInputType.number,
                        //TODO: format currency
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              color: textSecondary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF65C6A3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFEFEFE),
                        ),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: textPrimary),
                        cursorColor: textPrimary,
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: false,
                        obscureText: !_model.passwordVisibility,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              color: textSecondary),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF65C6A3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Color(0xFFFEFEFE),
                          suffixIcon: InkWell(
                            onTap: () => safeSetState(
                              () => _model.passwordVisibility =
                                  !_model.passwordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              _model.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF65C6A3),
                              size: 20,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: textPrimary),
                        cursorColor: textPrimary,
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.0,
                                color: textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _performLoadingTask();
                        });
                      },
                      text: 'Đăng nhập',
                      options: FFButtonOptions(
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFF69CAA7),
                        textStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: Colors.white),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _signInWithGoogle();
                        });
                      },
                      icon: Image.asset('assets/images/google.png',alignment: Alignment.centerLeft,),
                      text: 'Đăng nhập với Google',
                      options: FFButtonOptions(
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: backgroundColor,

                        textStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: Colors.blue),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Chưa có tài khoản?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/Register");
                              },
                              child: Text(
                                ' Đăng ký tại đây!',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}