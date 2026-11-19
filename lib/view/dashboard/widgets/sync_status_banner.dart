import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/controller/provider/attendance/attendance_provider.dart';
import 'package:teqbae_test/core/sync/sync_service.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final pendingCount = attendanceProvider.pendingEventsCount;
    final isSyncing = SyncService().isSyncing;

    final hasPending = pendingCount > 0;
    final bannerColor = hasPending ? context.orangeColor : context.greenColor2;
    final iconData =
        hasPending ? Icons.sync_problem_outlined : Icons.cloud_done_outlined;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 12.rw(context), vertical: 10.rh(context)),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.rf(context)),
        border: Border.all(color: bannerColor.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(iconData, color: bannerColor, size: 20.rf(context)),
          SizedBox(width: 10.rw(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPending
                      ? "Pending Sync: $pendingCount event(s)"
                      : "All events synchronized",
                  style: TextStyle(
                    fontSize: 12.rf(context),
                    fontWeight: FontWeight.w600,
                    color: context.textColor2,
                  ),
                ),
                SizedBox(height: 2.rh(context)),
                Text(
                  hasPending
                      ? "Saved locally in offline queue (FIFO order)"
                      : "Local storage matches server records",
                  style: TextStyle(
                    fontSize: 10.rf(context),
                    color: context.textColor2.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.rw(context)),
          SizedBox(
            height: 32.rh(context),
            child: ElevatedButton(
              onPressed: isSyncing
                  ? null
                  : () async {
                      final result =
                          await attendanceProvider.triggerManualSync();
                      if (context.mounted) {
                        UiUtils.showSnackBarMessage(
                          context,
                          result.message,
                          isSuccess:
                              result.syncedCount > 0 || result.totalCount == 0,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: bannerColor,
                disabledBackgroundColor: bannerColor.withOpacity(0.6),
                padding: EdgeInsets.symmetric(horizontal: 12.rw(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.rf(context))),
              ),
              child: isSyncing
                  ? SizedBox(
                      width: 14.rf(context),
                      height: 14.rf(context),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: context.whiteColor),
                    )
                  : Text(
                      "Sync Now",
                      style: TextStyle(
                        color: context.whiteColor,
                        fontSize: 11.rf(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
