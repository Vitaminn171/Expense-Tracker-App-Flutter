
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/revenues_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Utils {
  static DateTime now = DateTime.now();

  static String emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$";

  static final tagExpense = [
    TagItem(id: 0, name: 'Ăn uống', icon: Icons.fastfood_rounded, color: tag0),
    TagItem(id: 1, name: 'Mua sắm', icon: Icons.shopping_bag_rounded, color: tag1),
    TagItem(id: 2, name: 'Hóa đơn', icon: Icons.receipt_long_rounded, color: tag2),
    TagItem(id: 3, name: 'Khác', icon: Icons.category_rounded, color: tag3),
  ];

  static final tagRevenue = [
    TagItem(id: 0, name: 'Lương tháng', icon: Icons.attach_money_rounded, color: tag0),
    TagItem(id: 1, name: 'Thưởng', icon: Icons.paid_rounded, color: tag1),
    TagItem(id: 2, name: 'Khác', icon: Icons.category_rounded, color: tag3),
  ];

  static String getMonth(){
    return now.month.toString();
  }


  static bool isValidEmail(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
  static String formatCurrency(int totalExpense){
    if(totalExpense > 99999999){
      NumberFormat format = NumberFormat.compactLong(locale: 'vi');
      String formattedNumber = format.format(totalExpense);
      return formattedNumber;
    }else{
      NumberFormat format = NumberFormat.decimalPattern();
      String formattedNumber = format.format(totalExpense);
      return formattedNumber;
    }
  }

  static String formatDatePicker(DateTime date){
    final formattedDate = DateFormat('dd/MM').format(date);
    return formattedDate;
  }

  static String formatDate(DateTime date){
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  static List<TransactionDetails> getDetails(List<dynamic> list){
    List<TransactionDetails> details = [];
    for(final item in list){
      final temp = TransactionDetails(name: item['name'],total: item['total'],tag: item['tag']);
      details.add(temp);
    }
    return details;
  }

  static Future<void> clearPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool> logout(BuildContext context) async {
    try{
      clearPref();
      UserProvider userProvider = context.read<UserProvider>();
      ExpenseProvider expenseProvider = context.read<ExpenseProvider>();
      RevenueProvider revenueProvider = context.read<RevenueProvider>();

      userProvider.logout();
      expenseProvider.logout();
      revenueProvider.logout();
      return true;
    }catch (e){
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }

  }
  
  static String getTagName(int tagId, List<TagItem> list){
    for(TagItem item in list){
      if(tagId == item.id){
        return item.name;
      }
    }
    return '';
  }

  static IconData getTagIcon(int tagId, List<TagItem> list){
    for(TagItem item in list){
      if(tagId == item.id){
        return item.icon;
      }
    }
    return Icons.add;
  }

  static TagItem getTag(int tagId, List<TagItem> list){
    for(TagItem item in list){
      if(tagId == item.id){
        return item;
      }
    }
    return TagItem(id: 0, name: '', icon: Icons.abc, color: Colors.white);
  }

  static DateTime formatTimeStamptoDate(Timestamp sec) {
    DateTime date = sec.toDate();
    return date;
  }

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }





}