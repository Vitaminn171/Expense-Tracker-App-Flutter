import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String info;
  final String? actionButtonName;
  final Function? action;
  final Function? actionCancel;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.info,
    this.action,
    this.actionButtonName,
    this.actionCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: backgroundColor,
      elevation: 30,
      child: Card(
        elevation: 0,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: textPrimary,
                  fontSize: 25,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                info,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: textPrimary,
                  fontSize: 17,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (actionButtonName == null && actionCancel != null) {
                              actionCancel!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          text: 'Thoát',
                          options: FFButtonOptions(
                            height: 40,
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: backgroundColor,
                            textStyle: TextStyle(
                              fontFamily: 'Nunito',
                              color: alternate2Color,
                              fontSize: 17,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: alternateColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: action != null ? 10 : 0,
                    ),
                    if ((action != null))
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: FFButtonWidget(
                            onPressed: () async {
                              Utils.showLoadingDialog(context);
                              action!();
                            },
                            text: actionButtonName ?? 'Lưu',
                            options: FFButtonOptions(
                              height: 40,
                              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: actionButtonName != null ? errorBackground : secondaryColor,
                              textStyle: TextStyle(
                                fontFamily: 'Nunito',
                                color: actionButtonName != null ? errorText : backgroundColor,
                                fontSize: 17,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
