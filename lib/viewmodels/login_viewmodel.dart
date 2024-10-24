import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/apis.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expenseapp/models/user.dart';
import 'package:expenseapp/views/login.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginViewModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController2Validator;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final UserProvider userProvider;
  LoginViewModel(this.userProvider);

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }

  Future<bool> checkLogin() async {
    _errorMessage = '';
    String email = textController1.text;
    String password = textController2.text;
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Không để trống thông tin đăng nhập!';
      return false;
    }

    if (!Utils.isValidEmail(email)) {
      _errorMessage = 'Sai định dạng email!';
      return false;
    }

    final querySnapshot = await Api.getUserData(email);
    if (querySnapshot.size == 0) {
      _errorMessage = 'Tài khoản chưa được đăng ký!';
      return false;
    }
    final doc = querySnapshot.docs.single;
    final data = doc.data();
    if (data['password'] != Utils.generateMd5(password)) {
      _errorMessage = 'Sai mật khẩu!';
      return false;
    }

    final queryWalletSnapshot = await Api.getWalletData(email);

    final dataWallet = queryWalletSnapshot.docs.single.data();
    User user;
    if (data['photoUrl'] == null) {
      user = User(name: data['name'], email: data['email'], totalCash: dataWallet['cash'], imgPath: data['imgPath'] ?? 'user', photoUrl: null);
    } else {
      user = User(name: data['name'], email: data['email'], totalCash: dataWallet['cash'], photoUrl: data['photoUrl'], imgPath: null);
    }

    userProvider.setUser(user);
    await storeUser(user);

    return true;
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

  Future<bool> checkEmailAvailable(String email) async {
    _errorMessage = '';
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final query = usersCollection.where('email', isEqualTo: email);
    final querySnapshot = await query.get();
    if (querySnapshot.size > 0) {
      _errorMessage = 'Tài khoản đã được đăng ký!';
      return false;
    }
    return true;
  }

  Future<void> loginGoogle(String email, String username, String photoUrl) async {
    _errorMessage = '';

    final querySnapshot = await Api.getUserData(email);
    if (querySnapshot.size == 0) {
      final userDoc = Api.usersCollection.doc(); // Generate a unique document ID

      final userData = {
        'email': email,
        'name': username,
        'photoUrl': photoUrl,
        'changed': false,
      };
      await userDoc.set(userData);

      final walletDoc = Api.walletsCollection.doc(); // Generate a unique document ID

      final walletData = {
        'email': email,
        'cash': 0,
      };
      await walletDoc.set(walletData);

      await storeUser(User(name: username, email: email, totalCash: 0, photoUrl: photoUrl));
    } else {
      DocumentSnapshot document = querySnapshot.docs.first;
      final queryWalletsnapshot = await Api.getWalletData(email);
      final dataWallet = queryWalletsnapshot.docs.single.data();

      final data = querySnapshot.docs.first.data();
      User user;
      if (data['changed'] != null && data['changed']!) {
        if(data['photoUrl'] == null){
          user = User(name: data['name'], email: email, totalCash: dataWallet['cash'], imgPath: data['imgPath']);
        }else{
          user = User(name: data['name'], email: email, totalCash: dataWallet['cash'], photoUrl: data['photoUrl']);
        }
      } else {
        DocumentReference userRef = document.reference;
        Map<String, dynamic> updatedData = {
          'name': username,
          'photoUrl': photoUrl,
          'changed': true,
        };
        await userRef.update(updatedData);
        user = User(name: username, email: email, totalCash: dataWallet['cash'], photoUrl: photoUrl);
      }

      userProvider.setChanged(false);
      await storeUser(user);
    }
  }

  Future<void> sendError(String text) async {
    final errDoc = Api.errorCollection.doc(); // Generate a unique document ID

    final errorData = {
      'text': text,
    };
    await errDoc.set(errorData);
  }
}
