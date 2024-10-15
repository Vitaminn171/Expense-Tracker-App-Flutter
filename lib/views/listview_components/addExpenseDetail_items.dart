import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expenseapp/models/tag.dart';
import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/colors.dart';
import '../../viewmodels/add_expense_viewmodel.dart';
import '../../viewmodels/add_revenue_viewmodel.dart';
import '../../viewmodels/utils.dart';
import '../components/custom_alert_dialog.dart';

class AddTransactionDetailItems extends StatelessWidget {
  final int index;
  final String name;
  final int total;
  final int tag;
  final Function delete;
  final DateTime date;
  final int type;

  const AddTransactionDetailItems(
      {super.key,
      required this.name,
      required this.total,
      required this.tag,
      required this.index,
      required this.delete,
      required this.date,
      required this.type});

  @override
  Widget build(BuildContext context) {
    List<TagItem> list = [];
    switch (type) {
      case 0:
        list = Utils.tagExpense;
        break;
      case 1:
        list = Utils.tagRevenue;
        break;
    // ... more cases
    }
    TagItem tagItem = Utils.getTag(tag, list);
    return // Generated code for this Row Widget...
        Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: Card(
                      elevation: 0,
                      color: tagItem.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(7),
                        child: Icon(
                          tagItem.icon,
                          color: backgroundColor,
                          size: 26,
                        ),
                      )),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          letterSpacing: 0.0,
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          tagItem.name,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            letterSpacing: 0.0,
                            color: textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '\$${Utils.formatCurrency(total)}',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 17,
            letterSpacing: 0.0,
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () async {
            late final viewModel;
            late final listData;
            switch (type) {
              case 0:
                viewModel = context.read<AddExpenseViewModel>();
                listData = await viewModel.expenseProvider.listDetails;
                break;
              case 1:
                viewModel = context.read<AddRevenueViewModel>();
                listData = await viewModel.revenueProvider.listDetails;
                break;
            // ... more cases
            }

            if (listData?.length == 1 && index == 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomAlertDialog(
                      title: 'Xóa thông tin?',
                      info: 'Bạn có chắc chắn muốn xóa tất cả các thông tin chi tiêu cho ngày này? Hành động này không thể hoàn tác.',
                      actionButtonName: 'Xóa',
                      action: () async {
                        Utils.showLoadingDialog(context);
                        delete();
                        await viewModel.deleteData(date);
                        if (viewModel.errorMessage.isEmpty) {
                          toastification.show(
                            context: context,
                            title: const Text('Lưu thông tin thành công!'),
                            type: ToastificationType.success,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        } else {
                          toastification.show(
                            context: context,
                            title: Text(viewModel.errorMessage),
                            type: ToastificationType.error,
                            style: ToastificationStyle.flatColored,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }
                        Navigator.popAndPushNamed(context, '/Home');
                      }));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomAlertDialog(
                      title: 'Xóa thông tin này?',
                      info: 'Xác nhận thông tin $name sẽ bị xóa.',
                      actionButtonName: 'Xóa',
                      action: () {
                        delete();
                        Navigator.pop(context);
                      }));
            }
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
            child: Icon(
              Icons.delete_outline_rounded,
              color: tag0,
            ),
          ),
        )
      ],
    );
  }
}
