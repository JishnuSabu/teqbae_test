import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:teqbae_test/controller/service/employee/employee_service.dart';
import 'package:teqbae_test/controller/service/leave/leave_service.dart';
import 'package:teqbae_test/core/network/api_response.dart';
import 'package:teqbae_test/core/services/local_storage/local_keys.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/core/services/location_service.dart';
import 'package:teqbae_test/model/employee/employee_model.dart';
import 'package:teqbae_test/model/leave/leave_balance_model.dart';

class DashboardProvider extends ChangeNotifier {
  EmployeeModel? _employee;
  LeaveBalanceModel? _leaveBalance;
  int _currentTabIndex = 0;

  ApiResponse<bool> dashboardResponse = ApiResponse.initial();
  bool _isOffline = false;

  EmployeeModel get employee => _employee ?? _fallbackEmployee();
  LeaveBalanceModel get leaveBalance =>
      _leaveBalance ?? LeaveBalanceModel.empty();
  bool get isOffline => _isOffline;
  int get currentTabIndex => _currentTabIndex;

  void changeTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  EmployeeModel _fallbackEmployee() {
    final rawName = LocalStorageService.getString(LocalStorageKey.USER_NAME_KEY);
    final rawRole =
        LocalStorageService.getString(LocalStorageKey.USER_ROLL_TYPE_KEY);
    if (rawName.isNotEmpty) {
      return EmployeeModel(
        id: '',
        name: rawName,
        department: '',
        designation: rawRole,
      );
    }
    return EmployeeModel.empty();
  }

  DashboardProvider() {
    _loadFromCache();
  }

  void _loadFromCache() {
    final cachedEmp = LocalStorageService.getEmployeeProfile();
    if (cachedEmp != null) {
      _employee = cachedEmp;
    }
    final cachedBal = LocalStorageService.getLeaveBalance();
    if (cachedBal != null) {
      _leaveBalance = cachedBal;
    }
  }

  /// Initialize and fetch dashboard data from mock HTTP API
  Future<void> fetchDashboardData() async {
    dashboardResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final results = await Future.wait([
        EmployeeService.getEmployeeProfile(),
        LeaveService.getLeaveBalance(),
      ]);

      final emp = results[0] as EmployeeModel?;
      if (emp != null) {
        _employee = emp;
        await LocalStorageService.saveEmployeeProfile(_employee!);
        if (_employee!.office != null) {
          LocationService.officeLatitude = _employee!.office!.latitude;
          LocationService.officeLongitude = _employee!.office!.longitude;
          LocationService.permittedRadiusMeters = _employee!.office!.radiusMeters;
          LocationService.officeName = _employee!.office!.name;
        }
      }

      final bal = results[1] as LeaveBalanceModel?;
      if (bal != null) {
        _leaveBalance = bal;
        await LocalStorageService.saveLeaveBalance(_leaveBalance!);
      }

      _isOffline = false;
      dashboardResponse = ApiResponse.success(true);
    } catch (e) {
      log("DashboardProvider fetchDashboardData error: $e");
      _isOffline = true;
      _loadFromCache();

      if (_employee != null) {
        dashboardResponse = ApiResponse.success(true);
      } else {
        dashboardResponse =
            ApiResponse.error("Unable to load dashboard data: $e");
      }
    } finally {
      notifyListeners();
    }
  }
}
