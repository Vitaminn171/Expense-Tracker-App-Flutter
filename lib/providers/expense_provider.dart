
import 'package:expenseapp/models/transaction.dart';
import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier{

  Future<List<Transactions>>? _expensesList;
  Future<List<Transactions>>? get expensesList => _expensesList;

  void setExpensesList(Future<List<Transactions>>? newExpense) {
    _expensesList = newExpense;
    notifyListeners();
  }

  num? _totalExpenseCurrentMonth;
  num? get totalExpenseCurrentMonth => _totalExpenseCurrentMonth;

  void setTotalExpenseCurrentMonth(int newTotal) {
    _totalExpenseCurrentMonth = newTotal;
    notifyListeners();
  }

  Future<num>? _totalExpenseRange;
  Future<num>? get totalExpenseRange => _totalExpenseRange;

  void setTotalExpenseRange(Future<int> newTotal) {
    _totalExpenseRange = newTotal;
    notifyListeners();
  }

  Transactions? _expense;
  Transactions? get expense => _expense;

  void setExpense(Transactions? newExpense) {
    _expense = newExpense;
    notifyListeners();
  }


  DateTimeRange? _dateTimeRangeExpense;
  DateTimeRange? get dateTimeRangeExpense => _dateTimeRangeExpense;

  void setDateTimeRangeExpense(DateTimeRange? newDateRange) {
    _dateTimeRangeExpense = newDateRange;
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

  Transactions? _expenseEdit;
  Transactions? get expenseEdit => _expenseEdit;

  void setExpenseEdit(Transactions? newExpense) {
    _expenseEdit = newExpense;
    notifyListeners();
  }


  void logout(){
    _expensesList = null;
    _totalExpenseCurrentMonth = 0;
    _totalExpenseRange = Future.value(0);
    _expense = null;
    _dateTimeRangeExpense = null;
    _tagItemPercent = null;
  }

}
