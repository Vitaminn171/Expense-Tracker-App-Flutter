import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:expenseapp/views/expenseDetail.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';

class ExpenseDetailModel extends FlutterFlowModel<ExpenseDetailWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class ExpenseDetailViewModel extends ChangeNotifier {
  final ExpenseProvider expenseProvider;
  final UserProvider userProvider;
  ExpenseDetailViewModel(this.userProvider, this.expenseProvider);

  String getTotal() {
    final data = expenseProvider.expenseDetail;
    return Utils.formatCurrency(data!.total);
  }

  String getDate() {
    final data = expenseProvider.expenseDetail;
    if (data != null) {
      return Utils.formatDate(data.date);
    }
    return 'Loading..';
  }

  List<TransactionDetails>? getExpenseDetail() {
    final data = expenseProvider.expenseDetail?.details;
    return data;
  }

  String formatTimeStamptoDate(Timestamp sec) {
    DateTime date = sec.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  List<int> calByTagItemPercent() {
    final expense = expenseProvider.expenseDetail;
    List<int> list = List.filled(Utils.tagExpense.length, 0);
    List<int> listPercent = List.filled(Utils.tagExpense.length, 0);
    if (expense != null) {
      int total = expense.total;
      final detail = expense.details;
      for (final item in detail) {
        list[item.tag] += item.total;
      }

      for (int i = 0; i < list.length; i++) {
        listPercent[i] = ((list[i] / total) * 100).round();
      }
    }
    return listPercent;
  }

  bool setEditData() {
    final data = expenseProvider.expenseDetail;
    if (data != null) {
      expenseProvider.setExpenseEdit(data);
      expenseProvider.setListTransactionsDetail(data.details);
      return true;
    }
    return false;
  }
}
