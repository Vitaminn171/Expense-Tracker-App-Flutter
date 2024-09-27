
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class Utils {

  static String emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$";

  static final tagExpense = [
    TagItem(id: 0, name: 'Ăn uống', icon: Icon(Icons.fastfood_rounded, color: textSecondary,size: 34,)),
    TagItem(id: 1, name: 'Mua sắm', icon: Icon(Icons.shopping_bag_rounded, color: textSecondary,size: 34,)),
    TagItem(id: 2, name: 'Hóa đơn', icon: Icon(Icons.receipt_long_rounded, color: textSecondary,size: 34,)),
    TagItem(id: 3, name: 'Khác', icon: Icon(Icons.category_rounded, color: textSecondary,size: 34,)),
  ];

  static final tagRevenue = [
    TagItem(id: 0, name: 'Lương tháng', icon: Icon(Icons.attach_money_rounded, color: textSecondary,size: 34,)),
    TagItem(id: 1, name: 'Thưởng', icon: Icon(Icons.paid_rounded, color: textSecondary,size: 34,)),
    TagItem(id: 2, name: 'Khác', icon: Icon(Icons.category_rounded, color: textSecondary,size: 34,)),
  ];


  static bool isValidEmail(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // static Future<void> storeUser(User user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear().then((_) async {
  //     await prefs.setString('this_username', user.name);
  //     await prefs.setString('this_email', user.email);
  //   });
  // }

  static String formatCurrency(int totalExpense){
    //NumberFormat format = NumberFormat.compactLong(locale: 'vi');
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

  static List<TransactionDetails> getDetails(List<dynamic> list){
    List<TransactionDetails> details = [];
    for(final item in list){
      final temp = TransactionDetails(name: item['name'],total: item['total'],tag: item['tag']);
      details.add(temp);
    }
    return details;
  }

  static Future<void> logout(UserProvider userProvider) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    userProvider.googleSignIn.signOut();
  }
  
  static String getTagName(int tagId, List<TagItem> list){
    for(TagItem item in list){
      if(tagId == item.id){
        return item.name;
      }
    }
    return '';
  }

  static Icon getTagIcon(int tagId, List<TagItem> list){
    for(TagItem item in list){
      if(tagId == item.id){
        return item.icon;
      }
    }
    return Icon(Icons.add);
  }



}