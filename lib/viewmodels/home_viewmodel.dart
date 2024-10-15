import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/revenues_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/home.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/models/user.dart';
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

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<int> getCash(String email) async {
    final queryWalletsnapshot = await Api.getWalletData(email);
    final dataWallet = queryWalletsnapshot.docs.single.data();
    return dataWallet['cash'];
  }

  Future<User> getStoredUser() async {
    User user;
    final prefs = await SharedPreferences.getInstance();
    if (expenseProvider.isUpdated) {
      if (kDebugMode) {
        print('Cash update');
      }
      User userTemp = userProvider.user!;
      String? photo = prefs.getString('this_photoUrl');
      if (photo == null) {
        user = User(name: userTemp.name, email: userTemp.email, totalCash: await getCash(userTemp.email), imgPath: prefs.getString('this_imgPath'));
      } else {
        user = User(
          name: userTemp.name,
          email: userTemp.email,
          totalCash: await getCash(userTemp.email),
          photoUrl: photo,
        );
      }
    } else {
      if (userProvider.user != null) {
        user = userProvider.user!;
        return user;
      } else {
        String email = prefs.getString('this_email').toString();
        String name = prefs.getString('this_username').toString();
        int total = prefs.getInt('this_totalCash')!;
        String? photo = prefs.getString('this_photoUrl');

        if (photo == null) {
          user = User(name: name, email: email, totalCash: total, imgPath: prefs.getString('this_imgPath'));
        } else {
          user = User(
            name: name,
            email: email,
            totalCash: total,
            photoUrl: photo,
          );
        }
      }
    }
    expenseProvider.setState(false);
    userProvider.setUser(user);
    notifyListeners();
    return user;
  }

  Future<void> getHomeData() async {
    User user = await getStoredUser();
    final prefs = await SharedPreferences.getInstance();
    String email = userProvider.user?.email ?? prefs.getString('this_email').toString();

    num totalExpense = 0;
    num totalRevenue = 0;

    if (expenseProvider.isUpdated || expenseProvider.totalExpenseCurrentMonth == null) {
      print('Reload data from Api');

      try {
        if (email.isNotEmpty) {
          final querySnapshot = await Api.getExpenseThisMonth(email);
          //final querysnapshotRev = await Api.getRevenueThisMonth(email);
          List<Transactions> list = [];
          //List<Transactions> listRev = [];
          if (querySnapshot.size > 0) {
            //final data = querySnapshot.docs.single.data();
            for (final doc in querySnapshot.docs) {
              final data = doc.data();
              //List<TransactionDetails> details = Utils.getDetails(data['details']);
              Transactions expenses =
                  Transactions(date: Utils.formatTimeStamptoDate(data['date']), total: data['total'], details: Utils.getDetails(data['details']));
              list.add(expenses);
              totalExpense += data['total'];
              print('Document data: ${expenses.date}');
            }
          }
          expenseProvider.setExpensesList(Future.value(list));
          expenseProvider.setTotalExpenseCurrentMonth(totalExpense.toInt());
          expenseProvider.setTotalExpenseRange(Future.value(totalExpense.toInt()));
        }
      } catch (e) {
        print(e);
      }
      expenseProvider.setState(false);
      notifyListeners();
    } else if (revenueProvider.isUpdated || revenueProvider.totalRevenueCurrentMonth == null) {
      print('Reload data from Api');

      try {
        if (email.isNotEmpty) {
          //final querySnapshot = await Api.getExpenseThisMonth(email);
          final querysnapshotRev = await Api.getRevenueThisMonth(email);
          //List<Transactions> list = [];
          List<Transactions> listRev = [];

          if (querysnapshotRev.size > 0) {
            //final data = querySnapshot.docs.single.data();
            for (final doc in querysnapshotRev.docs) {
              final data = doc.data();
              Transactions revenues =
                  Transactions(date: Utils.formatTimeStamptoDate(data['date']), total: data['total'], details: Utils.getDetails(data['details']));
              listRev.add(revenues);
              totalRevenue += data['total'];
              print('Document revenue: ${revenues.date}');
            }
            revenueProvider.setRevenuesList(Future.value(listRev));
            revenueProvider.setTotalRevenueCurrentMonth(totalRevenue.toInt());
            revenueProvider.setTotalRevenueRange(Future.value(totalRevenue.toInt()));
          }
        }
      } catch (e) {
        print(e);
      }
      expenseProvider.setState(false);
      notifyListeners();
    } else {
      print('No reload data from Api');
    }
  }

  Future<Map<String, dynamic>> getExpensesRevenueData() async {
    final prefs = await SharedPreferences.getInstance();
    String email = userProvider.user?.email ?? prefs.getString('this_email').toString();

    num totalExpense = 0;
    num totalRevenue = 0;
    try {
      if (email.isNotEmpty) {
        if (expenseProvider.isUpdated || expenseProvider.totalExpenseCurrentMonth == null) {
          final querySnapshot = await Api.getExpenseThisMonth(email);
          Map<String, dynamic> dataExp = calData(querySnapshot, email);
          totalExpense = dataExp['total'];
          expenseProvider.setExpensesList(Future.value(dataExp['list']));
          expenseProvider.setTotalExpenseCurrentMonth(dataExp['total'].toInt());
          expenseProvider.setTotalExpenseRange(Future.value(dataExp['total'].toInt()));
          expenseProvider.setState(false);
          notifyListeners();
        } else {
          if (kDebugMode) {
            print('No reload expense data');
          }
          totalExpense = expenseProvider.totalExpenseCurrentMonth ?? 0;
        }

        if (revenueProvider.isUpdated || revenueProvider.totalRevenueCurrentMonth == null) {
          final querysnapshotRev = await Api.getRevenueThisMonth(email);
          Map<String, dynamic> dataRev = calData(querysnapshotRev, email);
          totalRevenue = dataRev['total'];
          revenueProvider.setRevenuesList(Future.value(dataRev['list']));
          revenueProvider.setTotalRevenueCurrentMonth(dataRev['total'].toInt());
          revenueProvider.setTotalRevenueRange(Future.value(dataRev['total'].toInt()));
          revenueProvider.setState(false);
          notifyListeners();
        } else {
          if (kDebugMode) {
            print('No reload revenue data');
          }
          totalRevenue = revenueProvider.totalRevenueCurrentMonth ?? 0;
        }
      }

      return {
        'totalExpense': Utils.formatCurrency(totalExpense.toInt()),
        'totalRevenue': Utils.formatCurrency(totalRevenue.toInt()),
      };
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      expenseProvider.setState(false);
      revenueProvider.setState(false);
      notifyListeners();
      return {
        'totalExpense': Utils.formatCurrency(totalExpense.toInt()),
        'totalRevenue': Utils.formatCurrency(totalRevenue.toInt()),
      };
    }
  }

  Map<String, dynamic> calData(QuerySnapshot<Map<String, dynamic>> querySnapshot, String email) {
    num total = 0;
    List<Transactions> list = [];
    if (querySnapshot.size > 0) {
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        Transactions transactions =
            Transactions(date: Utils.formatTimeStamptoDate(data['date']), total: data['total'], details: Utils.getDetails(data['details']));
        list.add(transactions);
        total += data['total'];
      }
    }
    return {'total': total, 'list': list};
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
