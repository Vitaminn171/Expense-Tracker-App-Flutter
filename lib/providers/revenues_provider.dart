
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class RevenueProvider extends ChangeNotifier{

  // List<Transactions>? _revenuesList;
  // List<Transactions>? get revenuesList => _revenuesList;
  //
  // void setRevenuesList(List<Transactions>? newRevenue) {
  //   _revenuesList = newRevenue;
  //   notifyListeners();
  // }

  num? _totalRevenue;
  num? get totalRevenue => _totalRevenue;

  void setTotalRevenue(int? newTotal) {
    _totalRevenue = newTotal;
    notifyListeners();
  }

  Future<List<Transactions>>? _revenuesList;
  Future<List<Transactions>>? get revenuesList => _revenuesList;

  void setRevenuesList(Future<List<Transactions>>? newRevenue) {
    _revenuesList = newRevenue;
    notifyListeners();
  }

  num? _totalRevenueCurrentMonth;
  num? get totalRevenueCurrentMonth => _totalRevenueCurrentMonth;

  void setTotalRevenueCurrentMonth(int newTotal) {
    _totalRevenueCurrentMonth = newTotal;
    notifyListeners();
  }

  Future<num>? _totalRevenueRange;
  Future<num>? get totalRevenueRange => _totalRevenueRange;

  void setTotalRevenueRange(Future<int> newTotal) {
    _totalRevenueRange = newTotal;
    notifyListeners();
  }

  Transactions? _revenueDetail;
  Transactions? get revenueDetail => _revenueDetail;

  void setRevenueDetail(Transactions? newRevenue) {
    _revenueDetail = newRevenue;
    notifyListeners();
  }


  DateTimeRange? _dateTimeRangeRevenue;
  DateTimeRange? get dateTimeRangeRevenue => _dateTimeRangeRevenue;

  void setDateTimeRangeRevenue(DateTimeRange? newDateRange) {
    _dateTimeRangeRevenue = newDateRange;
    notifyListeners();
  }

  List<int>? _tagItemPercent;
  List<int>? get tagItemPercent => _tagItemPercent;

  void setTagItemPercent(List<int> newList){
    _tagItemPercent = newList;
    notifyListeners();
  }

  Future<List<TransactionDetails>>? _listDetails;
  Future<List<TransactionDetails>>? get listDetails => _listDetails;

  void setListTransactionsDetail(List<TransactionDetails>? newList){
    _listDetails = Future.value(newList);
    notifyListeners();
  }

  Transactions? _revenueEdit;
  Transactions? get revenueEdit => _revenueEdit;

  void setRevenueEdit(Transactions? newExpense) {
    _revenueEdit = newExpense;
    notifyListeners();
  }

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setState(bool newState) {
    _isUpdated = newState;
    notifyListeners();
  }


  void logout(){
    _revenuesList = null;
    _totalRevenueCurrentMonth = null;
    _totalRevenueRange = Future.value(0);
    _revenueDetail = null;
    _dateTimeRangeRevenue = null;
    _tagItemPercent = null;
    _revenueEdit = null;
    _listDetails = Future.value([]);
    _isUpdated = false;
  }

}
