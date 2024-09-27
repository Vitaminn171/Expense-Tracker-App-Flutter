
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class RevenueProvider extends ChangeNotifier{

  List<Transactions>? _revenuesList;
  List<Transactions>? get revenuesList => _revenuesList;

  void setRevenuesList(List<Transactions>? newRevenue) {
    _revenuesList = newRevenue;
    notifyListeners();
  }

  num? _totalRevenue;
  num? get totalRevenue => _totalRevenue;

  void setTotalRevenue(int newTotal) {
    _totalRevenue = newTotal;
    notifyListeners();
  }
}
