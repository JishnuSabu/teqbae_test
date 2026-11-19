import 'package:flutter/material.dart';
import 'package:teqbae_test/controller/provider/attendance/attendance_provider.dart';
import 'package:teqbae_test/controller/provider/common_provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/controller/provider/leave/leave_provider.dart';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CommonProvider()),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider()..fetchDashboardData(),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider()..fetchAttendanceHistory(),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaveProvider()..fetchLeaveData(),
        ),
      ],
      child: child,
    );
  }
}
