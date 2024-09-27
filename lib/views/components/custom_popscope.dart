import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/colors.dart';

class CustomPopscope extends StatelessWidget {
  final String? route;
  final Widget widget;

  CustomPopscope({super.key,
    this.route,
    required this.widget
  });


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
      if (!didPop) {
        Navigator.popAndPushNamed(context, route == null ? '/Home' : route.toString());
      }
    },
    child: widget,
    );
  }
}