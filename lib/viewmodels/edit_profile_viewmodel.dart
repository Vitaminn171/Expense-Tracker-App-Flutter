import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:expenseapp/views/edit_profile.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

import 'package:expenseapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apis.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {

  FocusNode? textFieldFocusNodeName;
  TextEditingController? textControllerName;
  String? Function(BuildContext, String?)? textControllerValidatorName;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNodeName?.dispose();
    textControllerName?.dispose();
  }
}

class EditProfileViewModel extends ChangeNotifier {
  final UserProvider userProvider;

  EditProfileViewModel(this.userProvider);

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

  Future<bool> saveProfileData(String name) async {
    _errorMessage = '';
    try{
      if(name != userProvider.user?.name && name.isNotEmpty){
        final querySnapshot = await Api.getUserData(userProvider.user!.email);
        DocumentSnapshot document = querySnapshot.docs.first;
        DocumentReference userRef = document.reference;
        Map<String, dynamic> updatedData = {
          'name': name,
          'changed': true,
        };
        await userRef.update(updatedData);
        User user;
        if(userProvider.user?.photoUrl == null){
          user = User(name: name, email: userProvider.user!.email, totalCash: userProvider.user!.totalCash, imgPath: userProvider.user!.imgPath);
        }else{
          user = User(name: name, email: userProvider.user!.email, totalCash: userProvider.user!.totalCash, photoUrl: userProvider.user!.photoUrl);
        }
        userProvider.setUser(user);
        userProvider.setChanged(true);
        await storeUser(user);
        return true;
      }else{
        _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
        return false;
      }
    }catch (e){
      _errorMessage = 'Hệ thống bị lỗi! Vui lòng thử lại sau vài giây.';
      return false;
    }
  }

  Future<void> storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('this_email', user.email);
    await prefs.setString('this_username', user.name);
    await prefs.setInt('this_totalCash', user.totalCash);
    if (user.photoUrl == null) {
      await prefs.setString('this_imgPath', user.imgPath.toString());
    } else {
      await prefs.setString('this_photoUrl', user.photoUrl.toString());
    }
  }
}
