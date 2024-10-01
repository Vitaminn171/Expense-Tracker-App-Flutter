import 'dart:math';
import 'dart:ui';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/custom_drawer.dart';
import 'package:expenseapp/views/components/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/expense_viewmodel.dart';

import '../models/transaction.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
import 'listview_components/expense_items.dart';
export 'package:expenseapp/viewmodels/expense_viewmodel.dart';

class ExpenseListWidget extends StatefulWidget {
  const ExpenseListWidget({super.key});

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  late ExpenseListModel _model;
  late ExpenseListViewModel _viewModel;
  String datePicked = '';
  late ExpenseProvider _expenseProvider;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late BottomNavigationBar _navbar;
  DateTime now = DateTime.now();

  DateTimeRange? _selectedDateRange;

  Future<List<Transactions>> _fetchData(DateTimeRange dateRange) async {
    return _viewModel.getExpDateRange(dateRange); // Replace with your actual API call
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExpenseListModel());
    //_navbar = createModel(context, (_) => CustomNavbar(indexCurrent: 1));
    _viewModel = Provider.of<ExpenseListViewModel>(context, listen: false);
    _selectedDateRange = _viewModel.getDateRange() ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month, now.day),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.getExpDateRange(_selectedDateRange!);
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> fetchData(DateTimeRange picked) async {
    // Perform asynchronous data fetching here
    await _viewModel.getExpDateRange(picked);

    // Update the state synchronously after fetching data
    setState(() {
      datePicked = '${Utils.formatDatePicker(picked.start)} - ${Utils.formatDatePicker(picked.end)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomPopscope(
          widget: Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: secondaryColor,
              onPressed: () {
                // Add your onPressed code here!
              },
              enableFeedback: true,
              child: Icon(
                Icons.add_rounded,
                color: backgroundColor,
                size: 28,
              ),

              //icon: Icon(Icons.add_rounded, color: backgroundColor,),
            ),
            backgroundColor: backgroundColor,
            bottomNavigationBar: CustomNavbar(
              indexCurrent: 2,
            ),
            endDrawer: CustomDrawer(
              index: 0,
            ),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.9),
                child: AppBar(
                    scrolledUnderElevation: 0,
                    backgroundColor: backgroundColor,
                    automaticallyImplyLeading: false,
                    actions: <Widget>[
                      new Container(),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(children: [
                      BackgroundWidget(
                        alignmentDirectional: AlignmentDirectional(0, -1),
                        imgHeight: 500,
                      ),
                      Consumer<ExpenseProvider>(builder: (context, myState, child) {
                        return FutureBuilder<List<Transactions>>(
                            future: myState.expensesList,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                final data = snapshot.data!;
                                return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(25, 60, 25, 0),
                                    child: UserWidget(scaffoldKey: scaffoldKey, title: 'Danh sách chi tiêu'), //'Danh sách chi tiêu'
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FutureBuilder<num>(
                                            future: myState.totalExpenseRange,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                      child: Text(
                                                        '\$${Utils.formatCurrency(snapshot.data?.toInt() ?? 0)}',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 27,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Center(
                                                    child: CircularProgressIndicator(
                                                  color: primaryColor,
                                                ));
                                              }
                                            }),
                                        SizedBox(
                                          height: 50,
                                          child: VerticalDivider(
                                            thickness: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    final DateTimeRange? picked = await showDateRangePicker(
                                                      context: context,
                                                      locale: Locale('vi'),
                                                      initialDateRange: _selectedDateRange,
                                                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                                                      lastDate: DateTime.now(),
                                                      builder: (context, child) {
                                                        return Theme(
                                                          data: Theme.of(context).copyWith(
                                                            colorScheme: ColorScheme.light(
                                                              primary: primaryColor, // header background color
                                                              secondary: alternateColor,
                                                              onPrimary: Colors.black, // header text color
                                                              onTertiary: primaryColor,
                                                              onSurface: textSecondary, // body text color
                                                            ),
                                                            textButtonTheme: TextButtonThemeData(
                                                              style: TextButton.styleFrom(
                                                                foregroundColor: primaryColor, // button text color
                                                              ),
                                                            ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                    );

                                                    if (picked != null) {
                                                      setState(() {
                                                        _selectedDateRange = picked;
                                                      });
                                                      _fetchData(picked);
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                                        child: Icon(
                                                          Icons.calendar_month_rounded,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${Utils.formatDatePicker(_selectedDateRange!.start)} - ${Utils.formatDatePicker(_selectedDateRange!.end)}',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            // Row(
                                            //   mainAxisSize: MainAxisSize.min,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            //     Text(
                                            //       'Tiền thấp - cao',
                                            //       style: TextStyle(
                                            //         fontFamily: 'Montserrat',
                                            //         fontSize: 17,
                                            //         letterSpacing: 0.0,
                                            //         color: backgroundColor,
                                            //         fontWeight: FontWeight.w400,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 45),
                                    child: Container(
                                      width: double.infinity,
                                      height: 480,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        boxShadow: [
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
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(28),
                                          bottomRight: Radius.circular(28),
                                          topLeft: Radius.circular(28),
                                          topRight: Radius.circular(28),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: ListView.builder(
                                            itemCount: data.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              Transactions items = data[index];
                                              return InkWell(
                                                onTap: () {
                                                  _viewModel.setExpenseDetail(items);
                                                  Navigator.popAndPushNamed(context, '/ExpenseDetail');
                                                },
                                                child: ExpenseItems(
                                                  date: items.date,
                                                  total: items.total,
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                  ),
                                ]);
                              } else {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: primaryColor,
                                ));
                              }
                            });
                      }),
                    ])))),
            // appBar: AppBar(
            //   backgroundColor: Color(0xFF69CAA7),
            //   iconTheme: IconThemeData(color: alternateColor),
            //   automaticallyImplyLeading: true,
            //   leading: Container(),
            //   title: Text(
            //     'Danh sách chi tiêu',
            //     textAlign: TextAlign.start,
            //   ),
            //   actions: [Container()],
            //   centerTitle: true,
            //   elevation: 0,
            // ),
            // body: SafeArea(
            //   top: true,
            //   child: Stack(
            //     alignment: AlignmentDirectional(0, -1),
            //     children: [
            //       Align(
            //         alignment: AlignmentDirectional(0, -1),
            //         child: Container(
            //           width: double.infinity,
            //           height: 400,
            //           decoration: BoxDecoration(
            //             color: Color(0xFF69CAA7),
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: AlignmentDirectional(0, 1),
            //         child: Padding(
            //           padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
            //           child: Material(
            //             color: Colors.transparent,
            //             elevation: 10,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(18),
            //             ),
            //             child: Container(
            //               width: double.infinity,
            //               height: 550,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.circular(18),
            //               ),
            //               child: Padding(
            //                 padding: EdgeInsets.all(20),
            //                 child: ListView(
            //                   padding: EdgeInsets.zero,
            //                   shrinkWrap: true,
            //                   scrollDirection: Axis.vertical,
            //                   children: [
            //                     Row(
            //                       mainAxisSize: MainAxisSize.max,
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Expanded(
            //                           flex: 4,
            //                           child: Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 0, 8, 12, 8),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.max,
            //                               children: [
            //                                 Column(
            //                                   mainAxisSize: MainAxisSize.min,
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   children: [
            //                                     Text(
            //                                       'Ngày 12/12/2024',
            //                                       style: TextStyle(
            //                                         fontFamily: 'Montserrat',
            //                                         fontSize: 17,
            //                                         letterSpacing: 0.0,
            //                                         color: backgroundColor,
            //                                         fontWeight: FontWeight.w400,
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         Text(
            //                           '\$123,123',
            //                           style: TextStyle(
            //                             fontFamily: 'Montserrat',
            //                             fontSize: 17,
            //                             letterSpacing: 0.0,
            //                             color: backgroundColor,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsetsDirectional.fromSTEB(
            //                               10, 0, 0, 0),
            //                           child: Icon(
            //                             Icons.arrow_forward_ios_rounded,
            //                             color: textSecondary,
            //                             size: 18,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ].divide(SizedBox(height: 10)),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: AlignmentDirectional(0, -1),
            //         child: Padding(
            //           padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 0),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Tổng chi tiêu',
            //                     style: TextStyle(
            //                       fontFamily: 'Montserrat',
            //                       fontSize: 17,
            //                       letterSpacing: 0.0,
            //                       color: backgroundColor,
            //                       fontWeight: FontWeight.w400,
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding:
            //                         EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            //                     child: Text(
            //                       '\$567,402',
            //                       style: TextStyle(
            //                         fontFamily: 'Montserrat',
            //                         fontSize: 27,
            //                         letterSpacing: 0.0,
            //                         color: backgroundColor,
            //                         fontWeight: FontWeight.w600,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 50,
            //                 child: VerticalDivider(
            //                   thickness: 1,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 crossAxisAlignment: CrossAxisAlignment.end,
            //                 children: [
            //                   Padding(
            //                     padding:
            //                         EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            //                     child: Row(
            //                       mainAxisSize: MainAxisSize.min,
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Padding(
            //                           padding: EdgeInsetsDirectional.fromSTEB(
            //                               0, 0, 5, 0),
            //                           child: Icon(
            //                             Icons.calendar_month_rounded,
            //                             color: Colors.white,
            //                             size: 20,
            //                           ),
            //                         ),
            //                         Text(
            //                           '01/9 - 31/9',
            //                           style: TextStyle(
            //                             fontFamily: 'Montserrat',
            //                             fontSize: 17,
            //                             letterSpacing: 0.0,
            //                             color: backgroundColor,
            //                             fontWeight: FontWeight.w400,
            //                           ),
            //                         ),
            //                         Icon(
            //                           Icons.arrow_drop_down,
            //                           color: Colors.white,
            //                           size: 20,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   Row(
            //                     mainAxisSize: MainAxisSize.min,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         'Tiền thấp - cao',
            //                         style: TextStyle(
            //                           fontFamily: 'Montserrat',
            //                           fontSize: 17,
            //                           letterSpacing: 0.0,
            //                           color: backgroundColor,
            //                           fontWeight: FontWeight.w400,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ));
  }
}
