
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';


import 'package:expenseapp/models/colors.dart';

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
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, route);
      },
      text: title,
      options: FFButtonOptions(
        height: 40,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: backgroundColor,
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          color: textPrimary,
          fontSize: 17,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        borderSide: const BorderSide(
          color: alternateColor,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}
