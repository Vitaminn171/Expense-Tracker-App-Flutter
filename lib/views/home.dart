import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/add_button.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/models/colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/home_viewmodel.dart';
import 'package:toastification/toastification.dart';

import '../models/user.dart';
import 'components/navbar.dart';
import 'components/user_widget.dart';
export 'package:expenseapp/viewmodels/home_viewmodel.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  late HomeViewModel _viewModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // late User user;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await getStoredUser();
    //   final userProvider = Provider.of<UserProvider>(context, listen: false); // Access context after frame builds
    //   _model = createModel(context, () => HomeViewModel(userProvider));
    // });
  }

  // @override
  // Future<void> didChangeDependencies() async {
  //   _model = createModel(context, () => HomeViewModel(context.watch<UserProvider>()));
  //   super.didChangeDependencies();
  // }
  Future<void> showLoadingDialog(BuildContext context) async {
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

  Future<void> _performLoadingTask() async {
    showLoadingDialog(context);

    if ((await Utils.logout(_viewModel.userProvider, _viewModel.expenseProvider, _viewModel.revenueProvider)) == false) {
      toastification.show(
        context: context,
        title: Text('Dang xuat that bai'),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 4),
      );
      Navigator.pop(context);
    } else {
      toastification.show(
        context: context,
        title: Text('Đăng xuat thành công!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.popAndPushNamed(context, '/Login');
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _viewModel,
        child: Scaffold(
          key: scaffoldKey,
          endDrawer: _buildEndDrawer(),
          backgroundColor: backgroundColor,
          bottomNavigationBar: CustomNavbar(
            indexCurrent: 0,
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.91),
            child: AppBar(
              backgroundColor: Color(0xFF69CAA7),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                new Container(),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    BackgroundWidget(),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0, -1),
                            child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                                child: FutureBuilder<User>(
                                    future: _viewModel.getStoredUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ));
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0), child: UserWidget(scaffoldKey: scaffoldKey)),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Tiền mặt',
                                                          style: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                            color: backgroundColor,
                                                            fontWeight: FontWeight.w300,
                                                            shadows: <Shadow>[
                                                              Shadow(
                                                                offset: const Offset(1.0, 1.0),
                                                                blurRadius: 5.0,
                                                                color: textSecondary,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          '\$${Utils.formatCurrency(snapshot.data!.totalCash)}',
                                                          style: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 40,
                                                            letterSpacing: 0.0,
                                                            color: backgroundColor,
                                                            fontWeight: FontWeight.w400,
                                                            shadows: <Shadow>[
                                                              Shadow(
                                                                offset: const Offset(1.0, 1.0),
                                                                blurRadius: 5.0,
                                                                color: textSecondary,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 25),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: (() {
                                                          Navigator.popAndPushNamed(context, '/ExpenseList');
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.outbox_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Chi tiêu',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: const Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Card(
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        color: Color(0x6EF4F4F4),
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(23),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12),
                                                          child: Icon(
                                                            Icons.attach_money_rounded,
                                                            color: backgroundColor,
                                                            size: 45,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Thu nhập',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: const Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Card(
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        color: Color(0x6EF4F4F4),
                                                        elevation: 10,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(23),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12),
                                                          child: Icon(
                                                            Icons.savings_rounded,
                                                            color: backgroundColor,
                                                            size: 45,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Tiết kiệm',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: const Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: (() {
                                                          _showDialogAdd();
                                                          // showDialog<void>(
                                                          //     context: context,
                                                          //     barrierDismissible:
                                                          //         true, // Prevent dismissing by tapping outside
                                                          //     builder: (BuildContext
                                                          //             context) =>
                                                          //         Center(
                                                          //             child:
                                                          //                 Padding(
                                                          //           padding: EdgeInsetsDirectional
                                                          //               .fromSTEB(
                                                          //                   60,
                                                          //                   0,
                                                          //               60,
                                                          //                   0),
                                                          //           child: Card(
                                                          //             elevation:
                                                          //                 30,
                                                          //             color:
                                                          //                 backgroundColor,
                                                          //             shape:
                                                          //                 RoundedRectangleBorder(
                                                          //               borderRadius:
                                                          //                   BorderRadius.circular(18),
                                                          //             ),
                                                          //             child:
                                                          //                 Padding(
                                                          //               padding:
                                                          //                   EdgeInsetsDirectional.all(25),
                                                          //               child:
                                                          //                   Column(
                                                          //                 mainAxisSize:
                                                          //                     MainAxisSize.min,
                                                          //                 mainAxisAlignment:
                                                          //                     MainAxisAlignment.center,
                                                          //                 crossAxisAlignment:
                                                          //                     CrossAxisAlignment.stretch,
                                                          //                 children: [
                                                          //                   Padding(
                                                          //                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          //                     child: FFButtonWidget(
                                                          //                       onPressed: () async {
                                                          //                         Navigator.popAndPushNamed(context, '/AddExpense');
                                                          //                       },
                                                          //                       text: 'Thêm chi tiêu',
                                                          //                       options: FFButtonOptions(
                                                          //                         height: 40,
                                                          //                         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                          //                         iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          //                         color: backgroundColor,
                                                          //                         textStyle: TextStyle(
                                                          //                           fontFamily: 'Nunito',
                                                          //                           color: textPrimary,
                                                          //                           fontSize: 17,
                                                          //                           letterSpacing: 0.0,
                                                          //                         ),
                                                          //                         elevation: 0,
                                                          //                         borderSide: BorderSide(
                                                          //                           color: alternateColor,
                                                          //                         ),
                                                          //                         borderRadius: BorderRadius.circular(28),
                                                          //                       ),
                                                          //                     ),
                                                          //                   ),
                                                          //                   Padding(
                                                          //                     padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                          //                     child: FFButtonWidget(
                                                          //                       onPressed: () async {},
                                                          //                       text: 'Thêm thu nhập',
                                                          //                       options: FFButtonOptions(
                                                          //                         height: 40,
                                                          //                         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                          //                         iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          //                         color: backgroundColor,
                                                          //                         textStyle: TextStyle(
                                                          //                           fontFamily: 'Nunito',
                                                          //                           color: textPrimary,
                                                          //                           fontSize: 17,
                                                          //                           letterSpacing: 0.0,
                                                          //                         ),
                                                          //                         elevation: 0,
                                                          //                         borderSide: BorderSide(
                                                          //                           color: alternateColor,
                                                          //                         ),
                                                          //                         borderRadius: BorderRadius.circular(28),
                                                          //                       ),
                                                          //                     ),
                                                          //                   )
                                                          //                 ],
                                                          //               ),
                                                          //             ),
                                                          //           ),
                                                          //         )));
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.add_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Thêm mới',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: const Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(SizedBox(height: 5)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    })),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0,
                                  -5,
                                ),
                                spreadRadius: 5,
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                                  child: Text(
                                    'Tổng quan',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 23,
                                      letterSpacing: 0.0,
                                      color: textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: FutureBuilder<Map<String, dynamic>>(
                                        future: _viewModel.getExpensesRevenueData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            final data = snapshot.data!;
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(25, 15, 0, 35),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                                            child: Icon(
                                                              Icons.trending_down,
                                                              color: textPrimary,
                                                              size: 32,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Chi tiêu tháng ${Utils.getMonth()}',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              fontSize: 17,
                                                              letterSpacing: 0.0,
                                                              color: textSecondary,
                                                              // fontStyle: FontStyle.italic,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                            child: Text(
                                                              '\$${data['totalExpense']}',
                                                              style: TextStyle(
                                                                fontFamily: 'Nunito',
                                                                fontSize: 25,
                                                                letterSpacing: 0.0,
                                                                color: textPrimary,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 35),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                                            child: Icon(
                                                              Icons.attach_money_rounded,
                                                              color: textPrimary,
                                                              size: 32,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Thu nhập tháng ${Utils.getMonth()}',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              fontSize: 17,
                                                              letterSpacing: 0.0,
                                                              color: textSecondary,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                            child: Text(
                                                              '\$${data['totalRevenue']}',
                                                              style: TextStyle(
                                                                fontFamily: 'Nunito',
                                                                fontSize: 25,
                                                                letterSpacing: 0.0,
                                                                color: textPrimary,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 25, 35),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                                            child: Icon(
                                                              Icons.attach_money_rounded,
                                                              color: textPrimary,
                                                              size: 32,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Thu nhập tháng 9',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              fontSize: 17,
                                                              letterSpacing: 0.0,
                                                              color: textSecondary,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                            child: Text(
                                                              '\$567,402',
                                                              style: TextStyle(
                                                                fontFamily: 'Nunito',
                                                                fontSize: 25,
                                                                letterSpacing: 0.0,
                                                                color: textPrimary,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 10)),
                                            );
                                          } else {
                                            return Center(
                                                child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ));
                                          }
                                        }))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ));
  }

  Drawer _buildEndDrawer() {
    return Drawer(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 75, 0, 0),
                child: FFButtonWidget(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _performLoadingTask();
                    //Navigator.popAndPushNamed(context, '/Login');
                  },
                  text: 'Logout',
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFF69CAA7),
                    textStyle: TextStyle(fontFamily: 'Nunito', fontSize: 17, letterSpacing: 0.0, color: Colors.white),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _showDialogAdd() {
    showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 300),
      barrierColor: Colors.black.withOpacity(0.7),
      backgroundColor: backgroundColor,
      showDragHandle: true,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: AddButton(title: 'Thêm chi tiêu', route: '/AddExpense'),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: AddButton(title: 'Thêm thu nhap', route: '/AddExpense'),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: AddButton(title: 'Thêm tiet kiem', route: '/AddExpense'),
              ),
            ],
          ),
        );
      },
    );
  }
}
