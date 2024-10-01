
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:expenseapp/views/expenseDetail.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';

class ExpenseDetailModel extends FlutterFlowModel<ExpenseDetailWidget> {
  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {}
}

class ExpenseDetailViewModel extends ChangeNotifier {
  final ExpenseProvider expenseProvider;
  final UserProvider userProvider;
  ExpenseDetailViewModel(this.userProvider, this.expenseProvider);


  String getTotal(){
    final data = expenseProvider.expense;
    return Utils.formatCurrency(data!.total);
  }

  String getDate(){
    final data = expenseProvider.expense;
    return data?.date ?? 'Loading..';
  }

  List<TransactionDetails>? getExpenseDetail(){
    final data = expenseProvider.expense?.details;
    return data;
  }

  String formatTimeStamptoDate(Timestamp sec) {
    DateTime date = sec.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  List<int> calByTagItemPercent(){
    final expense = expenseProvider.expense;
    List<int> list = List.filled(Utils.tagExpense.length, 0);
    List<int> listPercent = List.filled(Utils.tagExpense.length, 0);
    if(expense != null){
      int total = expense.total;
      final detail = expense.details;
      for(final item in detail){
        list[item.tag] += item.total;
      }

      for(int i = 0; i < list.length; i ++){
        listPercent[i] = ((list[i] / total) * 100).round();
        print(listPercent[i]);
      }

    }
    return listPercent;
  }


}
