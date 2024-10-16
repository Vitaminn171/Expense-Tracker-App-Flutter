import 'package:expenseapp/models/tag.dart';
import 'package:flutter/material.dart';

import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';

class TransactionDetailItems extends StatelessWidget {
  final String name;
  final int total;
  final int tag;
  final int type;

  const TransactionDetailItems({super.key, required this.name, required this.total, required this.tag, required this.type});

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
    TagItem tagItem = Utils.getTag(tag, list);
    return // Generated code for this Row Widget...
        Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 12, 7),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Card(
                      elevation: 0,
                      color: tagItem.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(8),
                        child: Icon(
                          tagItem.icon,
                          color: backgroundColor,
                          size: 25,
                        ),
                      )),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0.0,
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          tagItem.name,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            letterSpacing: 0.0,
                            color: textSecondary,
                            fontWeight: FontWeight.w400,
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
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 17,
            letterSpacing: 0.0,
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
