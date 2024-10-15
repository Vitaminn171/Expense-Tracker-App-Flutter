import 'package:expenseapp/viewmodels/utils.dart';
import 'package:expenseapp/views/components/add_button.dart';
import 'package:expenseapp/views/components/background_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/models/colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/setting_viewmodel.dart';
import 'package:toastification/toastification.dart';

import '../models/user.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
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

  Future<void> _performLoadingTask() async {
    showLoadingDialog(context);

    if ((await Utils.logout(context)) == false) {
      toastification.show(
        context: context,
        title: const Text('Đăng xuất thất bại! Vui lòng thử lại sau vài giây.'),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),
      );
      Navigator.pop(context);
    } else {
      toastification.show(
        context: context,
        title: const Text('Đăng xuất thành công!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
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
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(18),
                                                    child: snapshot.data?.photoUrl == null
                                                        ? (snapshot.data?.imgPath == 'user'
                                                            ? Image.asset(
                                                                'assets/images/user.png',
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit.cover,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/user.png',
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit.cover,
                                                              ))
                                                        : Image.network(
                                                            snapshot.data!.photoUrl.toString(),
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          )),
                                              ],
                                            ),
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
