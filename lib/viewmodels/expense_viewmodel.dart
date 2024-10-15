
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/expense.dart' show ExpenseListWidget;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/models/user.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
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

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

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
    String? email = userProvider.user?.email;

    if(email != null){
      final querySnapshot = await Api.getExpenseRange(email, range);
      List<Transactions> list = [];
      if (querySnapshot.size > 0) {
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          Transactions expenses = Transactions(date: Utils.formatTimeStamptoDate(data['date']),total: data['total'], details: Utils.getDetails(data['details']));
          list.add(expenses);
          totalExpense += data['total'];
        }
        expenseProvider.setTotalExpenseRange(Future.value(totalExpense.toInt()));
        expenseProvider.setExpensesList(Future.value(list));

        notifyListeners();

        return Future.value(expenseProvider.expensesList);
      }
    }
    expenseProvider.setTotalExpenseRange(Future.value(totalExpense.toInt()));
    expenseProvider.setExpensesList(Future.value([]));
    return Future.value([]);
  }

  void setExpenseDetail(Transactions items){
    expenseProvider.setExpenseDetail(items);
    notifyListeners();
  }

  Transactions? getExpenseDetail(){
    final data = expenseProvider.expenseDetail;
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
      if (kDebugMode) {
        print('No reload data from Api');
      }
    }
  }

  Future<void> deleteData(int index) async {
    _errorMessage = '';
    try{
      final dataList = await expenseProvider.expensesList;
      final data = dataList?.elementAt(index);
      if(data != null){
        int cash = data.total;
        final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
        final dataWallet = queryWalletsnapshot.docs.single.data();
        DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;
        final walletData = {
          'cash': dataWallet['cash'] + cash,
        };
        await walletRef.update(walletData);
        Api.deleteExpenseData(userProvider.user!.email, data.date);
        dataList!.removeAt(index);
        expenseProvider.setExpenseEdit(null);
        expenseProvider.setListTransactionsDetail([]);
        expenseProvider.setExpensesList(Future.value(dataList));
        expenseProvider.setState(true);
        userProvider.setUser(
            User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: dataWallet['cash'] + cash)
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('this_totalCash', dataWallet['cash'] + cash);
        notifyListeners();
      }
    }catch(e){
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      if (kDebugMode) {
        print(e);
      }
    }

  }

}
