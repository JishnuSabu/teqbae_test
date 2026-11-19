import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:intl/intl.dart';
import 'package:teqbae_test/controller/provider/attendance/attendance_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/model/attendance/attendance_event.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';
import 'package:provider/provider.dart';

class RecentAttendanceList extends StatelessWidget {
  const RecentAttendanceList({super.key});

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);
      return DateFormat('EEE, dd MMM yyyy').format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final records = attendanceProvider.records.take(5).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiUtils.textWidgetCard(
                context: context,
                title: "Recent Attendance",
                styleType: TextStyleType.mediumSemiBold,
                fz: 16.rf(context),
                color: context.textColor2,
              ),
              UiUtils.textWidgetCard(
                context: context,
                title: "Last 5 logs",
                styleType: TextStyleType.extraSmallRegular,
                color: context.primaryGreyColor,
              ),
            ],
          ),
          SizedBox(height: 10.rh(context)),
          if (records.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.rh(context)),
              decoration: BoxDecoration(
                color: context.mainCardColor,
                borderRadius: BorderRadius.circular(15.rf(context)),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  UiUtils.getSvg(
                    ConstSvgIcons.attendance,
                    color: context.primaryGreyColor.withOpacity(0.5),
                    height: 36.rh(context),
                    width: 36.rw(context),
                  ),
                  SizedBox(height: 8.rh(context)),
                  UiUtils.textWidgetCard(
                    title: "No attendance records available yet",
                    context: context,
                    styleType: TextStyleType.smallRegular,
                    color: context.primaryGreyColor,
                  ),
                ],
              ),
            ),
          ] else ...[
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, __) => SizedBox(height: 5.rh(context)),
              itemBuilder: (context, index) {
                final record = records[index];
                return _buildRecordCard(context, record);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, AttendanceRecord record) {
    final statusColor = _getStatusColor(context, record.syncStatus);
    final statusText = _getStatusLabel(record.syncStatus);

    return Container(
      padding: EdgeInsets.all(14.rf(context)),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(12.rf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiUtils.textWidgetCard(
                context: context,
                title: _formatDate(record.date),
                styleType: TextStyleType.smallSemiBold,
                fz: 14.rf(context),
                color: context.mainTextColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.rw(context),
                  vertical: 3.rh(context),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.rf(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.rf(context),
                      height: 6.rf(context),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.rw(context)),
                    UiUtils.textWidgetCard(
                      context: context,
                      title: statusText,
                      styleType: TextStyleType.extraSmallsemiBold,
                      fz: 10.rf(context),
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.rh(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeColumn(
                context,
                title: "Check In",
                time: record.checkIn ?? "--:--",
                isRecorded: record.checkIn != null,
              ),
              _buildTimeColumn(
                context,
                title: "Check Out",
                time: record.checkOut ?? "--:--",
                isRecorded: record.checkOut != null,
              ),
              _buildTimeColumn(
                context,
                title: "Duration",
                time: record.duration ?? "--",
                isRecorded: record.duration != null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(
    BuildContext context, {
    required String title,
    required String time,
    required bool isRecorded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiUtils.textWidgetCard(
          context: context,
          title: title,
          styleType: TextStyleType.extraSmallRegular,
          color: context.primaryGreyColor,
        ),
        SizedBox(height: 2.rh(context)),
        UiUtils.textWidgetCard(
          context: context,
          title: time,
          styleType: TextStyleType.smallSemiBold,
          fz: 13.rf(context),
          color: isRecorded ? context.textColor2 : context.primaryGreyColor,
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, AttendanceSyncStatus status) {
    switch (status) {
      case AttendanceSyncStatus.synced:
        return context.successColor;
      case AttendanceSyncStatus.pending:
        return context.orangeColor;
      case AttendanceSyncStatus.rejected:
        return context.failureColor;
    }
  }

  String _getStatusLabel(AttendanceSyncStatus status) {
    switch (status) {
      case AttendanceSyncStatus.synced:
        return "Synced";
      case AttendanceSyncStatus.pending:
        return "Pending Sync";
      case AttendanceSyncStatus.rejected:
        return "Rejected";
    }
  }
}
