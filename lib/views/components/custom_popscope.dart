
import 'package:flutter/material.dart';

import 'custom_alert_dialog.dart';

class CustomPopscope extends StatelessWidget {
  final String? route;
  final Widget widget;
  final bool? flag;
  final Function? action;

  const CustomPopscope({super.key,
    this.route,
    required this.widget,
    this.flag,
    this.action,
  });


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
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
                  Navigator.popAndPushNamed(context, route == null ? '/Home' : route.toString());
                },
              ));
        }else{
            Navigator.popAndPushNamed(context, route == null ? '/Home' : route.toString());
        }
      }
    },
    child: widget,
    );
  }
}