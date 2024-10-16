import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/otp_viewmodel.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:toastification/toastification.dart';
export 'package:expenseapp/viewmodels/otp_viewmodel.dart';

class RegisterOTPWidget extends StatefulWidget {
  const RegisterOTPWidget({super.key});

  @override
  State<RegisterOTPWidget> createState() => _RegisterOTPWidgetState();
}

class _RegisterOTPWidgetState extends State<RegisterOTPWidget> {
  late RegisterOTPViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterOTPViewModel(context.read<UserProvider>()));
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
      builder: (BuildContext context)
      => const Center(child: CircularProgressIndicator(color: primaryColor,),),
    );
  }

  Future<void> _performLoadingTask() async {
    // Show the loading dialog
    showLoadingDialog(context);

    if((await _model.checkPin()) == false){
      toastification.show(
        context: context,
        title: Text(_model.errorMessage,style: const TextStyle(
            fontFamily: 'Nunito'
        ),),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),

      );
    }else{
      toastification.show(
        context: context,
        title: const Text('Tạo tài khoản thành công!',style: TextStyle(
            fontFamily: 'Nunito'
        ),),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.popAndPushNamed(context, '/Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Xác thực OTP',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 35,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        color: textPrimary
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nhập mã xác thực',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              color: textPrimary
                          ),

                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Còn lại ',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  color: textPrimary
                              ),

                            ),
                            Countdown(
                              seconds: 300,
                              build: (BuildContext context, double time) =>
                                  Text("${time.toInt() ~/ 60}:${time.toInt() % 60}s",
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      color: textPrimary
                                    ),
                                  ),
                              interval: const Duration(milliseconds: 1000),
                              onFinished: () {
                                toastification.show(
                                  context: context,
                                  title: const Text('Mã OTP đã hết hiệu lực! Vui lòng nhấn gửi lại.', style: TextStyle(
                                    fontFamily: 'Nunito'
                                  ),),
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.flat,
                                  autoCloseDuration: const Duration(seconds: 4),

                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: PinCodeTextField(
                      autoDisposeControllers: false,
                      appContext: context,
                      length: 6,
                      textStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          color: textPrimary
                      ),

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      enableActiveFill: false,
                      autoFocus: false,
                      enablePinAutofill: false,
                      errorTextSpace: 16,
                      showCursor: true,
                      cursorColor: primaryColor,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        fieldHeight: 44,
                        fieldWidth: 44,
                        borderWidth: 2,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        shape: PinCodeFieldShape.box,
                        activeColor: textPrimary,
                        inactiveColor: alternateColor,
                        selectedColor: primaryColor,
                      ),
                      controller: _model.pinCodeController,
                      onChanged: (_) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _model.pinCodeControllerValidator
                          .asValidator(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FFButtonWidget(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/Otp');
                          },
                          text: 'Gửi lại',
                          options: FFButtonOptions(
                            height: 40,
                            padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: alternateColor,
                            textStyle: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white
                            ),

                            elevation: 0,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _performLoadingTask();
                            });

                          },
                          text: 'Xác thực',
                          options: FFButtonOptions(
                            height: 40,
                            padding:
                            const EdgeInsetsDirectional.fromSTEB(46, 0, 46, 0),
                            iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: primaryColor,
                            textStyle: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white
                            ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );


  }
}
