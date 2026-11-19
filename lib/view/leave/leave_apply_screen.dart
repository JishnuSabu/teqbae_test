import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teqbae_test/controller/provider/leave/leave_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/body_frame_widget.dart';
import 'package:teqbae_test/core/widgets/common_back_alert_dialog.dart';
import 'package:teqbae_test/core/widgets/custom_button_widget.dart';
import 'package:teqbae_test/core/widgets/custom_textform_field_widget.dart';
import 'package:provider/provider.dart';

class LeaveApplyScreen extends StatelessWidget {
  const LeaveApplyScreen({super.key});

  Future<void> _selectDate(
    BuildContext context,
    LeaveProvider lp,
    bool isStartDate,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime initial = (isStartDate ? lp.startDate : lp.endDate) ?? today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.rf(context)),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: context.themeColor,
              onPrimary: context.whiteColor,
              surface: context.mainCardColor,
              onSurface: context.textColor2,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartDate) {
        lp.setStartDate(picked);
      } else {
        lp.setEndDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = context.watch<LeaveProvider>();
    final balance = leaveProvider.leaveBalance;

    final startDateText = leaveProvider.startDate != null
        ? DateFormat('dd MMM yyyy').format(leaveProvider.startDate!)
        : "";
    final endDateText = leaveProvider.endDate != null
        ? DateFormat('dd MMM yyyy').format(leaveProvider.endDate!)
        : "";

    return BodyFrameWidget(
      title: "Apply Leave",
      onBackTap: () {
        showDialog(
          context: context,
          builder: (context) => const CommonBackAlertDialog(),
        );
      },
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const CommonBackAlertDialog(),
        );
      },
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const CommonBackAlertDialog(),
                  );
                },
                child: Container(
                  height: 48.rh(context),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.mainCardColor,
                    borderRadius: BorderRadius.circular(15.rf(context)),
                    border: Border.all(
                      color: context.secondaryColor,
                    ),
                  ),
                  child: UiUtils.textWidgetCard(
                    context: context,
                    title: "Cancel",
                    styleType: TextStyleType.subtitle2,
                    color: context.textColor2,
                    fw: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.rw(context)),
            Expanded(
              flex: 2,
              child: CustomButtonWidget(
                title: "Save",
                bottonColor: context.themeColor,
                titleColor: context.whiteColor,
                isLoading: leaveProvider.isSubmitting,
                borderRadius: 15.rf(context),
                height: 48.rh(context),
                onTap: () async {
                  final result = await leaveProvider.submitLeaveApplication();
                  if (context.mounted) {
                    if (result.isSuccess) {
                      UiUtils.showSnackBarMessage(
                        context,
                        result.message,
                        isSuccess: true,
                      );
                      context.pop();
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: context.mainCardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.rf(context)),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: context.failureColor,
                              ),
                              SizedBox(width: 8.rw(context)),
                              Text(
                                "Submission Failed",
                                style: TextStyle(
                                  color: context.mainTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.rf(context),
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            result.message,
                            style: TextStyle(
                              color: context.textColor2,
                              fontSize: 14.rf(context),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: context.themeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      widget: Form(
        key: leaveProvider.formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.rh(context)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, leaveProvider, true),
                      behavior: HitTestBehavior.opaque,
                      child: AbsorbPointer(
                        child: CustomTextFormWidget(
                          controller:
                              TextEditingController(text: startDateText),
                          textinputType: TextInputType.none,
                          titles: "Select Date",
                          labelText: "Start Date",
                          titleStyle: AppTextStyles.getStyle(
                            context,
                            TextStyleType.smallRegular,
                            color: context.primaryGreyColor,
                          ),
                          forgotpasswordType: 1,
                          borderRadius: BorderRadius.circular(15.rf(context)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          textColor: context.textColor2,
                          borderColor: context.secondaryColor,
                          suffixWidget: Padding(
                            padding: EdgeInsets.all(16.rh(context)),
                            child: UiUtils.getSvg(ConstSvgIcons.calenderYear),
                          ),
                          validator: (value) => null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.rw(context)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, leaveProvider, false),
                      behavior: HitTestBehavior.opaque,
                      child: AbsorbPointer(
                        child: CustomTextFormWidget(
                          controller: TextEditingController(text: endDateText),
                          textinputType: TextInputType.none,
                          titles: "Select Date",
                          labelText: "End Date",
                          titleStyle: AppTextStyles.getStyle(
                            context,
                            TextStyleType.smallRegular,
                            color: context.primaryGreyColor,
                          ),
                          forgotpasswordType: 1,
                          borderRadius: BorderRadius.circular(15.rf(context)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          textColor: context.textColor2,
                          borderColor: context.secondaryColor,
                          suffixWidget: Padding(
                            padding: EdgeInsets.all(16.rh(context)),
                            child: UiUtils.getSvg(ConstSvgIcons.calenderYear),
                          ),
                          validator: (value) => null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (leaveProvider.requestedDays > 0) ...[
                SizedBox(height: 8.rh(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.rw(context)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13.rf(context),
                        color: context.themeColor,
                      ),
                      SizedBox(width: 6.rw(context)),
                      Text(
                        "Total: ${leaveProvider.requestedDays} day${leaveProvider.requestedDays > 1 ? 's' : ''} requested",
                        style: TextStyle(
                          fontSize: 12.rf(context),
                          fontWeight: FontWeight.w600,
                          color: context.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 16.rh(context)),
              DropdownButtonFormField<String>(
                dropdownColor: context.mainCardColor,
                value: leaveProvider.selectedLeaveType,
                style: TextStyle(
                  color: context.textColor2,
                  fontSize: 14.rf(context),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: "Leave Type",
                  labelStyle: AppTextStyles.getStyle(
                    context,
                    TextStyleType.mediumBold,
                    color: context.textColor2,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.rw(context),
                    vertical: 16.rh(context),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.rf(context)),
                    borderSide: BorderSide(
                      color: context.secondaryColor,
                      width: 1.rw(context),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.rf(context)),
                    borderSide: BorderSide(
                      color: context.themeColor,
                      width: 1.5.rw(context),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.rf(context)),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.primaryGreyColor,
                ),
                items: [
                  DropdownMenuItem(
                    value: "Casual",
                    child: Text(
                      "Casual Leave (${balance.casual} Days Available)",
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Sick",
                    child: Text(
                      "Sick Leave (${balance.sick} Days Available)",
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) leaveProvider.setLeaveType(val);
                },
              ),
              SizedBox(height: 16.rh(context)),
              CustomTextFormWidget(
                controller: leaveProvider.reasonController,
                textinputType: TextInputType.multiline,
                maxline: 3,
                titles: "Remarks",
                labelText: "Remark",
                forgotpasswordType: 1,
                borderRadius: BorderRadius.circular(15.rf(context)),
                titleStyle: AppTextStyles.getStyle(
                  context,
                  TextStyleType.smallRegular,
                  color: context.primaryGreyColor,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                textColor: context.textColor2,
                borderColor: context.secondaryColor,
                onChanged: (val) => leaveProvider.onReasonChanged(val),
                validator: (value) => null,
              ),
              SizedBox(height: 100.rh(context)),
            ],
          ),
        ),
      ),
    );
  }
}
