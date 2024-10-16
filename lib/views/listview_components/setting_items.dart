import 'package:flutter/material.dart';

import 'package:expenseapp/models/colors.dart';

class SettingItems extends StatelessWidget {
  final String text;
  final Function action;
  final IconData icon;

  const SettingItems({super.key, required this.text, required this.action, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(25, 5, 25, 0),
      child: InkWell(
          onTap: () {
            action;
          },
          child: Card(
            elevation: 10,
            color: glassColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: backgroundColor,
                          size: 30,
                        ),
                        Flexible(
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 5, 0),
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w400,
                                  color: backgroundColor,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: backgroundColor,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
