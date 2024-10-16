import 'package:flutter/material.dart';

import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';

class TransactionItems extends StatelessWidget {
  final DateTime date;
  final int total;

  const TransactionItems({super.key, required this.date, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày ${Utils.formatDate(date)}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: textPrimary,
                        fontWeight: FontWeight.w300,
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
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            letterSpacing: 0.0,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Padding(
          padding:  EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textPrimary,
            size: 18,
          ),
        ),
      ],
    );
  }
}
