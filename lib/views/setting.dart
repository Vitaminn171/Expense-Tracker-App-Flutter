import 'package:expenseapp/views/components/background_widget.dart';
import 'package:expenseapp/views/listview_components/setting_items.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/models/colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/setting_viewmodel.dart';

import '../models/user.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
import 'components/user_widget.dart';
export 'package:expenseapp/viewmodels/setting_viewmodel.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late SettingModel _model;

  late SettingViewModel _viewModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // late User user;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingModel());
    _viewModel = Provider.of<SettingViewModel>(context, listen: false);
  }

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
            widget: Scaffold(
          key: scaffoldKey,
          endDrawer: CustomDrawer(
            index: 2,
          ),
          backgroundColor: backgroundColor,
          // bottomNavigationBar: CustomNavbar(
          //   indexCurrent: 0,
          // ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 1),
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
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ));
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                                child: UserWidget(scaffoldKey: scaffoldKey, title: 'Cài đặt')),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(25, 50, 25, 0),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(58),
                                                      child: snapshot.data?.photoUrl == null
                                                          ? (snapshot.data?.imgPath == 'user'
                                                              ? Image.asset(
                                                                  'assets/images/user.png',
                                                                  width: 150,
                                                                  height: 150,
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/user.png',
                                                                  width: 150,
                                                                  height: 150,
                                                                  fit: BoxFit.cover,
                                                                ))
                                                          : Image.network(
                                                              snapshot.data!.photoUrl.toString(),
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                            )),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 30),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot.data!.name,
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: backgroundColor),
                                                  ),
                                                  Text(
                                                    snapshot.data!.email,
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w400,
                                                        color: backgroundColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                           SettingItems(text: 'Chỉnh sửa thông tin cá nhân', action: () {}, icon: Icons.manage_accounts_rounded,),
                                            SettingItems(text: 'Đổi mật khẩu', action: () {}, icon: Icons.password_rounded,),
                                            SettingItems(text: 'Chuyển đổi tài khoản Google', action: () {}, icon: Icons.manage_accounts_rounded,),
                                          ],
                                        );
                                      }
                                    })),
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
}
