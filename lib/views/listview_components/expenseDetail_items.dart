import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';
import '../../viewmodels/utils.dart';

class ExpenseDetailItems extends StatelessWidget {
  final String name;
  final int total;
  final int tag;


  const ExpenseDetailItems({super.key,
    required this.name,
    required this.total,
    required this.tag
  });

  @override
  Widget build(BuildContext context) {

    return // Generated code for this Row Widget...
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Utils.getTagIcon(tag, Utils.tagExpense)
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style:  TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            letterSpacing: 0.0,
                            color: textSecondary,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            Utils.getTagName(tag,Utils.tagExpense),
                            style:  TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              letterSpacing: 0.0,
                              color: textSecondary,
                              fontWeight:
                              FontWeight.w400,
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
          Text(
            '\$${Utils.formatCurrency(total)}',
            style:  TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 17,
              letterSpacing: 0.0,
              color: textSecondary,
              fontWeight:
              FontWeight.w600,
            ),

          ),
        ],
      )
    ;
  }
}