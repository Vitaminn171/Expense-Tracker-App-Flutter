import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';

class TagItemsWidget extends StatelessWidget {
  final int tagId;
  final int percent;

  const TagItemsWidget({
    super.key,
    required this.tagId,
    required this.percent,

  });

  @override
  Widget build(BuildContext context) {
    TagItem tagItem = Utils.getTag(tagId, Utils.tagExpense);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color(0x6EF4F4F4),
        //: backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Color(0x33000000),
            offset: Offset(
              0,
              0,
            ),
            spreadRadius: 5,
          )
        ],
        borderRadius:
        BorderRadius.circular(28),
      ),
      child: Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
            8, 8, 0, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              elevation: 0,
              color: tagItem.color,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    20),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(8),
                child: Icon(tagItem.icon, color: backgroundColor, size: 30,),
              )
            ),
        Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(
              5, 0, 0, 0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${Utils.getTagName(tagId, Utils.tagExpense)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    letterSpacing: 0.0,
                    color: textPrimary,
                    fontWeight: FontWeight.w400,
                  ),),
                Text('$percent%',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    letterSpacing: 0.0,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
