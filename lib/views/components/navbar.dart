import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import 'package:expenseapp/models/colors.dart';

class CustomNavbar extends StatefulWidget  {
  final int indexCurrent;
  final bool? flag;
  final Function? action;

  const CustomNavbar({super.key,
    required this.indexCurrent,this.flag, this.action,
  });

  @override
  State<CustomNavbar> createState() => _CustomNavbarState(indexCurrent: indexCurrent, flag: flag, action: action);
}

class _CustomNavbarState extends State<CustomNavbar>{
  final int indexCurrent;
  final bool? flag;
  final Function? action;

  _CustomNavbarState({
    required this.indexCurrent,
    this.flag,
    this.action,
  });

  TextStyle textStyle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    letterSpacing: 0.0,
    color: textPrimary,
    fontWeight: FontWeight.w400,
  );



  @override
  Widget build(BuildContext context) {
    return
      CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: primaryColor,
        color: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        index: indexCurrent,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_rounded, color: textPrimary),
            label: 'Home',
            labelStyle: textStyle,
          ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.savings_rounded, color: textPrimary),
          //   label: 'Tiết kiệm',
          //   labelStyle: textStyle,
          // ),
          CurvedNavigationBarItem(
            child: Icon(Icons.outbox_rounded, color: textPrimary),
            label: 'Chi tiêu',
            labelStyle: textStyle,
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.attach_money_rounded, color: textPrimary),
            label: 'Thu nhập',
            labelStyle: textStyle,
          ),
        ],
        onTap: (index) async {
          if(flag == null){
            switchCase(index);
          }else{
            index = indexCurrent;
          }

        },
      );
  }

  Future<void> switchCase(int index) async {
    switch (index) {
      case 0:
        if(indexCurrent != index){
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.popAndPushNamed(context, '/Home');
        }
        break;
      case 1:

        if(indexCurrent != index){
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.popAndPushNamed(context, '/ExpenseList');
        }
        break;
      case 2:

        if(indexCurrent != index){
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.popAndPushNamed(context, '/RevenueList');
        }
        break;
    // ... more cases

    }
  }
}

