import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/revenues_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/home.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';
import '../models/user.dart';
import 'apis.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class HomeViewModel extends ChangeNotifier {
  final UserProvider userProvider;
  final ExpenseProvider expenseProvider;
  final RevenueProvider revenueProvider;

  HomeViewModel(this.userProvider, this.expenseProvider, this.revenueProvider);

  Future<int> getCash(String email) async {
    final queryWalletsnapshot = await Api.getWalletData(email);
    final dataWallet = queryWalletsnapshot.docs.single.data();
    return dataWallet['cash'];
  }


  Future<User> getStoredUser() async {
    User user;
    if (userProvider.user != null) {
      user = userProvider.user!;
      return user;
    } else {
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('this_email').toString();
      String name = prefs.getString('this_username').toString();
      int total = prefs.getInt('this_totalCash')!;
      String? photo = prefs.getString('this_photoUrl');



      if (photo == null) {
        user = User(
            name: name,
            email: email,
            totalCash: total,
            imgPath: prefs.getString('this_imgPath'));
      } else {
        user = User(
          name: name,
          email: email,
          totalCash: total,
          photoUrl: photo,
        );
      }

      userProvider.setUser(user);
      notifyListeners();
      return user;
    }
  }

  Future<Map<String, dynamic>> getExpensesRevenueData() async {
    final prefs = await SharedPreferences.getInstance();
    String email = userProvider.user?.email ?? prefs.getString('this_email').toString();
    final expenseList = expenseProvider.expensesList;
    final revenueList = revenueProvider.revenuesList;

    final totalExp = expenseProvider.totalExpenseCurrentMonth;
    final totalRev = revenueProvider.totalRevenue;

    num totalExpense = 0;
    num totalRevenue = 0;
    try {
        if (email.isNotEmpty) {
          final querySnapshot = await Api.getExpenseThisMonth(email);
          final querysnapshotRev = await Api.getRevenueThisMonth(email);
          List<Transactions> list = [];
          List<Transactions> listRev = [];
          if (querySnapshot.size > 0) {
            //final data = querySnapshot.docs.single.data();
            for (final doc in querySnapshot.docs) {
              final data = doc.data();
              //List<TransactionDetails> details = Utils.getDetails(data['details']);
              Transactions expenses = Transactions(
                  date: formatTimeStamptoDate(data['date']),
                  total: data['total'],
                  details: Utils.getDetails(data['details']));
              list.add(expenses);
              totalExpense += data['total'];
              print('Document data: ${expenses.date}');
            }
            expenseProvider.setExpensesList(Future.value(list));
            expenseProvider.setTotalExpenseCurrentMonth(totalExpense.toInt());
            expenseProvider
                .setTotalExpenseRange(Future.value(totalExpense.toInt()));
          }

          if (querysnapshotRev.size > 0) {
            //final data = querySnapshot.docs.single.data();
            for (final doc in querysnapshotRev.docs) {
              final data = doc.data();
              Transactions revenues = Transactions(
                  date: formatTimeStamptoDate(data['date']),
                  total: data['total'],
                  details: Utils.getDetails(data['details']));
              listRev.add(revenues);
              totalRevenue += data['total'];
              print('Document revenue: ${revenues.date}');
            }
            revenueProvider.setRevenuesList(listRev);
            revenueProvider.setTotalRevenue(totalRevenue.toInt());
          }


      }
        return {
          'totalExpense': Utils.formatCurrency(totalExpense.toInt()),
          'totalRevenue': Utils.formatCurrency(totalRevenue.toInt()),
        };
    } catch (e) {
      print(e);
      return {
        'totalExpense': Utils.formatCurrency(totalExpense.toInt()),
        'totalRevenue': Utils.formatCurrency(totalRevenue.toInt()),
      };
    }
  }

  String formatTimeStamptoDate(Timestamp sec) {
    DateTime date = sec.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  String getUserName() {
    return userProvider.user?.name ?? 'Loading...';
  }

  String getEmail() {
    return userProvider.user?.email ?? 'Loading...';
  }
}
