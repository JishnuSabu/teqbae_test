import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teqbae_test/controller/provider/attendance/attendance_provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/controller/provider/leave/leave_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_images.dart';
import 'package:teqbae_test/core/network/api_status.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/custom_profile_bar.dart';
import 'package:teqbae_test/core/widgets/custom_shimmer_loading_widget.dart';
import 'package:teqbae_test/view/dashboard/widgets/attendance_action_card.dart';
import 'package:teqbae_test/view/dashboard/widgets/custom_bottom_nav_bar.dart';
import 'package:teqbae_test/view/dashboard/widgets/leave_balance_card.dart';
import 'package:teqbae_test/view/dashboard/widgets/recent_attendance_list.dart';
import 'package:teqbae_test/view/leave/leave_screen.dart';
import 'package:teqbae_test/view/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _checkLocation(BuildContext context) async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: context.mainCardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.rf(context))),
          title: Row(
            children: [
              Icon(
                Icons.location_off_rounded,
                color: context.failureColor,
                size: 26.rf(context),
              ),
              SizedBox(width: 8.rw(context)),
              Text(
                "Turn On Location",
                style: TextStyle(
                  fontSize: 16.rf(context),
                  fontWeight: FontWeight.bold,
                  color: context.mainTextColor,
                ),
              ),
            ],
          ),
          content: Text(
            "Location services (GPS) are turned off on your device. Please turn on location to record your attendance.",
            style: TextStyle(
              fontSize: 14.rf(context),
              color: context.textColor2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: context.primaryGreyColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await Geolocator.openLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.rf(context)),
                ),
              ),
              child: const Text(
                "Turn On",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _loadData(BuildContext context) async {
    final dashboardProvider = context.read<DashboardProvider>();
    final attendanceProvider = context.read<AttendanceProvider>();
    final leaveProvider = context.read<LeaveProvider>();
    await Future.wait([
      dashboardProvider.fetchDashboardData(),
      attendanceProvider.fetchAttendanceHistory(),
      leaveProvider.fetchLeaveData(),
    ]);
    if (context.mounted) {
      _checkLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final currentTab = dashboardProvider.currentTabIndex;

    if (dashboardProvider.dashboardResponse.status == ApiStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadData(context);
      });
    }

    return Scaffold(
      backgroundColor: context.primaryColor,
      body: currentTab == 2
          ? const SettingsScreen()
          : (currentTab == 1 ? const LeaveScreen() : _buildHomeTab(context)),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentTab,
        onTabSelected: (index) {
          dashboardProvider.changeTabIndex(index);
        },
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;
    final isLoading =
        dashboardProvider.dashboardResponse.status == ApiStatus.loading &&
            employee.id.isEmpty;

    if (isLoading) {
      return _buildLoadingState(context);
    }

    return Column(
      children: [
        // ── Fixed Top Header + Attendance Action Card (Never scrolls) ──
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: 200.rh(context),
              width: double.infinity,
              child: UiUtils.getAssetimage(
                ConstImages.header,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomProfileBar(
                    employee: employee,
                  ),
                  SizedBox(height: 8.rh(context)),
                  const AttendanceActionCard(),
                ],
              ),
            ),
          ],
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadData(context),
            color: context.themeColor,
            backgroundColor: context.mainCardColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: 12.rh(context),
                bottom: 90.rh(context),
              ),
              child: Column(
                children: [
                  const LeaveBalanceCard(),
                  SizedBox(height: 14.rh(context)),
                  const RecentAttendanceList(),
                  SizedBox(height: 20.rh(context)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomShimmer(height: 190.rh(context)),
          SizedBox(height: 16.rh(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
            child: CustomShimmer(
              height: 160.rh(context),
              borderRadius: 20.rf(context),
            ),
          ),
          SizedBox(height: 16.rh(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
            child: CustomShimmer(
              height: 60.rh(context),
              borderRadius: 12.rf(context),
            ),
          ),
          SizedBox(height: 16.rh(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
            child: CustomShimmer(
              height: 120.rh(context),
              borderRadius: 16.rf(context),
            ),
          ),
        ],
      ),
    );
  }
}
