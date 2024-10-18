
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/custom_drawer.dart';
import 'package:expenseapp/views/components/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

import 'package:toastification/toastification.dart';

import '../models/transaction.dart';
import '../providers/revenues_provider.dart';
import '../viewmodels/revenue_viewmodel.dart';
import 'components/custom_alert_dialog.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
import 'listview_components/transaction_items.dart';
export 'package:expenseapp/viewmodels/expense_viewmodel.dart';

class RevenueListWidget extends StatefulWidget {
  const RevenueListWidget({super.key});

  @override
  State<RevenueListWidget> createState() => _RevenueListWidgetState();
}

class _RevenueListWidgetState extends State<RevenueListWidget> {
  late RevenueListModel _model;
  late RevenueListViewModel _viewModel;
  String datePicked = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();

  DateTimeRange? _selectedDateRange;

  Future<List<Transactions>> _fetchData(DateTimeRange dateRange) async {
    return _viewModel.getRevDateRange(dateRange); // Replace with your actual API call
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RevenueListModel());

    _viewModel = Provider.of<RevenueListViewModel>(context, listen: false);
    _selectedDateRange = _viewModel.getDateRange() ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month, now.day),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.getRevenueData(_selectedDateRange!);
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> fetchData(DateTimeRange picked) async {
    // Perform asynchronous data fetching here
    await _viewModel.getRevDateRange(picked);
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
            floatingActionButton: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: secondaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/AddRevenue');
                },
                enableFeedback: true,
                child: const Icon(
                  Icons.add_rounded,
                  color: backgroundColor,
                  size: 28,
                ),
              ),

              //icon: Icon(Icons.add_rounded, color: backgroundColor,),
            ),
            backgroundColor: backgroundColor,
            bottomNavigationBar: const CustomNavbar(
              indexCurrent: 2,
            ),
            endDrawer: CustomDrawer(
              scaffoldKey: scaffoldKey,
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
                        alignmentDirectional: const AlignmentDirectional(0, -1),
                        imgHeight: 500,
                      ),
                      Consumer<RevenueProvider>(builder: (context, myState, child) {
                        return FutureBuilder<List<Transactions>>(
                            future: myState.revenuesList,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                final data = snapshot.data!;
                                return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(25, 60, 25, 0),
                                    child: UserWidget(scaffoldKey: scaffoldKey, title: 'Danh sách thu nhập'), //'Danh sách chi tiêu'
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FutureBuilder<num>(
                                            future: myState.totalRevenueRange,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Tổng thu nhập',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        color: backgroundColor,
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                      child: Text(
                                                        '\$${Utils.formatCurrency(snapshot.data?.toInt() ?? 0)}',
                                                        style: const TextStyle(
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
                                                return const Center(
                                                    child: CircularProgressIndicator(
                                                  color: primaryColor,
                                                ));
                                              }
                                            }),
                                        const SizedBox(
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
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    final DateTimeRange? picked = await showDateRangePicker(
                                                      context: context,
                                                      locale: const Locale('vi'),
                                                      initialDateRange: _selectedDateRange,
                                                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                                      lastDate: DateTime.now(),
                                                      builder: (context, child) {
                                                        return Theme(
                                                          data: Theme.of(context).copyWith(
                                                            colorScheme: const ColorScheme.light(
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
                                                      const Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                                        child: Icon(
                                                          Icons.calendar_month_rounded,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${Utils.formatDatePicker(_selectedDateRange!.start)} - ${Utils.formatDatePicker(_selectedDateRange!.end)}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17,
                                                          letterSpacing: 0.0,
                                                          color: backgroundColor,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 45),
                                    child: Container(
                                      width: double.infinity,
                                      height: 480,
                                      decoration: const BoxDecoration(
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
                                          padding: const EdgeInsets.all(20),
                                          child: ListView.builder(
                                            itemCount: data.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              Transactions items = data[index];
                                              return InkWell(
                                                onTap: () {
                                                  _viewModel.setRevenueDetail(items);
                                                  Navigator.pushNamed(context, '/RevenueDetail');
                                                },
                                                onLongPress: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => CustomAlertDialog(
                                                          title: 'Xóa thông tin ngày ${Utils.formatDate(items.date)}?',
                                                          info:
                                                          'Bạn có chắc chắn muốn xóa tất cả các thông tin chi tiêu cho ngày này? Hành động này không thể hoàn tác.',
                                                          actionButtonName: 'Xóa',
                                                          action: () async {
                                                            //Utils.showLoadingDialog(context);
                                                            // delete();
                                                            await _viewModel.deleteData(index);
                                                            if (_viewModel.errorMessage.isEmpty) {
                                                              toastification.show(
                                                                context: context,
                                                                title: const Text('Xóa thông tin thành công!'),
                                                                type: ToastificationType.success,
                                                                style: ToastificationStyle.flatColored,
                                                                autoCloseDuration: const Duration(seconds: 3),
                                                              );
                                                            } else {
                                                              toastification.show(
                                                                context: context,
                                                                title: Text(_viewModel.errorMessage),
                                                                type: ToastificationType.error,
                                                                style: ToastificationStyle.flatColored,
                                                                autoCloseDuration: const Duration(seconds: 3),
                                                              );
                                                            }
                                                            Navigator.pop(context);
                                                          }));
                                                },
                                                child: TransactionItems(
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
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: primaryColor,
                                ));
                              }
                            });
                      }),
                    ])))),
          ),
        ));
  }
}
