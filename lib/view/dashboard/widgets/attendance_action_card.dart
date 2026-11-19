import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:teqbae_test/controller/provider/attendance/attendance_provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class AttendanceActionCard extends StatelessWidget {
  const AttendanceActionCard({super.key});

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void _showResultDialog(BuildContext context, String message,
      {required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.mainCardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rf(context))),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: isSuccess ? context.successColor : context.failureColor,
              size: 24.rf(context),
            ),
            SizedBox(width: 8.rw(context)),
            Text(
              isSuccess ? "Attendance Recorded" : "Attendance Notice",
              style: TextStyle(
                fontSize: 16.rf(context),
                fontWeight: FontWeight.bold,
                color: context.mainTextColor,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.rf(context),
            color: context.textColor2,
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

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;
    final status = attendanceProvider.todayStatus;
    final checkInTime = attendanceProvider.checkInTime;
    final checkOutTime = attendanceProvider.checkOutTime;
    final isProcessing = attendanceProvider.isProcessingAction;

    final hasCheckIn = status == 'checked_in' || status == 'checked_out';
    final hasCheckOut = status == 'checked_out';

    final String todayFormatted =
        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.rw(context)),
      padding: EdgeInsets.symmetric(
        horizontal: 18.rw(context),
        vertical: 8.rh(context),
      ),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(15.rf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiUtils.textWidgetCard(
                    title: "Todays Overview",
                    context: context,
                    styleType: TextStyleType.smallRegular,
                    color: context.primaryGreyColor,
                  ),
                  SizedBox(height: 2.rh(context)),
                  UiUtils.textWidgetCard(
                    context: context,
                    title: todayFormatted,
                    styleType: TextStyleType.smallSemiBold,
                    fz: 16.rf(context),
                    color: context.textColor2,
                  ),
                ],
              ),
              if (status == 'checked_in')
                _badge(
                  context,
                  color: context.successColor,
                  label: _formatDuration(
                      attendanceProvider.elapsedWorkingDuration),
                  showDot: true,
                )
              else if (status == 'checked_out')
                _badge(context, color: context.themeColor, label: "Completed"),
            ],
          ),
          SizedBox(height: 12.rh(context)),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.rh(context),
              horizontal: 8.rw(context),
            ),
            decoration: BoxDecoration(
              color: context.secondCardColor,
              borderRadius: BorderRadius.circular(20.rf(context)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (status == 'not_checked_in' && !isProcessing)
                        ? () async {
                            final result =
                                await attendanceProvider.performCheckIn();
                            if (context.mounted) {
                              _showResultDialog(context, result.message,
                                  isSuccess: result.isSuccess);
                            }
                          }
                        : null,
                    borderRadius: BorderRadius.circular(14.rf(context)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.rh(context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UiUtils.getSvg(
                            ConstSvgIcons.checkIn,
                            color: hasCheckIn
                                ? context.successColor
                                : context.primaryGreyColor,
                            height: 22.rh(context),
                            width: 22.rw(context),
                          ),
                          SizedBox(height: 6.rh(context)),
                          UiUtils.textWidgetCard(
                            context: context,
                            title: "Check In",
                            styleType: TextStyleType.smallBold,
                            color: context.primaryGreyColor,
                          ),
                          SizedBox(height: 2.rh(context)),
                          UiUtils.textWidgetCard(
                            context: context,
                            title: checkInTime ??
                                (attendanceProvider.shiftStartTime ?? "--:--"),
                            styleType: TextStyleType.smallSemiBold,
                            fz: 16.rf(context),
                            color: context.textColor2,
                          ),
                          SizedBox(height: 6.rh(context)),
                          if (isProcessing && status == 'not_checked_in')
                            LoadingAnimationWidget.threeArchedCircle(
                              color: context.themeColor,
                              size: 16.rf(context),
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.rw(context),
                                vertical: 4.rh(context),
                              ),
                              decoration: BoxDecoration(
                                color: hasCheckIn
                                    ? context.successColor.withOpacity(0.12)
                                    : context.themeColor.withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(10.rf(context)),
                              ),
                              child: UiUtils.textWidgetCard(
                                context: context,
                                title: hasCheckIn
                                    ? "Done at $checkInTime"
                                    : "Tap to Check In",
                                styleType: TextStyleType.extraSmallRegular,
                                color: hasCheckIn
                                    ? context.successColor
                                    : context.themeColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70.rh(context),
                  child: VerticalDivider(
                    color: context.primaryGreyColor.withOpacity(0.2),
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (status == 'checked_in' && !isProcessing)
                        ? () async {
                            final result =
                                await attendanceProvider.performCheckOut();
                            if (context.mounted) {
                              _showResultDialog(context, result.message,
                                  isSuccess: result.isSuccess);
                            }
                          }
                        : null,
                    borderRadius: BorderRadius.circular(14.rf(context)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.rh(context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UiUtils.getSvg(
                            ConstSvgIcons.checkOut,
                            color: hasCheckOut
                                ? context.successColor
                                : (status == 'checked_in'
                                    ? context.failureColor
                                    : context.primaryGreyColor),
                            height: 22.rh(context),
                            width: 22.rw(context),
                          ),
                          SizedBox(height: 6.rh(context)),
                          UiUtils.textWidgetCard(
                            context: context,
                            title: "Check Out",
                            styleType: TextStyleType.smallBold,
                            color: context.primaryGreyColor,
                          ),
                          SizedBox(height: 2.rh(context)),
                          UiUtils.textWidgetCard(
                            context: context,
                            title: checkOutTime ?? "--:--",
                            styleType: TextStyleType.smallSemiBold,
                            fz: 16.rf(context),
                            color: context.textColor2,
                          ),
                          SizedBox(height: 6.rh(context)),
                          if (isProcessing && status == 'checked_in')
                            LoadingAnimationWidget.threeArchedCircle(
                              color: context.themeColor,
                              size: 16.rf(context),
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.rw(context),
                                vertical: 4.rh(context),
                              ),
                              decoration: BoxDecoration(
                                color: hasCheckOut
                                    ? context.successColor.withOpacity(0.12)
                                    : (status == 'checked_in'
                                        ? context.failureColor.withOpacity(0.12)
                                        : context.primaryGreyColor
                                            .withOpacity(0.08)),
                                borderRadius:
                                    BorderRadius.circular(10.rf(context)),
                              ),
                              child: UiUtils.textWidgetCard(
                                context: context,
                                title: hasCheckOut
                                    ? "Done at $checkOutTime"
                                    : (status == 'checked_in'
                                        ? "Tap to Check Out"
                                        : "Not Done"),
                                styleType: TextStyleType.extraSmallRegular,
                                color: hasCheckOut
                                    ? context.successColor
                                    : (status == 'checked_in'
                                        ? context.failureColor
                                        : context.primaryGreyColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.rh(context)),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 13.rf(context),
                color: context.primaryGreyColor,
              ),
              SizedBox(width: 4.rw(context)),
              Expanded(
                child: UiUtils.textWidgetCard(
                  context: context,
                  title: employee.office != null
                      ? "${employee.office!.name} • ${employee.office!.radiusMeters.toInt()}m Geofence restricted"
                      : "Office Geofence restricted",
                  styleType: TextStyleType.extraSmallRegular,
                  color: context.primaryGreyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context,
      {required Color color, required String label, bool showDot = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.rw(context),
        vertical: 4.rh(context),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.rf(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7.rf(context),
              height: 7.rf(context),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 6.rw(context)),
          ],
          UiUtils.textWidgetCard(
            context: context,
            title: label,
            styleType: TextStyleType.smallBold,
            fz: 12.rf(context),
            color: color,
          ),
        ],
      ),
    );
  }
}
