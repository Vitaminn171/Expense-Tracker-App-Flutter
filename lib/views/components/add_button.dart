import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';

class AddButton extends StatelessWidget {
  final String title;
  final String route;

  const AddButton({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: () async {
        Navigator.popAndPushNamed(context, route);
      },
      text: title,
      options: FFButtonOptions(
        height: 40,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: backgroundColor,
        textStyle: TextStyle(
          fontFamily: 'Nunito',
          color: textPrimary,
          fontSize: 17,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        borderSide: BorderSide(
          color: alternateColor,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}
