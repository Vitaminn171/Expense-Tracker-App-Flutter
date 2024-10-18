import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/models/colors.dart';
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
              alignment: const AlignmentDirectional(0, 0),
              child: InkWell(
                onTap: () {
                  if (flag == null || flag == false) {
                    // Navigator.pop(context, route ?? '/Home');
                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                              title: 'Dữ liệu chưa được lưu!',
                              info: 'Dữ liệu của bạn chưa được lưu. Bạn có muốn lưu lại trước khi thoát không?',
                              action: () {
                                save!();
                              },
                              actionCancel: () {
                                Navigator.pop(context);
                              },
                            ));
                  }

                  //scaffoldKey.currentState?.openEndDrawer();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: backgroundColor,
                  size: 30,
                ),
              )),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
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
              alignment: const AlignmentDirectional(0, 0),
              child: InkWell(
                onTap: () {
                  if (flag == null || flag == false) {
                    scaffoldKey.currentState?.openEndDrawer();
                  }
                },
                child: const Icon(
                  Icons.menu_rounded,
                  color: backgroundColor,
                  size: 30,
                ),
              )),
        ],
      );
    } else {
      final userProvider = context.read<UserProvider>();
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                                'assets/images/user.png',
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
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child:
                          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              userProvider.user?.name.toString() ?? 'Loading...',
                              //'Loading...asddddddddddddddddddddddddddddddddddddddd',
                              style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                                userProvider.user?.email.toString() ?? 'Loading...',
                                //'Loading...asddddddddddddddddddddddddddddddddddddddd',
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color: backgroundColor,
                                    fontWeight: FontWeight.w300,
                                    overflow: TextOverflow.ellipsis),
                              ),

                          ]),
                       ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              scaffoldKey.currentState?.openEndDrawer();
              // SimpleHiddenDrawerController.of(context).toggle();
            },
            child: const Icon(
              Icons.menu_rounded,
              color: backgroundColor,
              size: 30,
            ),
          ),
        ],
      );
    }
  }
}
