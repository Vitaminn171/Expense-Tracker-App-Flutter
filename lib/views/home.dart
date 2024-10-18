import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/add_button.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:expenseapp/views/revenue.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/home_viewmodel.dart';

import '../models/user.dart';
import 'components/custom_alert_dialog.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override void didChangeDependencies() {



    super.didChangeDependencies();
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
        child: CustomPopscope(
          action: (){

          },
          home: true,
            widget: Scaffold(
          key: scaffoldKey,
          endDrawer: CustomDrawer(
            scaffoldKey: scaffoldKey,
            index: 1,
          ),
          backgroundColor: backgroundColor,
          bottomNavigationBar: CustomNavbar(
            indexCurrent: 0,
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.91),
            child: AppBar(
              backgroundColor: backgroundColor,
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
                            alignment: const AlignmentDirectional(0, -1),
                            child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                                child: FutureBuilder<User>(
                                    future: _viewModel.getStoredUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ));
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            // Expanded(child: Padding(
                                            //     padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                            //     child: UserWidget(scaffoldKey: scaffoldKey)),),
                                            Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                                child: UserWidget(scaffoldKey: scaffoldKey)),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
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
                                                          style: const TextStyle(
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
                                              padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 25),
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
                                                          //Navigator.of(context, rootNavigator: true).popAndPushNamed('/ExpenseList');
                                                          Navigator.pushNamed(context, '/ExpenseList');
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: const Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.outbox_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Chi tiêu',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: (() {
                                                          Navigator.pushNamed(context, '/RevenueList');
                                                          // Navigator.push(
                                                          //   context,
                                                          //     PageRouteBuilder(
                                                          //       pageBuilder: (context, animation, secondaryAnimation) => const RevenueListWidget(),
                                                          //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                          //         const begin = Offset(0.0, 1.0);
                                                          //         const end = Offset.zero;
                                                          //         final tween = Tween(begin: begin, end: end);
                                                          //         final offsetAnimation = animation.drive(tween);
                                                          //         return SlideTransition(
                                                          //           position: offsetAnimation,
                                                          //           child: child,
                                                          //         );
                                                          //       },
                                                          //     )
                                                          // );
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: const Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.attach_money_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Thu nhập',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: (() {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) => const CustomAlertDialog(
                                                                title: 'Coming soon!',
                                                                info: 'Tính năng này sẽ được thêm vào trong các bản cập nhật tiếp theo.',
                                                              ));
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: const Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.savings_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Tiết kiệm',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(height: 5)),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: (() {
                                                          _showDialogAdd();
                                                        }),
                                                        child: Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: const Color(0x6EF4F4F4),
                                                          elevation: 10,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(23),
                                                          ),
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(12),
                                                            child: Icon(
                                                              Icons.add_rounded,
                                                              color: backgroundColor,
                                                              size: 45,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Thêm mới',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(1.0, 1.0),
                                                              blurRadius: 5.0,
                                                              color: textSecondary,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(height: 5)),
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
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
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
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
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
                                                  padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 0, 35),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                                            child: Icon(
                                                              Icons.trending_down,
                                                              color: textPrimary,
                                                              size: 32,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Chi tiêu tháng ${Utils.getMonth()}',
                                                            style: const TextStyle(
                                                              fontFamily: 'Nunito',
                                                              fontSize: 17,
                                                              letterSpacing: 0.0,
                                                              color: textSecondary,
                                                              // fontStyle: FontStyle.italic,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                            child: Text(
                                                              '\$${data['totalExpense']}',
                                                              style: const TextStyle(
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
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 35),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                                            child: Icon(
                                                              Icons.attach_money_rounded,
                                                              color: textPrimary,
                                                              size: 32,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Thu nhập tháng ${Utils.getMonth()}',
                                                            style: const TextStyle(
                                                              fontFamily: 'Nunito',
                                                              fontSize: 17,
                                                              letterSpacing: 0.0,
                                                              color: textSecondary,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                            child: Text(
                                                              '\$${data['totalRevenue']}',
                                                              style: const TextStyle(
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
                                              ].divide(const SizedBox(width: 10)),
                                            );
                                          } else {
                                            return const Center(
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
        )));
  }

  void _showDialogAdd() {
    showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 200),
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
                child: AddButton(title: 'Thêm thu nhập', route: '/AddRevenue'),
              ),
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              //   child: AddButton(title: 'Thêm mục tiết kiệm', route: '/AddExpense'),
              // ),
            ],
          ),
        );
      },
    );
  }
}
