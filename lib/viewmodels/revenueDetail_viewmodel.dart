
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:expenseapp/views/revenueDetail.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../providers/revenues_provider.dart';
import '../providers/user_provider.dart';

class RevenueDetailModel extends FlutterFlowModel<RevenueDetailWidget> {
  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {}
}

class RevenueDetailViewModel extends ChangeNotifier {
  final RevenueProvider revenueProvider;
  final UserProvider userProvider;
  RevenueDetailViewModel(this.userProvider, this.revenueProvider);


  String getTotal(){
    final data = revenueProvider.revenueDetail;
    return Utils.formatCurrency(data!.total);
  }

  String getDate(){
    final data = revenueProvider.revenueDetail;
    if(data != null){
      return Utils.formatDate(data.date);
    }
    return 'Loading..';
  }

  List<TransactionDetails>? getExpenseDetail(){
    final data = revenueProvider.revenueDetail?.details;
    return data;
  }

  String formatTimeStamptoDate(Timestamp sec) {
    DateTime date = sec.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  List<int> calByTagItemPercent(){
    final revenue = revenueProvider.revenueDetail;
    List<int> list = List.filled(Utils.tagRevenue.length, 0);
    List<int> listPercent = List.filled(Utils.tagRevenue.length, 0);
    if(revenue != null){
      int total = revenue.total;
      final detail = revenue.details;
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

  bool setEditData(){
    final data = revenueProvider.revenueDetail;
    if(data != null){
      revenueProvider.setRevenueEdit(data);
      revenueProvider.setListTransactionsDetail(data.details);
      return true;
    }
    return false;
  }


}
