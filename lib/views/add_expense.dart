import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/add_expense_viewmodel.dart';
import 'package:toastification/toastification.dart';

import '../models/colors.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../viewmodels/utils.dart';
import 'components/background_widget.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
import 'components/navbar.dart';
import 'components/user_widget.dart';
import 'listview_components/addExpenseDetail_items.dart';
import 'listview_components/expense_items.dart';
export 'package:expenseapp/viewmodels/add_expense_viewmodel.dart';

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({super.key});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  late AddExpenseModel _model;
  late AddExpenseViewModel _viewModel;
  double _heightContainer = 380;
  DateTime _selectedDate = DateTime(Utils.now.year, Utils.now.month, Utils.now.day);

  TagItem _tagItemSelected = Utils.tagExpense.first;
  bool isAdded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddExpenseModel());

    _model.textController_date ??= TextEditingController();
    _model.textFieldFocusNode_date ??= FocusNode();
    _model.textController_date.text = Utils.formatDate(_selectedDate);

    _model.textController_title ??= TextEditingController();
    _model.textFieldFocusNode_title ??= FocusNode();

    _model.textController_total ??= TextEditingController();
    _model.textFieldFocusNode_total ??= FocusNode();

    _model.textController_tag ??= TextEditingController();
    _model.textFieldFocusNode_tag ??= FocusNode();

    _viewModel = Provider.of<AddExpenseViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.getListTransactionsDetail();
    });
  }

  @override
  void dispose() {
    _viewModel.expenseProvider.setListTransactionsDetail([]);
    _model.dispose();

    super.dispose();
  }

  void moveWidgetWhenUseKeyBoard(bool flag) {
    setState(() {
      if (flag) {
        _heightContainer = 600;
      } else {
        _heightContainer = 380;
      }
    });
  }

  void _onDropDownItemSelected(TagItem newSelected) {
    setState(() {
      _tagItemSelected = newSelected;
    });
  }

  void _clearDataTextField() {
    _model.textController_title.text = '';
    _model.textController_total.text = '';
    _tagItemSelected = Utils.tagExpense.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomPopscope(
            widget: Scaffold(
                key: scaffoldKey,
                backgroundColor: backgroundColor,
                bottomNavigationBar: CustomNavbar(
                  indexCurrent: 2,
                ),
                endDrawer: CustomDrawer(
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
                        background: SingleChildScrollView(
                            primary: true,
                            child: Container(
                                height: MediaQuery.of(context).size.height * 0.935,
                                child: Stack(children: [
                                  BackgroundWidget(
                                    alignmentDirectional: AlignmentDirectional(0, -1),
                                    imgHeight: 500,
                                  ),
                                  Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(25, 60, 25, 0),
                                      child: UserWidget(scaffoldKey: scaffoldKey, title: 'Thêm chi tiêu'), //'Danh sách chi tiêu'
                                    ),
                                    Expanded(
                                        child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Stack(children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, -1),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 2 + 50,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                // Generated code for this Row Widget...
                                                Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 10),
                                                    child: Card(
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18),
                                                      ),
                                                      color: glassColor,
                                                      child: Padding(
                                                        padding: const EdgeInsetsDirectional.all(10),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Danh sách đã thêm',
                                                              style: TextStyle(
                                                                fontFamily: 'Nunito',
                                                                color: textSecondary,
                                                                fontSize: 17,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            FFButtonWidget(
                                                              onPressed: () {
                                                                print('Button pressed ...');
                                                              },
                                                              text: 'Lưu',
                                                              icon: Icon(
                                                                Icons.save_alt_rounded,
                                                                color: textSecondary,
                                                                size: 15,
                                                              ),
                                                              options: FFButtonOptions(
                                                                height: 36,
                                                                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                color: backgroundColor,
                                                                textStyle: TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  color: textSecondary,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                                elevation: 0,
                                                                borderSide: BorderSide(
                                                                  color: alternateColor,
                                                                  width: 2,
                                                                ),
                                                                borderRadius: BorderRadius.circular(10),
                                                                hoverColor: alternateColor,
                                                                hoverBorderSide: BorderSide(
                                                                  color: alternateColor,
                                                                  width: 2,
                                                                ),
                                                                hoverTextColor: textPrimary,
                                                                hoverElevation: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 10),
                                                  child: Consumer<ExpenseProvider>(builder: (context, myState, child) {
                                                    //final data = myState.listTransactions!;
                                                    return FutureBuilder<List<TransactionDetails>>(
                                                        future: myState.listDetails,
                                                        builder: (context, snapshot) {
                                                          if (snapshot.data != null) {
                                                            final data = snapshot.data!;
                                                            return Container(
                                                              height: 220,
                                                              child: ListView.builder(
                                                                // itemCount: data.length,
                                                                itemCount: data.length,
                                                                padding: EdgeInsets.zero,
                                                                itemBuilder: (context, index) {
                                                                  TransactionDetails items = data[index];
                                                                  return Card(
                                                                      elevation: 0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(18),
                                                                      ),
                                                                      color: glassColor,
                                                                      child: Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                                          child: AddExpenseDetailItems(
                                                                            name: items.name,
                                                                            total: items.total,
                                                                            tag: items.tag,
                                                                            index: index,
                                                                          )));
                                                                },
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(
                                                                child: CircularProgressIndicator(
                                                              color: primaryColor,
                                                            ));
                                                          }
                                                        });
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 1),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: _heightContainer,
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
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(0),
                                                  bottomRight: Radius.circular(0),
                                                  topLeft: Radius.circular(28),
                                                  topRight: Radius.circular(28),
                                                ),
                                              ),
                                              child: // Generated code for this Column Widget...
                                                  Padding(
                                                padding: EdgeInsets.all(25),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(
                                                      'Thêm chi tiêu',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: textPrimary,
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: Container(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_date,
                                                          focusNode: _model.textFieldFocusNode_date,
                                                          autofocus: false,
                                                          readOnly: true,
                                                          obscureText: false,

                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false);
                                                          },
                                                          onTap: () async {
                                                            if(!isAdded){
                                                              final DateTime? picked = await showDatePicker(
                                                                context: context,
                                                                locale: Locale('vi'),
                                                                initialDate: _selectedDate,
                                                                firstDate: DateTime.now().subtract(Duration(days: 365)),
                                                                lastDate: DateTime.now(),
                                                                builder: (context, child) {
                                                                  return Theme(
                                                                    data: Theme.of(context).copyWith(
                                                                      colorScheme: ColorScheme.light(
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
                                                                  _viewModel.getDetailsData(picked);
                                                                  _selectedDate = picked;
                                                                  _model.textController_date.text = Utils.formatDate(_selectedDate);
                                                                });
                                                                // _fetchData(picked);
                                                              }
                                                            }
                                                            moveWidgetWhenUseKeyBoard(false);
                                                          },
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            filled: true,
                                                            fillColor: isAdded == true ? alternateColor : Color(0xFFFEFEFE),
                                                            labelText: 'Ngày',
                                                            labelStyle: TextStyle(
                                                                fontFamily: 'Nunito', fontSize: 15, letterSpacing: 0.0, color: textSecondary),
                                                            hintStyle: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: textSecondary,
                                                              fontSize: 15,
                                                              letterSpacing: 0.0,
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: secondaryColor,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),

                                                            prefixIcon: Icon(
                                                              Icons.calendar_today_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                          ),
                                                          cursorColor: textPrimary,
                                                          validator: _model.textControllerValidator_date.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: Container(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_title,
                                                          focusNode: _model.textFieldFocusNode_title,
                                                          onTap: () {
                                                            moveWidgetWhenUseKeyBoard(true);
                                                          },
                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false);
                                                          },
                                                          autofocus: false,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            labelText: 'Tiêu đề',
                                                            labelStyle: TextStyle(
                                                                fontFamily: 'Nunito', fontSize: 15, letterSpacing: 0.0, color: textSecondary),
                                                            hintStyle: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: textSecondary,
                                                              fontSize: 15,
                                                              letterSpacing: 0.0,
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: secondaryColor,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            filled: true,
                                                            fillColor: Color(0xFFFEFEFE),
                                                            prefixIcon: Icon(
                                                              Icons.text_snippet_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                          ),
                                                          cursorColor: textPrimary,
                                                          validator: _model.textControllerValidator_title.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: Container(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_total,
                                                          focusNode: _model.textFieldFocusNode_total,
                                                          onTap: () {
                                                            moveWidgetWhenUseKeyBoard(true);
                                                          },
                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false);
                                                          },
                                                          autofocus: false,
                                                          obscureText: false,
                                                          inputFormatters: <TextInputFormatter>[
                                                            CurrencyTextInputFormatter.currency(enableNegative: false, decimalDigits: 0, symbol: ''),
                                                          ],
                                                          keyboardType: TextInputType.number,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            labelText: 'Số tiền',
                                                            labelStyle: TextStyle(
                                                                fontFamily: 'Nunito', fontSize: 15, letterSpacing: 0.0, color: textSecondary),
                                                            hintStyle: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: textSecondary,
                                                              fontSize: 15,
                                                              letterSpacing: 0.0,
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: secondaryColor,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: error,
                                                                width: 1,
                                                              ),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            filled: true,
                                                            fillColor: Color(0xFFFEFEFE),
                                                            prefixIcon: Icon(
                                                              Icons.attach_money_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                            letterSpacing: 0.0,
                                                          ),
                                                          cursorColor: textPrimary,
                                                          validator: _model.textControllerValidator_total.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: Container(
                                                        width: 200,
                                                        child: FormField<TagItem>(
                                                          builder: (FormFieldState<TagItem> state) {
                                                            return InputDecorator(
                                                              decoration: InputDecoration(
                                                                isDense: true,
                                                                labelText: 'Loại',
                                                                labelStyle: TextStyle(
                                                                    fontFamily: 'Nunito', fontSize: 15, letterSpacing: 0.0, color: textSecondary),
                                                                hintStyle: TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  color: textSecondary,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Color(0x00000000),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: secondaryColor,
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                errorBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: error,
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                focusedErrorBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: error,
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(0xFFFEFEFE),
                                                                prefixIcon: Icon(
                                                                  Icons.category_rounded,
                                                                  color: secondaryColor,
                                                                ),
                                                              ),
                                                              child: DropdownButtonHideUnderline(
                                                                child: DropdownButton<TagItem>(
                                                                  dropdownColor: const Color(0xFFFEFEFE),
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: textPrimary,
                                                                    fontFamily: "Nunito",
                                                                  ),
                                                                  hint: Text(
                                                                    "Loại",
                                                                    style: TextStyle(
                                                                      color: textSecondary,
                                                                      fontSize: 15,
                                                                      fontFamily: "Nunito",
                                                                    ),
                                                                  ),
                                                                  items: Utils.tagExpense.map<DropdownMenuItem<TagItem>>((TagItem value) {
                                                                    return DropdownMenuItem(
                                                                      value: value,
                                                                      child: Row(
                                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            value.icon,
                                                                            color: value.color,
                                                                            size: 18,
                                                                          ),

                                                                          // Icon(valueItem.bank_logo),
                                                                          const SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(value.name),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  isExpanded: true,
                                                                  isDense: true,
                                                                  onChanged: (TagItem? selected) {
                                                                    _onDropDownItemSelected(selected!);
                                                                  },
                                                                  value: _tagItemSelected,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          print('Date: ${_model.textController_date.text}\n'
                                                              'Title: ${_model.textController_title.text}\n'
                                                              'Total: ${_model.textController_total.text}\n'
                                                              'Tag: ${_tagItemSelected.id}');

                                                          _viewModel.addDetails(_selectedDate, _model.textController_title.text,
                                                              _model.textController_total.text, _tagItemSelected);
                                                          if(_viewModel.errorMessage.isEmpty){
                                                            setState(() {
                                                              isAdded = true;
                                                            });
                                                          }else{
                                                            toastification.show(
                                                              context: context,
                                                              title: Text(_viewModel.errorMessage),
                                                              type: ToastificationType.error,
                                                              style: ToastificationStyle.flat,
                                                              autoCloseDuration: const Duration(seconds: 2),
                                                            );
                                                          }

                                                          _clearDataTextField();
                                                        },
                                                        text: 'Thêm',
                                                        options: FFButtonOptions(
                                                          height: 40,
                                                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                          iconPadding: EdgeInsets.all(0),
                                                          color: secondaryColor,
                                                          textStyle: TextStyle(
                                                            fontFamily: 'Nunito',
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            letterSpacing: 0.0,
                                                          ),
                                                          elevation: 0,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ))
                                  ])
                                ])))),
                  ),
                ))));
  }
}
