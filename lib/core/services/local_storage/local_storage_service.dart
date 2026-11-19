import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teqbae_test/core/services/local_storage/local_keys.dart';
import 'package:teqbae_test/model/attendance/attendance_event.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';
import 'package:teqbae_test/model/employee/employee_model.dart';
import 'package:teqbae_test/model/leave/leave_balance_model.dart';
import 'package:teqbae_test/model/leave/leave_request_model.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Primitive helpers
  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    return _prefs.getInt(key) ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static Future<bool> removeValue(String key) async {
    return await _prefs.remove(key);
  }

  // ----------------- PENDING ATTENDANCE EVENTS (FIFO) -----------------

  static List<AttendanceEvent> getPendingEvents() {
    final raw = _prefs.getString(LocalStorageKey.PENDING_ATTENDANCE_EVENTS);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => AttendanceEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> savePendingEvents(List<AttendanceEvent> events) async {
    final raw = jsonEncode(events.map((e) => e.toJson()).toList());
    await _prefs.setString(LocalStorageKey.PENDING_ATTENDANCE_EVENTS, raw);
  }

  static Future<void> addPendingEvent(AttendanceEvent event) async {
    final current = getPendingEvents();
    // Prevent duplicate keys
    final index =
        current.indexWhere((e) => e.idempotencyKey == event.idempotencyKey);
    if (index >= 0) {
      current[index] = event;
    } else {
      current.add(event);
    }
    await savePendingEvents(current);
  }

  static Future<void> removePendingEvent(String idempotencyKey) async {
    final current = getPendingEvents();
    current.removeWhere((e) => e.idempotencyKey == idempotencyKey);
    await savePendingEvents(current);
  }

  static Future<void> updatePendingEventStatus(
    String idempotencyKey,
    AttendanceSyncStatus status, {
    String? errorMessage,
  }) async {
    final current = getPendingEvents();
    final index =
        current.indexWhere((e) => e.idempotencyKey == idempotencyKey);
    if (index >= 0) {
      current[index] = current[index].copyWith(
        syncStatus: status,
        errorMessage: errorMessage,
      );
      await savePendingEvents(current);
    }
  }

  // ----------------- ATTENDANCE HISTORY CACHE -----------------

  static List<AttendanceRecord> getAttendanceHistory() {
    final raw = _prefs.getString(LocalStorageKey.ATTENDANCE_HISTORY);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAttendanceHistory(
      List<AttendanceRecord> records) async {
    final raw = jsonEncode(records.map((e) => e.toJson()).toList());
    await _prefs.setString(LocalStorageKey.ATTENDANCE_HISTORY, raw);
  }

  // ----------------- TODAY'S ATTENDANCE CACHE -----------------

  static Map<String, dynamic>? getTodayAttendance() {
    final raw = _prefs.getString(LocalStorageKey.TODAY_ATTENDANCE);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveTodayAttendance(Map<String, dynamic> data) async {
    await _prefs.setString(LocalStorageKey.TODAY_ATTENDANCE, jsonEncode(data));
  }

  // ----------------- EMPLOYEE PROFILE CACHE -----------------

  static EmployeeModel? getEmployeeProfile() {
    final raw = _prefs.getString(LocalStorageKey.EMPLOYEE_PROFILE);
    if (raw == null || raw.isEmpty) return null;
    try {
      return EmployeeModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveEmployeeProfile(EmployeeModel employee) async {
    await _prefs.setString(
        LocalStorageKey.EMPLOYEE_PROFILE, jsonEncode(employee.toJson()));
  }

  // ----------------- LEAVE BALANCE CACHE -----------------

  static LeaveBalanceModel? getLeaveBalance() {
    final raw = _prefs.getString(LocalStorageKey.LEAVE_BALANCE);
    if (raw == null || raw.isEmpty) return null;
    try {
      return LeaveBalanceModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLeaveBalance(LeaveBalanceModel balance) async {
    await _prefs.setString(
        LocalStorageKey.LEAVE_BALANCE, jsonEncode(balance.toJson()));
  }

  // ----------------- LEAVE REQUESTS CACHE -----------------

  static List<LeaveRequestModel> getLeaveRequests() {
    final raw = _prefs.getString(LocalStorageKey.LEAVE_REQUESTS);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LeaveRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveLeaveRequests(
      List<LeaveRequestModel> requests) async {
    final raw = jsonEncode(requests.map((e) => e.toJson()).toList());
    await _prefs.setString(LocalStorageKey.LEAVE_REQUESTS, raw);
  }
}
