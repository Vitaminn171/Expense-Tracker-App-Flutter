
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:expenseapp/views/components/tag_items.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/custom_drawer.dart';
import 'package:expenseapp/views/components/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

import 'package:toastification/toastification.dart';

import '../models/transaction.dart';
import '../viewmodels/revenueDetail_viewmodel.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
import 'listview_components/transactionDetail_items.dart';
export 'package:expenseapp/viewmodels/expenseDetail_viewmodel.dart';

class RevenueDetailWidget extends StatefulWidget {
  const RevenueDetailWidget({super.key});

  @override
  State<RevenueDetailWidget> createState() => _RevenueDetailWidgetState();
}

class _RevenueDetailWidgetState extends State<RevenueDetailWidget> {
  late RevenueDetailModel _model;
  late RevenueDetailViewModel _viewModel;
  String datePicked = '01/9 - 31/9';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int touchedIndex = -1;
  List<int> listPercent = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RevenueDetailModel());
    _viewModel = Provider.of<RevenueDetailViewModel>(context, listen: false);

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
          route: '/RevenueList',
          widget: Scaffold(
            key: scaffoldKey,
            backgroundColor: backgroundColor,
            bottomNavigationBar: const CustomNavbar(
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
                                          route: '/RevenueList',
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
                                            Text(
                                              '\$${_viewModel.getTotal()}',
                                              style: const TextStyle(
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
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  primary: true,
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2, // Adjust the number of columns as needed
                                                    mainAxisSpacing: 10.0,
                                                    crossAxisSpacing: 10.0,
                                                    childAspectRatio: 2.25,
                                                  ),
                                                  itemCount: Utils.tagRevenue.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    TagItem item = Utils.tagRevenue[index];
                                                    return TagItemsWidget(tagId: item.id, percent: listPercent[index], type: 1,);
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
                                                      const Text(
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
                                                              Navigator.popAndPushNamed(context, '/AddRevenue');
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
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color: secondaryColor,
                                                        ),
                                                        options: FFButtonOptions(
                                                          height: 36,
                                                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          color: backgroundColor,
                                                          textStyle: const TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                            color: secondaryColor,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                          elevation: 0,
                                                          borderSide: const BorderSide(
                                                            color: secondaryColor,
                                                            width: 2,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8),
                                                          hoverColor: alternateColor,
                                                          hoverBorderSide: const BorderSide(
                                                            color: alternateColor,
                                                            width: 2,
                                                          ),
                                                          hoverTextColor: textPrimary,
                                                          hoverElevation: 3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
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
                                                            child: TransactionDetailItems(name: items.name, total: items.total, tag: items.tag, type: 1,),
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
}
