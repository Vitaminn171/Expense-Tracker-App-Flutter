
import 'package:flutter/material.dart';

import 'custom_alert_dialog.dart';

class CustomPopscope extends StatelessWidget {
  final String? route;
  final Widget widget;
  final bool? flag;
  final Function? action;
  final bool? home;

  const CustomPopscope({super.key,
    this.route,
    required this.widget,
    this.flag,
    this.action,
    this.home,
  });


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result)  {
      if (!didPop) {
        if(flag != null && flag!){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertDialog(
                title: 'Dữ liệu chưa được lưu!',
                info: 'Dữ liệu của bạn chưa được lưu. Bạn có muốn lưu lại trước khi thoát không?',
                action: () {
                  action!();
                },
                actionCancel: (){
                  Navigator.pop(context);
                },
              ));
        }else{
            //Navigator.pushNamed(context, route == null ? '/Home' : route.toString());
          // if(home != null && home!){
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) => CustomAlertDialog(
          //         title: 'Đăng xuất?',
          //         info: 'Bạn muốn đăng xuất khỏi tài khoản này?',
          //         actionButtonName: 'Đăng xuất',
          //         action: () {
          //           action!();
          //         },
          //       ));
          // }else{
          //   Navigator.pop(context);
          // }
          //Navigator.of(context, rootNavigator: true).pop;
          if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }


        }
      }
    },
    child: widget,
    );
  }
}