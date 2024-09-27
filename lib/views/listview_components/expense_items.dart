import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';
import '../../viewmodels/utils.dart';

class ExpenseItems extends StatelessWidget {
  final String date;
  final int total;


  const ExpenseItems({super.key,
    required this.date,
    required this.total
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding:
            EdgeInsetsDirectional
                .fromSTEB(
                0, 10, 0, 10),
            child: Row(
              mainAxisSize:
              MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize:
                  MainAxisSize
                      .min,
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'Ngày $date',
                      style:
                      TextStyle(
                        fontFamily:
                        'Montserrat',
                        fontSize: 18,
                        letterSpacing:
                        0.0,
                        color:
                        textSecondary,
                        fontWeight:
                        FontWeight
                            .w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(
          '\$${Utils.formatCurrency(total)}',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            letterSpacing: 0.0,
            color: textSecondary,
            fontWeight:
            FontWeight.w600,
          ),
        ),
        Padding(
          padding:
          EdgeInsetsDirectional
              .fromSTEB(
              10, 0, 0, 0),
          child: Icon(
            Icons
                .arrow_forward_ios_rounded,
            color: textSecondary,
            size: 18,
          ),
        ),
      ],
    );
  }
}