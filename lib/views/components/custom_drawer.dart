import 'dart:ui';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';

class CustomDrawer extends StatelessWidget {
  final int? index;


  CustomDrawer({
    super.key,
    this.index
  });

  TextStyle style = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 17,
  letterSpacing: 0.0,
  color: textSecondary,
  fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final cardColor = Colors.transparent;
    final selectedColor = Color(0x66E4E4E4);

    return Drawer(
        width: 260,
        //backgroundColor: const Color(0xCCE4E4E4),
        backgroundColor: backgroundColor,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 25, 30),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 210,
                    // decoration:  BoxDecoration(
                    //   color: Color(0xb369caa7),
                    // ),

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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.user?.name.toString() ??
                                    'Loading...',
                                style: TextStyle(
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
                                style: TextStyle(
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
                    onTap: () {

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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:
                              Icon(
                                Icons.account_circle,
                                color: textSecondary,
                              ),),
                            Text(
                              'Tài khoản',
                              style: style
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {

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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:
                              Icon(
                                Icons.settings_rounded,
                                color: textSecondary,
                              ),),
                            Text(
                              'Cài đặt',
                              style: style
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {

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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
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
