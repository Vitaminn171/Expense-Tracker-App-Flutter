import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

import 'package:expenseapp/viewmodels/add_expense_viewmodel.dart';
import 'package:toastification/toastification.dart';

import 'package:expenseapp/models/colors.dart';
import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/viewmodels/utils.dart';
import 'components/background_widget.dart';
import 'components/custom_alert_dialog.dart';
import 'components/custom_drawer.dart';
import 'components/custom_popscope.dart';
import 'components/user_widget.dart';
import 'listview_components/addExpenseDetail_items.dart';
export 'package:expenseapp/viewmodels/add_expense_viewmodel.dart';

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({super.key});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  late AddExpenseModel _model;
  late AddExpenseViewModel _viewModel;
  double _heightContainer = 370;
  late DateTime _selectedDate;

  TagItem _tagItemSelected = Utils.tagExpense.first;
  bool isAdded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddExpenseModel());

    _viewModel = Provider.of<AddExpenseViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.getListTransactionsDetail();

        setState(() {
          _selectedDate = _viewModel.selectedDate ?? DateTime(Utils.now.year, Utils.now.month, Utils.now.day);
        });

      _model.textController_date ??= TextEditingController();
      _model.textFieldFocusNode_date ??= FocusNode();

      _model.textController_date.text = Utils.formatDate(_selectedDate);

      _model.textController_title ??= TextEditingController();
      _model.textFieldFocusNode_title ??= FocusNode();

      _model.textController_total ??= TextEditingController();
      _model.textFieldFocusNode_total ??= FocusNode();

      _model.textController_tag ??= TextEditingController();
      _model.textFieldFocusNode_tag ??= FocusNode();

    });


  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.expenseProvider.setListTransactionsDetail([]);
      _viewModel.expenseProvider.setExpenseEdit(null);
    });

    _model.dispose();

    super.dispose();
  }

  void moveWidgetWhenUseKeyBoard(bool flag, var size) {
    setState(() {
      if (flag) {
        _heightContainer = 600;
      } else {
        _heightContainer = size * 0.26953125;
      }
    });
  }

  void _onDropDownItemSelected(TagItem newSelected) {
    setState(() {
      _tagItemSelected = newSelected;
    });
  }

  void _clearDataTextField() {
    _model.textController_title?.clear();
    _model.textController_total?.clear();
    _tagItemSelected = Utils.tagExpense.first;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context).height;
    var heightContainer = size * 0.26953125;
    print(size);

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomPopscope(
            widget: Scaffold(
                key: scaffoldKey,
                backgroundColor: backgroundColor,
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
                            physics: const NeverScrollableScrollPhysics(),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.935,
                                child: Stack(children: [
                                  BackgroundWidget(
                                    alignmentDirectional: const AlignmentDirectional(0, -1),
                                    imgHeight: 500,
                                  ),
                                  Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(25, 60, 25, 0),
                                      child: UserWidget(
                                        scaffoldKey: scaffoldKey,
                                        title: 'Thêm chi tiêu',
                                        flag: isAdded,
                                        save: () {
                                          _viewModel.saveDetails(_selectedDate);
                                        },
                                      ), //'Danh sách chi tiêu'
                                    ),
                                    Expanded(
                                        child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Stack(children: [
                                        Align(
                                          alignment: const AlignmentDirectional(0, -1),
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
                                                    padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 5),
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
                                                            const Text(
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
                                                                _showDialogSave();
                                                              },
                                                              text: 'Lưu',
                                                              icon: const Icon(
                                                                Icons.save_alt_rounded,
                                                                color: textSecondary,
                                                                size: 15,
                                                              ),
                                                              options: FFButtonOptions(
                                                                height: 36,
                                                                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                color: backgroundColor,
                                                                textStyle: const TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  color: textSecondary,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                                elevation: 0,
                                                                borderSide: const BorderSide(
                                                                  color: alternateColor,
                                                                  width: 2,
                                                                ),
                                                                borderRadius: BorderRadius.circular(10),
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
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 10),
                                                  child: Consumer<ExpenseProvider>(builder: (context, myState, child) {
                                                    //final data = myState.listTransactions!;
                                                    return FutureBuilder<List<TransactionDetails>>(
                                                        future: myState.listDetails,
                                                        builder: (context, snapshot) {
                                                          if (snapshot.data != null) {
                                                            final data = snapshot.data!;
                                                            return SizedBox(
                                                              height: heightContainer,
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
                                                                          child: AddTransactionDetailItems(
                                                                            name: items.name,
                                                                            total: items.total,
                                                                            tag: items.tag,
                                                                            index: index,
                                                                            date: _selectedDate,
                                                                            delete: () async {
                                                                              final flag = await _viewModel.deleteDetail(index);
                                                                              setState(() {
                                                                                isAdded = flag;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            type: 0,
                                                                          )));
                                                                },
                                                              ),
                                                            );
                                                          } else {
                                                            return const Center(
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
                                          alignment: const AlignmentDirectional(0, 1),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: _heightContainer,
                                              decoration: const BoxDecoration(
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
                                                padding: const EdgeInsets.all(25),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    const Text(
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
                                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_date,
                                                          focusNode: _model.textFieldFocusNode_date,
                                                          autofocus: false,
                                                          readOnly: true,
                                                          obscureText: false,
                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false, size);
                                                          },
                                                          onTap: () async {
                                                            if (!isAdded) {
                                                              final DateTime? picked = await showDatePicker(
                                                                context: context,
                                                                locale: const Locale('vi'),
                                                                initialDate: _selectedDate,
                                                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                                                lastDate: DateTime.now(),
                                                                builder: (context, child) {
                                                                  return Theme(
                                                                    data: Theme.of(context).copyWith(
                                                                      colorScheme: const ColorScheme.light(
                                                                        primary: primaryColor,
                                                                        // header background color
                                                                        secondary: alternateColor,
                                                                        onPrimary: Colors.black,
                                                                        // header text color
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
                                                            moveWidgetWhenUseKeyBoard(false, size);
                                                          },
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            filled: true,
                                                            fillColor: isAdded == true ? alternateColor : const Color(0xFFFEFEFE),
                                                            labelText: 'Ngày',
                                                            labelStyle:const  TextStyle(
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
                                                            prefixIcon: const Icon(
                                                              Icons.calendar_today_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: const TextStyle(
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
                                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_title,
                                                          focusNode: _model.textFieldFocusNode_title,
                                                          onTap: () {
                                                            moveWidgetWhenUseKeyBoard(true, size);
                                                          },
                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false, size);
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
                                                            fillColor: const Color(0xFFFEFEFE),
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
                                                          validator: _model.textControllerValidator_title.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: TextFormField(
                                                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          controller: _model.textController_total,
                                                          focusNode: _model.textFieldFocusNode_total,
                                                          onTap: () {
                                                            moveWidgetWhenUseKeyBoard(true, size);
                                                          },
                                                          onTapOutside: (_) {
                                                            moveWidgetWhenUseKeyBoard(false, size);
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
                                                            fillColor: const Color(0xFFFEFEFE),
                                                            prefixIcon: const Icon(
                                                              Icons.attach_money_rounded,
                                                              color: secondaryColor,
                                                            ),
                                                          ),
                                                          style: const TextStyle(
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
                                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: FormField<TagItem>(
                                                          builder: (FormFieldState<TagItem> state) {
                                                            return InputDecorator(
                                                              decoration: InputDecoration(
                                                                isDense: true,
                                                                labelText: 'Loại',
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
                                                                fillColor: const Color(0xFFFEFEFE),
                                                                prefixIcon: const Icon(
                                                                  Icons.category_rounded,
                                                                  color: secondaryColor,
                                                                ),
                                                              ),
                                                              child: DropdownButtonHideUnderline(
                                                                child: DropdownButton<TagItem>(
                                                                  dropdownColor: const Color(0xFFFEFEFE),
                                                                  style: const TextStyle(
                                                                    fontSize: 15,
                                                                    color: textPrimary,
                                                                    fontFamily: "Nunito",
                                                                  ),
                                                                  hint: const Text(
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
                                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          FocusManager.instance.primaryFocus?.unfocus();

                                                          _viewModel.addDetails(_selectedDate, _model.textController_title.text,
                                                              _model.textController_total.text, _tagItemSelected);

                                                          if (_viewModel.errorMessage.isEmpty) {
                                                            setState(() {
                                                              isAdded = true;
                                                            });
                                                          } else {
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
                                                          padding: const  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                          iconPadding: const EdgeInsets.all(0),
                                                          color: secondaryColor,
                                                          textStyle: const TextStyle(
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

  void _showDialogSave() {
    if (isAdded) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(
              title: 'Lưu thông tin?',
              info: 'Xác nhận lưu chi tiêu hoặc có thể thoát để tiếp tục chỉnh sửa.',
              action: () async {
                if (await _viewModel.saveDetails(_selectedDate)) {
                  toastification.show(
                    context: context,
                    title: const Text('Lưu thông tin thành công!'),
                    type: ToastificationType.success,
                    style: ToastificationStyle.flatColored,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                  Navigator.popAndPushNamed(context, '/Home');
                } else {
                  if (_viewModel.errorMessage.isNotEmpty) {
                    toastification.show(
                      context: context,
                      title: Text(_viewModel.errorMessage),
                      type: ToastificationType.error,
                      style: ToastificationStyle.flatColored,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  }
                }
              }));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => const CustomAlertDialog(
                title: 'Không cần lưu!',
                info: 'Hiện tại dữ liệu chưa có hoặc chưa có sự thay đổi nào để lưu!',
              ));
    }
  }
}
