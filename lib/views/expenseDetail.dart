import 'dart:math';
import 'dart:ui';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:expenseapp/views/components/tag_items.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/custom_drawer.dart';
import 'package:expenseapp/views/components/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/expenseDetail_viewmodel.dart';
import 'package:toastification/toastification.dart';

import '../models/transaction.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
import 'listview_components/transactionDetail_items.dart';
import 'listview_components/transaction_items.dart';
export 'package:expenseapp/viewmodels/expenseDetail_viewmodel.dart';

class ExpenseDetailWidget extends StatefulWidget {
  const ExpenseDetailWidget({super.key});

  @override
  State<ExpenseDetailWidget> createState() => _ExpenseDetailWidgetState();
}

class _ExpenseDetailWidgetState extends State<ExpenseDetailWidget> {
  late ExpenseDetailModel _model;
  late ExpenseDetailViewModel _viewModel;
  String datePicked = '01/9 - 31/9';
  late ExpenseProvider _expenseProvider;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late BottomNavigationBar _navbar;
  int touchedIndex = -1;
  List<int> listPercent = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExpenseDetailModel());
    //_navbar = createModel(context, (_) => CustomNavbar(indexCurrent: 1));
    _viewModel = Provider.of<ExpenseDetailViewModel>(context, listen: false);

    listPercent = _viewModel.calByTagItemPercent();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context).height;
    var heightContainer = size * 0.43359375;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomPopscope(
          route: '/ExpenseList',
          widget: Scaffold(
            key: scaffoldKey,
            backgroundColor: backgroundColor,
            bottomNavigationBar: CustomNavbar(
              indexCurrent: 1,
            ),
            endDrawer: CustomDrawer(),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.9),
                child: AppBar(
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: backgroundColor,
                    automaticallyImplyLeading: false,
                    actions: <Widget>[
                      new Container(),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(children: [
                      BackgroundWidget(
                        alignmentDirectional: const AlignmentDirectional(0, -1),
                        imgHeight: 500,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 45),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child:

                        Column(mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25, 60, 25, 0),
                            child: UserWidget(
                              scaffoldKey: scaffoldKey,
                              title: 'Ngày ${_viewModel.getDate()}',
                              route: '/ExpenseList',
                            ), //'Danh sách chi tiêu'
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                            child:
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng chi tiêu',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        letterSpacing: 0.0,
                                        color: backgroundColor,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '\$${_viewModel.getTotal()}',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 37,
                                        letterSpacing: 0.0,
                                        color: backgroundColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),


                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    primary: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Adjust the number of columns as needed
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 2.25,
                                    ),
                                    itemCount: Utils.tagExpense.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      TagItem item = Utils.tagExpense[index];
                                      return TagItemsWidget(tagId: item.id, percent: listPercent[index], type: 0,);
                                    },
                                  ),
                                )

                              ],
                            )),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                            child: Container(
                              width: double.infinity,
                              height: heightContainer,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0,
                                      0,
                                    ),
                                    spreadRadius: 5,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Generated code for this Row Widget...
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Danh sách chi tiêu',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 17,
                                              letterSpacing: 0.0,
                                              color: textPrimary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              if(_viewModel.setEditData()){
                                                Future.delayed(const Duration(milliseconds: 250)).then((_) {
                                                  Navigator.popAndPushNamed(context, '/AddExpense');
                                                });
                                              }else{
                                                toastification.show(
                                                  context: context,
                                                  title: const Text('Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.'),
                                                  type: ToastificationType.error,
                                                  style: ToastificationStyle.flatColored,
                                                  autoCloseDuration: const Duration(seconds: 3),
                                                );
                                              }
                                            },
                                            text: 'Sửa',
                                            icon: Icon(
                                              Icons.edit,
                                              size: 15,
                                              color: secondaryColor,
                                            ),
                                            options: FFButtonOptions(
                                              height: 36,
                                              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                              color: backgroundColor,
                                              textStyle: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              elevation: 0,
                                              borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                              hoverColor: alternateColor,
                                              hoverBorderSide: BorderSide(
                                                color: alternateColor,
                                                width: 2,
                                              ),
                                              hoverTextColor: textPrimary,
                                              hoverElevation: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: alternateColor,
                                      ),
                                      SizedBox(
                                        height: heightContainer - 100,
                                        child: ListView.builder(
                                            itemCount: _viewModel.getExpenseDetail()?.length,
                                            shrinkWrap: true,
                                            primary: false,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              TransactionDetails items = _viewModel.getExpenseDetail()!.elementAt(index);
                                              return InkWell(
                                                onTap: () {},
                                                child: TransactionDetailItems(name: items.name, total: items.total, tag: items.tag, type: 0,),
                                              );
                                            }),
                                      ),
                                      //
                                    ],
                                  )),
                            ),
                          ),
                        ]),
                      )
                      )])))),
          ),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      //const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: backgroundColor,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: backgroundColor,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: backgroundColor,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: backgroundColor,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
