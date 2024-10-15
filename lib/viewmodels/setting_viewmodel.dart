import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/setting.dart' show SettingWidget;
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'apis.dart';

class SettingModel extends FlutterFlowModel<SettingWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class SettingViewModel extends ChangeNotifier {
  final UserProvider userProvider;

  SettingViewModel(this.userProvider);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<int> getCash(String email) async {
    final queryWalletsnapshot = await Api.getWalletData(email);
    final dataWallet = queryWalletsnapshot.docs.single.data();
    return dataWallet['cash'];
  }

  Future<User> getStoredUser() async {
    return Future.value(userProvider.user!);
  }

  String getUserName() {
    return userProvider.user?.name ?? 'Loading...';
  }

  String getEmail() {
    return userProvider.user?.email ?? 'Loading...';
  }
}
