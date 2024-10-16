import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/register_viewmodel.dart';
import 'package:toastification/toastification.dart';
export 'package:expenseapp/viewmodels/register_viewmodel.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late RegisterViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterViewModel(context.read<UserProvider>()));

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
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

    if((await _model.checkRegister()) == false){
      toastification.show(
        context: context,
        title: Text(_model.errorMessage),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }else{
      Navigator.pushNamed(context,"/Otp");
    }
    //Navigator.pop(context);

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
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Đăng ký',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 35,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        color: textPrimary
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Họ Tên',
                          labelStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w400,
                              color: textSecondary
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFEFEFE),
                        ),
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                            color: textPrimary
                        ),
                        cursorColor: textPrimary,
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Email',
                          labelStyle:
                          const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              color: textSecondary
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFEFEFE),
                        ),
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: textPrimary
                        ),
                        cursorColor: textPrimary,
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: false,
                        obscureText: !_model.passwordVisibility,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Mật khẩu',
                          labelStyle:
                          const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              letterSpacing: 0.0,
                              color: textSecondary
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:  Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFEFEFE),
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
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: textPrimary
                        ),
                        cursorColor: textPrimary,
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _performLoadingTask();
                        });

                      },
                      text: 'Đăng ký',
                      options: FFButtonOptions(
                        height: 40,
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: primaryColor,
                        textStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: Colors.white
                        ),

                        elevation: 0,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Đã có tài khoản?',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: textSecondary,
                              fontWeight: FontWeight.w400,
                            ),

                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: InkWell(
                            onTap:() {
                              Navigator.pop(context);
                            },
                            child:  const Text(
                            ' Đăng nhập tại đây!',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          )
                        ),
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
