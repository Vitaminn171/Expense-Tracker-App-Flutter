import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/add_expense.dart' show AddExpenseWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';
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
  final textFieldMask_total = MaskTextInputFormatter(mask: '###,###,###,###');
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

  Future<void> getListTransactionsDetail() async {
    DateTime now = Utils.now;
    await getDetailsData(DateTime(now.year, now.month, now.day));
    final data = expenseProvider.listDetails;
    if(data == null){
      expenseProvider.setListTransactionsDetail([]);
    }
  }

  void addDetails(DateTime date, String title, String total, TagItem tagItem) async {
    _errorMessage= '';
    if(title.isEmpty || total.isEmpty || int.parse(total.replaceAll(',', '')) < 1000){
      _errorMessage = 'Không để trống thông tin!';
    }else{
      List<TransactionDetails>? list = await expenseProvider.listDetails ?? [];

      list.add(TransactionDetails(name: title, total: int.parse(total.replaceAll(',', '')), tag: tagItem.id));

      expenseProvider.setListTransactionsDetail(list);
      _isAdded = true;
      notifyListeners();
    }
  }


  Future<void> getDetailsData(DateTime date) async {
    String email = userProvider.user!.email;
    final querySnapshot = await Api.getExpenseDetails(email, date);
    if(querySnapshot.docs.length > 0){
      final data = querySnapshot.docs.single.data();
      Transactions expenses = Transactions(
          date: Utils.formatTimeStamptoDate(data['date']),
          total: data['total'],
          details: Utils.getDetails(data['details']));

      expenseProvider.setExpenseEdit(expenses);
      expenseProvider.setListTransactionsDetail(expenses.details);
    }else{
      expenseProvider.setExpenseEdit(null);
      expenseProvider.setListTransactionsDetail([]);
    }


    return Future.value();
  }

  //TODO 1: check when navigate -> show dialog https://pub.dev/packages/simple_alert_dialog
  //TODO 2: add details data to firebase


}