import 'dart:ui';

import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';

class CustomDrawer extends StatelessWidget {
  final int? index;
  final scaffoldKey;


  CustomDrawer({
    super.key,
    this.index,
    required this.scaffoldKey
  });

  TextStyle style = const TextStyle(
  fontFamily: 'Nunito',
  fontSize: 17,
  letterSpacing: 0.0,
  color: textSecondary,
  fontWeight: FontWeight.w400,
  );

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  Future<void> _performLoadingTask(BuildContext context) async {
    showLoadingDialog(context);

    if ((await Utils.logout(context)) == false) {
      toastification.show(
        context: context,
        title: const Text('Đăng xuất thất bại! Vui lòng thử lại sau vài giây.'),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),
      );
      Navigator.pop(context);
    } else {
      toastification.show(
        context: context,
        title: const Text('Đăng xuất thành công!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false,);
      // Navigator.pushReplacementNamed(context, '/Login');
      //Navigator.popAndPushNamed(context, '/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    const cardColor = Colors.transparent;
    var selectedColor = secondaryColor;

    return Drawer(
        backgroundColor: backgroundColor,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 25, 30),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 210,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: userProvider.user?.photoUrl == null
                                ? (userProvider.user?.imgPath == 'user'
                                    ? Image.asset(
                                        'assets/images/user.png',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/logo.jpg',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ))
                                : Image.network(
                                    userProvider.user!.photoUrl.toString(),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.user?.name.toString() ??
                                    'Loading...',
                                style:const  TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 21,
                                  letterSpacing: 0.0,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                userProvider.user?.email.toString() ??
                                    'Loading...',
                                style:const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),



                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if(index != 1){
                        scaffoldKey.currentState?.closeEndDrawer();
                        Navigator.pushNamed(context, '/Home');
                      }
                    },
                    child: Card(
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            15),
                      ),
                      color: index != null ? (index == 1 ? selectedColor : cardColor) : cardColor,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:
                              Icon(
                                index == 1 ? Icons.home_rounded : Icons.home_outlined,
                                color: index != null ? (index == 1 ? backgroundColor : textSecondary) : textSecondary,
                              ),),
                            Text(
                              'Trang chủ',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                color: index != null ? (index == 1 ? backgroundColor : textSecondary) : textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if(index != 2){
                        scaffoldKey.currentState?.closeEndDrawer();
                        Navigator.pushNamed(context, '/Setting');

                      }

                    },
                    child: Card(
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            15),
                      ),
                      color: index != null ? (index == 2 ? selectedColor : cardColor) : cardColor,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:
                              Icon(
                                index == 2 ? Icons.settings_rounded : Icons.settings_outlined,
                                color: index != null ? (index == 2 ? backgroundColor : textSecondary) : textSecondary,
                              ),),
                            Text(
                              'Cài đặt',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 17,
                                letterSpacing: 0.0,
                                color: index != null ? (index == 2? backgroundColor : textSecondary) : textSecondary,
                                fontWeight: FontWeight.w400,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: alternateColor,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      _performLoadingTask(context);
                    },
                    child: Card(
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            15),
                      ),
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:
                              Icon(
                                Icons.logout_rounded,
                                color: textSecondary,
                              ),),
                            Text(
                              'Đăng xuất',
                              style: style
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
