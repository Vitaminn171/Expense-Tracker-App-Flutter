import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Api {
  static final expensesCollection = FirebaseFirestore.instance.collection('expenses');
  static final revenuesCollection = FirebaseFirestore.instance.collection('revenues');
  static final usersCollection = FirebaseFirestore.instance.collection('users');
  static final walletsCollection = FirebaseFirestore.instance.collection('wallets');
  static final errorCollection = FirebaseFirestore.instance.collection('error');

  static DateTime now = DateTime.now();

  static DateTimeRange thisMonth(){
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: startDate, end: endDate);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getExpenseThisMonth(String email) async {
   DateTimeRange month = thisMonth();
    final query = expensesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(month.start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(month.end.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getExpenseRange(String email, DateTimeRange range) async {
    final query = expensesCollection
        .where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(range.end.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRevenueThisMonth(String email) async {
    DateTimeRange month = thisMonth();
    final query = revenuesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(month.start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(month.end.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRevenueRange(String email, DateTimeRange range) async {
    final query = revenuesCollection
        .where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(range.end.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserData(String email) async {
    final query = usersCollection.where('email', isEqualTo: email);
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getWalletData(String email) async {
    final query = walletsCollection.where('email', isEqualTo: email);
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getExpenseDetails(String email, DateTime date) async {
    final query = expensesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(date.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRevenueDetails(String email, DateTime date) async {
    final query = revenuesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(date.add(const Duration(seconds: 10))));
    return await query.get();
  }

  static Future<void> deleteExpenseData(String email, DateTime date) async {
    final query = expensesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(date.add(const Duration(seconds: 10))));
    final querySnapshot = await query.get();
    querySnapshot.docs.single.reference.delete();
  }

  static Future<void> deleteRevenueData(String email, DateTime date) async {
    final query = revenuesCollection.where('email', isEqualTo: email)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(date.add(const Duration(seconds: 10))));
    final querySnapshot = await query.get();
    querySnapshot.docs.single.reference.delete();
  }
}