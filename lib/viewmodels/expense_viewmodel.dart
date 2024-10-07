
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/expense.dart' show ExpenseListWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';
import 'apis.dart';

class ExpenseListModel extends FlutterFlowModel<ExpenseListWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class ExpenseListViewModel extends ChangeNotifier {
  final ExpenseProvider expenseProvider;
  final UserProvider userProvider;
  ExpenseListViewModel(this.userProvider, this.expenseProvider);

  Future<List<Transactions>> getExpList() async {
    final dataExp = expenseProvider.expensesList;
    num totalExpense = 0;
    if (dataExp == null) {
      final querySnapshot = await Api.getExpenseThisMonth(userProvider.user!.email);
      List<Transactions> list = [];
      if (querySnapshot.size > 0) {
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          Transactions expenses = Transactions(date: Utils.formatTimeStamptoDate(data['date']),total: data['total'], details: Utils.getDetails(data['details']));
          list.add(expenses);
          totalExpense += data['total'];
          print('Document data: ${expenses.date}');
        }
        expenseProvider.setExpensesList(Future.value(list));
        expenseProvider.setTotalExpenseRange(Future.value(totalExpense.toInt()));
      }
      return list;
    } else {
      return dataExp;
    }
  }

  Future<List<Transactions>> getExpDateRange(DateTimeRange range) async {
    num totalExpense = 0;
    expenseProvider.setDateTimeRangeExpense(range);
    expenseProvider.setExpensesList(null);
    final expensesCollection =
        FirebaseFirestore.instance.collection('expenses');
    final query = expensesCollection
        .where('email', isEqualTo: userProvider.user?.email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(range.end.add(const Duration(seconds: 10))));
    final querySnapshot = await query.get();
    List<Transactions> list = [];
    if (querySnapshot.size > 0) {
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        Transactions expenses = Transactions(date: Utils.formatTimeStamptoDate(data['date']),total: data['total'], details: Utils.getDetails(data['details']));
        list.add(expenses);
        totalExpense += data['total'];
        print('Document data: ${expenses.date}');
      }
      expenseProvider.setTotalExpenseRange(Future.value(totalExpense.toInt()));
      expenseProvider.setExpensesList(Future.value(list));

      notifyListeners();

      return Future.value(expenseProvider.expensesList);
    }
    expenseProvider.setExpensesList(Future.value([]));
    return Future.value([]);
  }

  void setExpenseDetail(Transactions items){
    expenseProvider.setExpense(items);
    notifyListeners();
  }

  Transactions? getExpenseDetail(){
    final data = expenseProvider.expense;
    return data;
  }

  String formatDatePicker(DateTime date) {
    final formattedDate = DateFormat('dd/MM').format(date);
    return formattedDate;
  }


  DateTimeRange? getDateRange(){
    return expenseProvider.dateTimeRangeExpense;
  }

  Future<void> getExpenxeData(DateTimeRange dateRange) async {
    if(expenseProvider.isUpdated || expenseProvider.expensesList == null){
      getExpDateRange(dateRange);
    }else{
      print('No reload data from Api');
    }
  }

}
