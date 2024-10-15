
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/revenue.dart' show RevenueListWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/revenues_provider.dart';
import '../providers/user_provider.dart';
import 'apis.dart';

class RevenueListModel extends FlutterFlowModel<RevenueListWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class RevenueListViewModel extends ChangeNotifier {
  final RevenueProvider revenueProvider;
  final UserProvider userProvider;
  RevenueListViewModel(this.userProvider, this.revenueProvider);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<List<Transactions>> getRevList() async {
    final dataExp = revenueProvider.revenuesList;
    num totalRevenue = 0;
    if (dataExp == null) {
      final querySnapshot = await Api.getExpenseThisMonth(userProvider.user!.email);
      List<Transactions> list = [];
      if (querySnapshot.size > 0) {
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          Transactions revenues = Transactions(date: Utils.formatTimeStamptoDate(data['date']),total: data['total'], details: Utils.getDetails(data['details']));
          list.add(revenues);
          totalRevenue += data['total'];
          print('Document data: ${revenues.date}');
        }
        revenueProvider.setRevenuesList(Future.value(list));
        revenueProvider.setTotalRevenueRange(Future.value(totalRevenue.toInt()));
      }
      return list;
    } else {
      return dataExp;
    }
  }

  Future<List<Transactions>> getRevDateRange(DateTimeRange range) async {
    num totalExpense = 0;
    revenueProvider.setDateTimeRangeRevenue(range);
    revenueProvider.setRevenuesList(null);
    String? email = userProvider.user?.email;

    if(email != null){
      final querySnapshot = await Api.getRevenueRange(email, range);
      List<Transactions> list = [];
      if (querySnapshot.size > 0) {
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          Transactions expenses = Transactions(date: Utils.formatTimeStamptoDate(data['date']),total: data['total'], details: Utils.getDetails(data['details']));
          list.add(expenses);
          totalExpense += data['total'];
          print('Document data: ${expenses.date}');
        }
        revenueProvider.setTotalRevenueRange(Future.value(totalExpense.toInt()));
        revenueProvider.setRevenuesList(Future.value(list));
        notifyListeners();

        return Future.value(revenueProvider.revenuesList);
      }
    }
    revenueProvider.setTotalRevenueRange(Future.value(totalExpense.toInt()));
    revenueProvider.setRevenuesList(Future.value([]));
    return Future.value([]);
  }

  void setRevenueDetail(Transactions items){
    revenueProvider.setRevenueDetail(items);
    notifyListeners();
  }

  Transactions? getRevenueDetail(){
    final data = revenueProvider.revenueDetail;
    return data;
  }


  DateTimeRange? getDateRange(){
    return revenueProvider.dateTimeRangeRevenue;
  }

  Future<void> getRevenueData(DateTimeRange dateRange) async {
    if(revenueProvider.isUpdated || revenueProvider.revenuesList == null){
      getRevDateRange(dateRange);
    }else{
      print('No reload data from Api');
    }
  }

  Future<void> deleteData(int index) async {
    _errorMessage = '';
    try{
      final dataList = await revenueProvider.revenuesList;
      final data = dataList?.elementAt(index);
      if(data != null) {
        int cash = data.total;
        final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
        final dataWallet = queryWalletsnapshot.docs.single.data();
        DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;
        final walletData = {
          'cash': dataWallet['cash'] - cash,
        };
        await walletRef.update(walletData);
        Api.deleteRevenueData(userProvider.user!.email, data.date);
        revenueProvider.setRevenueEdit(null);
        revenueProvider.setListTransactionsDetail([]);
        revenueProvider.setState(true);
        userProvider.setUser(
            User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: dataWallet['cash'] - cash)
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('this_totalCash', dataWallet['cash'] - cash);
        notifyListeners();
      }
    }catch(e){
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      print(e);
    }

  }

}
