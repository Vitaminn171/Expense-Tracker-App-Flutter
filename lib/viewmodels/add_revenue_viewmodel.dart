import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/models/user.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/add_revenue.dart' show AddRevenueWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/expense_provider.dart';
import '../providers/revenues_provider.dart';
import '../providers/user_provider.dart';
import '../views/components/custom_alert_dialog.dart';
import 'apis.dart';

class AddRevenueModel extends FlutterFlowModel<AddRevenueWidget> {
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

class AddRevenueViewModel extends ChangeNotifier {
  final RevenueProvider revenueProvider;
  final UserProvider userProvider;

  AddRevenueViewModel(this.userProvider, this.revenueProvider);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isAdded = false;
  bool get isAdded => _isAdded;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  Future<void> getListTransactionsDetail() async {
    final data = revenueProvider.listDetails;
    final dataEdit = revenueProvider.revenueEdit;
    if(data == null || dataEdit == null){
      DateTime now = Utils.now;
      if(!await getDetailsData(DateTime(now.year, now.month, now.day))){
        revenueProvider.setListTransactionsDetail([]);
        revenueProvider.setRevenueEdit(null);
      }
    }else{
      _selectedDate = dataEdit.date;
    }
  }

  void addDetails(DateTime date, String title, String total, TagItem tagItem) async {
    _errorMessage= '';
    if(title.isEmpty || total.isEmpty || int.parse(total.replaceAll(',', '')) < 1000){
      _errorMessage = 'Không để trống thông tin!';
    }else{
      List<TransactionDetails>? list = await revenueProvider.listDetails ?? [];

      list.add(TransactionDetails(name: title, total: int.parse(total.replaceAll(',', '')), tag: tagItem.id));

      revenueProvider.setListTransactionsDetail(list);
      _isAdded = true;
      notifyListeners();
    }
  }

  Future<bool> saveDetails(DateTime date) async {

    _errorMessage= '';
    try{

      final dataDetails = await revenueProvider.listDetails;
      int total = 0;
      List<dynamic> revenueDetail = [];
      for(TransactionDetails item in dataDetails!){
        total += item.total;
        revenueDetail.add({
          'name': item.name,
          'total': item.total,
          'tag': item.tag
        });

      }

      final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
      final dataWallet = queryWalletsnapshot.docs.single.data();
      DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;


      int cash = 0;

      if(revenueProvider.revenueEdit == null){
        final revenueDoc = Api.revenuesCollection.doc(); // Generate a unique document ID

        final revenueData = {
          'email': userProvider.user!.email,
          'date': Timestamp.fromDate(date),
          'total': total,
          'details': revenueDetail
        };
        await revenueDoc.set(revenueData);

        cash = (dataWallet['cash'] + total);
      }else{
        final querySnapshot = await Api.getRevenueDetails(userProvider.user!.email, date);
        if (querySnapshot.size > 0) {
          DocumentSnapshot document = querySnapshot.docs.first;
          DocumentReference revenueRef = document.reference;
          final dataTotal = querySnapshot.docs.first.data();
          cash = (dataWallet['cash'] - dataTotal['total']) + total;
          final revenueData = {
            //'email': userProvider.user!.email,
            //'date': date,
            'total': total,
            'details': revenueDetail
          };
          await revenueRef.update(revenueData);
        }
      }
      final walletData = {
        'cash': cash,
      };
      await walletRef.update(walletData);
      revenueProvider.setState(true);
      userProvider.setUser(
          User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: cash)
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('this_totalCash', cash);
      notifyListeners();
      return true;
    }catch(e){
      revenueProvider.setState(false);
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      print(e);
      return false;
    }


  }

  void cancelDetails() {

    print('saved');


  }



  Future<bool> deleteDetail(int index) async {
    _errorMessage= '';
    try{
      List<TransactionDetails>? list = await revenueProvider.listDetails;
      list?.removeAt(index);
      if(list!.isEmpty && revenueProvider.revenueEdit == null){
        return false;
      }
      revenueProvider.setListTransactionsDetail(list);
      notifyListeners();
      return true;
    }catch(e){
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      return false;
    }
  }

  Future<void> deleteData(DateTime date) async {
    _errorMessage = '';
    try{
      final data = revenueProvider.revenueEdit;
      int cash = data!.total;
      final queryWalletsnapshot = await Api.getWalletData(userProvider.user!.email);
      final dataWallet = queryWalletsnapshot.docs.single.data();
      DocumentReference walletRef = queryWalletsnapshot.docs.single.reference;
      final walletData = {
        'cash': dataWallet['cash'] - cash,
      };
      await walletRef.update(walletData);
      Api.deleteRevenueData(userProvider.user!.email, date);
      revenueProvider.setRevenueEdit(null);
      revenueProvider.setListTransactionsDetail([]);
      revenueProvider.setState(true);
      userProvider.setUser(
          User(email: userProvider.user!.email, name: userProvider.user!.name, totalCash: dataWallet['cash'] - cash)
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('this_totalCash', dataWallet['cash'] - cash);
      notifyListeners();
    }catch(e){
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      print(e);
    }

  }

  Future<bool> getDetailsData(DateTime date) async {
    String email = userProvider.user!.email;
    final querySnapshot = await Api.getRevenueDetails(email, date);
    if(querySnapshot.docs.isNotEmpty){
      print('ok');
      final data = querySnapshot.docs.single.data();
      Transactions revenues = Transactions(
          date: Utils.formatTimeStamptoDate(data['date']),
          total: data['total'],
          details: Utils.getDetails(data['details']));

      revenueProvider.setRevenueEdit(revenues);
      revenueProvider.setListTransactionsDetail(revenues.details);
      notifyListeners();
      return true;
    }else{
      revenueProvider.setRevenueEdit(null);
      revenueProvider.setListTransactionsDetail([]);
      return false;
    }

  }


}