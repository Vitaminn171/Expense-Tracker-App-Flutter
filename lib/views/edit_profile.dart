import 'package:expenseapp/views/components/background_widget.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:expenseapp/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/models/user.dart';
import 'package:toastification/toastification.dart';
import '../viewmodels/utils.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
import 'components/user_widget.dart';

import 'package:expenseapp/viewmodels/edit_profile_viewmodel.dart';
export 'package:expenseapp/viewmodels/edit_profile_viewmodel.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  late EditProfileViewModel _viewModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // late User user;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());
    _viewModel = Provider.of<EditProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _viewModel.getListTransactionsDetail();
      // setState(() {
      //   _selectedDate = _viewModel.selectedDate ?? DateTime(Utils.now.year, Utils.now.month, Utils.now.day);
      // });
      _model.textControllerName ??= TextEditingController();
      _model.textFieldFocusNodeName ??= FocusNode();
      _model.textControllerName.text = _viewModel.getUserName();
    });
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
            scaffoldKey: scaffoldKey,
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
                                        return const Center(
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
                                                child: UserWidget(scaffoldKey: scaffoldKey, title: 'Thông tin cá nhân')),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
                                              child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 50),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              print('edit photo');
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 75,
                                                                  backgroundColor: alternateColor,
                                                                  child: CircleAvatar(
                                                                    radius: 72,
                                                                    backgroundImage: NetworkImage(
                                                                      snapshot.data!.photoUrl.toString(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 1,
                                                                  right: 1,
                                                                  child: Container(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(3.5),
                                                                      child: Icon(Icons.add_a_photo_rounded, color: textPrimary),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          width: 3,
                                                                          color: backgroundColor,
                                                                        ),
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                            50,
                                                                          ),
                                                                        ),
                                                                        color: backgroundColor,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            offset: Offset(2, 4),
                                                                            color: Colors.black.withOpacity(
                                                                              0.3,
                                                                            ),
                                                                            blurRadius: 3,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textControllerName,
                                                          focusNode: _model.textFieldFocusNodeName,
                                                          // onTap: () {
                                                          //   moveWidgetWhenUseKeyBoard(true, size);
                                                          // },
                                                          onTapOutside: (_) {
                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                          },
                                                          autofocus: false,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            labelText: 'Tiêu đề',
                                                            labelStyle: const TextStyle(
                                                                fontFamily: 'Nunito', fontSize: 15, letterSpacing: 0.0, color: textSecondary),
                                                            hintStyle: const TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: textSecondary,
                                                              fontSize: 15,
                                                              letterSpacing: 0.0,
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                color: secondaryColor,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            filled: true,
                                                            fillColor: glassColor,
                                                            prefixIcon: const Icon(
                                                              Icons.text_snippet_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: const TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                          ),
                                                          cursorColor: textPrimary,
                                                          validator: _model.textControllerValidatorName.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          setState(() {
                                                            _performLoadingTask(_model.textControllerName.text.toString());
                                                          });
                                                        },
                                                        text: 'Lưu',
                                                        options: FFButtonOptions(
                                                          height: 40,
                                                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                          color: backgroundColor,
                                                          textStyle: const TextStyle(
                                                              fontFamily: 'Nunito', fontSize: 17, letterSpacing: 0.0, color: textPrimary),
                                                          elevation: 0,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),

                                            // SettingItems(text: 'Chỉnh sửa thông tin cá nhân', action: () {}, icon: Icons.manage_accounts_rounded,),
                                            // SettingItems(text: 'Đổi mật khẩu', action: () {}, icon: Icons.password_rounded,),
                                            // SettingItems(text: 'Chuyển đổi tài khoản Google', action: () {}, icon: Icons.manage_accounts_rounded,),
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

  Future<void> _performLoadingTask(String name) async {
    // Show the loading dialog
    Utils.showLoadingDialog(context);

    if ((await _viewModel.saveProfileData(name)) == false) {
      toastification.show(
        context: context,
        title: Text(_viewModel.errorMessage),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),
      );
      Navigator.pop(context);
    } else {
      toastification.show(
        context: context,
        title: const Text('Lưu thông tin thành công!'),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      //Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/Home', (Route<dynamic> route) => false,);
    }
  }
}
