import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';
import 'custom_alert_dialog.dart';

class UserWidget extends StatelessWidget {
  final scaffoldKey;
  final String? title;
  final String? route;
  final bool? flag;
  final Function? save;

  const UserWidget({
    super.key,
    required this.scaffoldKey,
    this.title,
    this.route,
    this.flag,
    this.save,
  });

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
              alignment: AlignmentDirectional(0, 0),
              child: InkWell(
                onTap: () {
                  if (flag == null || flag == false) {
                    Navigator.popAndPushNamed(context, route ?? '/Home');
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                            title: 'Dữ liệu chưa được lưu!',
                            info: 'Dữ liệu của bạn chưa được lưu. Bạn có muốn lưu lại trước khi thoát không?',
                            action: () {
                              save!();
                            },
                            actionCancel: (){
                              Navigator.popAndPushNamed(context, '/Home');
                            },
                        ));
                  }

                  //scaffoldKey.currentState?.openEndDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: backgroundColor,
                  size: 30,
                ),
              )),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 21,
                        letterSpacing: 0.0,
                        color: backgroundColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: AlignmentDirectional(0, 0),
              child: InkWell(
                onTap: () {
                  if (flag == null || flag == false) {
                    scaffoldKey.currentState?.openEndDrawer();
                  }

                },
                child: Icon(
                  Icons.menu_rounded,
                  color: backgroundColor,
                  size: 30,
                ),
              )),
        ],
      );
    } else {
      final userProvider = context.read<UserProvider>();
      //print(userProvider.user?.imgPath);
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: userProvider.user?.photoUrl == null
                      ? (userProvider.user?.imgPath == 'user'
                          ? Image.asset(
                              'assets/images/user.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/logo.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ))
                      : Image.network(
                          userProvider.user!.photoUrl.toString(),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.user?.name.toString() ?? 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 17,
                        letterSpacing: 0.0,
                        color: backgroundColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      userProvider.user?.email.toString() ?? 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: backgroundColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: AlignmentDirectional(0, 0),
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
                child: Icon(
                  Icons.menu_rounded,
                  color: backgroundColor,
                  size: 30,
                ),
              )),
        ],
      );
    }
  }
}
