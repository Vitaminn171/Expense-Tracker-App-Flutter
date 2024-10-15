import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/material.dart';

import 'package:expenseapp/models/colors.dart';

class TagItemsWidget extends StatelessWidget {
  final int tagId;
  final int percent;
  final int type;

  const TagItemsWidget({
    super.key,
    required this.tagId,
    required this.percent,
    required this.type,

  });

  @override
  Widget build(BuildContext context) {
    List<TagItem> list = [];
    switch (type) {
      case 0:
        list = Utils.tagExpense;
        break;
      case 1:
        list = Utils.tagRevenue;
        break;
    // ... more cases
    }
    TagItem tagItem = Utils.getTag(tagId, list);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0x6EF4F4F4),
        //: backgroundColor,
        boxShadow: const [
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
        padding: const
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
                padding: const EdgeInsetsDirectional.all(8),
                child: Icon(tagItem.icon, color: backgroundColor, size: 30,),
              )
            ),
        Padding(
          padding: const
          EdgeInsetsDirectional.fromSTEB(
              5, 0, 0, 0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getTagName(tagId, list),
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
