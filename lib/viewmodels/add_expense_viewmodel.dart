import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/models/user.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/add_expense.dart' show AddExpenseWidget;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'apis.dart';

class AddExpenseModel extends FlutterFlowModel<AddExpenseWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode_date;
  TextEditingController? textController_date;
  String? Function(BuildContext, String?)? textControllerValidator_date;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode_title;
  TextEditingController? textController_title;
  String? Function(BuildContext, String?)? textControllerValidator_title;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode_total;
  TextEditingController? textController_total;
  String? Function(BuildContext, String?)? textControllerValidator_total;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode_tag;
  TextEditingController? textController_tag;
  String? Function(BuildContext, String?)? textControllerValidator_tag;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode_date?.dispose();
    textController_date?.dispose();

    textFieldFocusNode_title?.dispose();
    textController_title?.dispose();

    textFieldFocusNode_total?.dispose();
    textController_total?.dispose();

    textFieldFocusNode_tag?.dispose();
    textController_tag?.dispose();
  }
}

class AddExpenseViewModel extends ChangeNotifier {
  final ExpenseProvider expenseProvider;
  final UserProvider userProvider;

  AddExpenseViewModel(this.userProvider, this.expenseProvider);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isAdded = false;
  bool get isAdded => _isAdded;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  Future<void> getListTransactionsDetail() async {
    final data = expenseProvider.listDetails;
    final dataEdit = expenseProvider.expenseEdit;
    if (data == null || dataEdit == null) {
      DateTime now = Utils.now;
      if (!await getDetailsData(DateTime(now.year, now.month, now.day))) {
        expenseProvider.setListTransactionsDetail([]);
        expenseProvider.setExpenseEdit(null);
      }
    } else {
      _selectedDate = dataEdit.date;
    }
  }

  void addDetails(DateTime date, String title, String total, TagItem tagItem) async {
    _errorMessage = '';
    if (title.isEmpty || total.isEmpty || int.parse(total.replaceAll(',', '')) < 1000) {
      _errorMessage = 'Không để trống thông tin!';
    } else {
      List<TransactionDetails>? list = await expenseProvider.listDetails ?? [];
      list.insert(0, TransactionDetails(name: title, total: int.parse(total.replaceAll(',', '')), tag: tagItem.id));
      expenseProvider.setListTransactionsDetail(list);
      _isAdded = true;
      notifyListeners();
    }
  }

  Future<bool> saveDetails(DateTime date) async {
    _errorMessage = '';
    try {
      final dataDetails = await expenseProvider.listDetails;
      int total = 0;
      List<dynamic> expenseDetail = [];
      for (TransactionDetails item in dataDetails!) {
        total += item.total;
        expenseDetail.add({'name': item.name, 'total': item.total, 'tag': item.tag});
      }

      final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
      final dataWallet = queryWalletsnapshot.docs.single.data();
      DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;

      int cash = 0;

      if (expenseProvider.expenseEdit == null) {
        final expenseDoc = Api.expensesCollection.doc(); // Generate a unique document ID

        final expenseData = {'email': userProvider.user!.email, 'date': Timestamp.fromDate(date), 'total': total, 'details': expenseDetail};
        await expenseDoc.set(expenseData);

        cash = (dataWallet['cash'] - total);
      } else {
        final querySnapshot = await Api.getExpenseDetails(userProvider.user!.email, date);
        if (querySnapshot.size > 0) {
          DocumentSnapshot document = querySnapshot.docs.first;
          DocumentReference expenseRef = document.reference;
          final dataTotal = querySnapshot.docs.first.data();
          cash = (dataWallet['cash'] + dataTotal['total']) - total;
          final expenseData = {'total': total, 'details': expenseDetail};
          await expenseRef.update(expenseData);
        }
      }
      final walletData = {
        'cash': cash,
      };
      await walletRef.update(walletData);
      expenseProvider.setState(true);
      userProvider.setUser(User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: cash));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('this_totalCash', cash);
      notifyListeners();
      return true;
    } catch (e) {
      expenseProvider.setState(false);
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteDetail(int index) async {
    _errorMessage = '';
    try {
      List<TransactionDetails>? list = await expenseProvider.listDetails;
      list?.removeAt(index);
      if (list!.isEmpty && expenseProvider.expenseEdit == null) {
        return false;
      }
      expenseProvider.setListTransactionsDetail(list);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> deleteData(DateTime date) async {
    _errorMessage = '';
    try {
      final data = expenseProvider.expenseEdit;
      int cash = data!.total;
      final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
      final dataWallet = queryWalletsnapshot.docs.single.data();
      DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;
      final walletData = {
        'cash': dataWallet['cash'] + cash,
      };
      await walletRef.update(walletData);
      Api.deleteExpenseData(userProvider.user!.email, date);
      expenseProvider.setExpenseEdit(null);
      expenseProvider.setListTransactionsDetail([]);
      expenseProvider.setState(true);
      userProvider.setUser(User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: dataWallet['cash'] + cash));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('this_totalCash', dataWallet['cash'] + cash);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> getDetailsData(DateTime date) async {
    String email = userProvider.user!.email;
    final querySnapshot = await Api.getExpenseDetails(email, date);
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.single.data();
      Transactions transactions =
          Transactions(date: Utils.formatTimeStamptoDate(data['date']), total: data['total'], details: Utils.getDetails(data['details']));

      expenseProvider.setExpenseEdit(transactions);
      expenseProvider.setListTransactionsDetail(transactions.details);
      notifyListeners();
      return true;
    } else {
      expenseProvider.setExpenseEdit(null);
      expenseProvider.setListTransactionsDetail([]);
      return false;
    }
  }
}
