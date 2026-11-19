import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teqbae_test/controller/service/attendance/attendance_service.dart';
import 'package:teqbae_test/core/network/api_response.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/core/services/location_service.dart';
import 'package:teqbae_test/core/sync/sync_service.dart';
import 'package:teqbae_test/model/attendance/attendance_event.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';

class AttendanceActionResult {
  final bool isSuccess;
  final String message;
  final bool isSavedOffline;

  AttendanceActionResult({
    required this.isSuccess,
    required this.message,
    this.isSavedOffline = false,
  });
}

class AttendanceProvider extends ChangeNotifier {
  AttendanceProvider() {
    _loadFromLocalStorage();
    SyncService().addListener(_onSyncUpdate);
  }

  void _onSyncUpdate() {
    _loadFromLocalStorage();
    notifyListeners();
  }

  // Today's attendance state
  String _todayStatus = 'not_checked_in';
  String? _shiftStartTime;
  String? _checkInTime;
  String? _checkOutTime;
  DateTime? _checkInDateTime;
  Duration _elapsedWorkingDuration = Duration.zero;
  Timer? _elapsedTimer;

  // History and pending
  List<AttendanceRecord> _records = [];
  List<AttendanceEvent> _pendingEvents = [];

  bool _isProcessingAction = false;
  bool get isProcessingAction => _isProcessingAction;

  ApiResponse<List<AttendanceRecord>> attendanceHistoryResponse =
      ApiResponse.initial();

  // Getters
  String get todayStatus => _todayStatus;
  String? get shiftStartTime => _shiftStartTime;
  String? get checkInTime => _checkInTime;
  String? get checkOutTime => _checkOutTime;
  Duration get elapsedWorkingDuration => _elapsedWorkingDuration;
  List<AttendanceRecord> get records => _records;
  List<AttendanceEvent> get pendingEvents => _pendingEvents;
  int get pendingEventsCount => _pendingEvents.length;

  void _loadFromLocalStorage() {
    _pendingEvents = LocalStorageService.getPendingEvents();
    _records = LocalStorageService.getAttendanceHistory();

    final todayData = LocalStorageService.getTodayAttendance();
    if (todayData != null) {
      final savedDate = todayData['date']?.toString();
      final todayDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (savedDate == todayDateStr) {
        _todayStatus = todayData['today_status']?.toString() ?? 'not_checked_in';
        _checkInTime = todayData['check_in_time']?.toString();
        _checkOutTime = todayData['check_out_time']?.toString();

        final checkInTimestamp = todayData['check_in_timestamp']?.toString();
        if (checkInTimestamp != null && checkInTimestamp.isNotEmpty) {
          _checkInDateTime = DateTime.tryParse(checkInTimestamp);
        }
      }
    }

    _updateElapsedTimer();
  }

  void _updateElapsedTimer() {
    _elapsedTimer?.cancel();
    if (_todayStatus == 'checked_in' && _checkInDateTime != null) {
      _elapsedWorkingDuration = DateTime.now().difference(_checkInDateTime!);
      _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_checkInDateTime != null) {
          _elapsedWorkingDuration = DateTime.now().difference(_checkInDateTime!);
          notifyListeners();
        }
      });
    } else {
      _elapsedWorkingDuration = Duration.zero;
    }
  }

  /// Fetch latest attendance history and today's status from mock API
  Future<void> fetchAttendanceHistory() async {
    attendanceHistoryResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final data = await AttendanceService.getAttendance();
      if (data != null) {
        if (data['today'] is Map<String, dynamic>) {
          final today = data['today'] as Map<String, dynamic>;
          _todayStatus = today['today_status']?.toString() ?? 'not_checked_in';
          _checkInTime = today['check_in_time']?.toString();
          _checkOutTime = today['check_out_time']?.toString();
        }

        if (data['records'] is List) {
          _records = (data['records'] as List).map((item) {
            return AttendanceRecord.fromJson(item as Map<String, dynamic>);
          }).toList();
          await LocalStorageService.saveAttendanceHistory(_records);
        }
      }

      await LocalStorageService.saveTodayAttendance({
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'today_status': _todayStatus,
        'check_in_time': _checkInTime,
        'check_out_time': _checkOutTime,
        'check_in_timestamp': _checkInDateTime?.toIso8601String(),
      });

      _loadFromLocalStorage();
      attendanceHistoryResponse = ApiResponse.success(_records);
    } catch (e) {
      log("AttendanceProvider fetchAttendanceHistory error: $e");
      _loadFromLocalStorage();
      attendanceHistoryResponse = ApiResponse.error(
        _records.isNotEmpty
            ? "Offline Mode: Showing cached attendance"
            : "Failed to load attendance: ${e.toString()}",
      );
    } finally {
      notifyListeners();
    }
  }

  /// Perform Check-In using real API or local queue if offline
  Future<AttendanceActionResult> performCheckIn() async {
    if (_isProcessingAction) {
      return AttendanceActionResult(
        isSuccess: false,
        message: "An action is already in progress.",
      );
    }

    _isProcessingAction = true;
    notifyListeners();

    try {
      if (_todayStatus == 'checked_in' || _todayStatus == 'checked_out') {
        return AttendanceActionResult(
          isSuccess: false,
          message: "You have already recorded attendance for today.",
        );
      }

      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final hasPendingCheckInToday = _pendingEvents.any(
        (e) => e.eventType == 'check_in' && e.date == todayStr,
      );
      if (hasPendingCheckInToday) {
        return AttendanceActionResult(
          isSuccess: false,
          message: "A check-in event is already pending synchronization for today.",
        );
      }

      // Geofence validation (200m)
      final locationResult = await LocationService.getCurrentCoordinates();
      if (!locationResult.isSuccess) {
        return AttendanceActionResult(
          isSuccess: false,
          message: locationResult.errorMessage ?? "Failed to acquire location.",
        );
      }

      if (!locationResult.isWithinGeofence) {
        return AttendanceActionResult(
          isSuccess: false,
          message: locationResult.errorMessage ??
              "You are outside the permitted office attendance area (max 200m).",
        );
      }

      final now = DateTime.now();
      final idempotencyKey = "evt_${now.millisecondsSinceEpoch}_${now.microsecond}";
      final formattedTime = DateFormat('hh:mm a').format(now);

      final event = AttendanceEvent(
        idempotencyKey: idempotencyKey,
        eventType: 'check_in',
        timestamp: now.toUtc().toIso8601String(),
        latitude: locationResult.latitude!,
        longitude: locationResult.longitude!,
        syncStatus: AttendanceSyncStatus.pending,
        date: todayStr,
      );

      _todayStatus = 'checked_in';
      _checkInTime = formattedTime;
      _checkInDateTime = now;
      _updateElapsedTimer();

      await LocalStorageService.addPendingEvent(event);
      await LocalStorageService.saveTodayAttendance({
        'date': todayStr,
        'today_status': 'checked_in',
        'check_in_time': formattedTime,
        'check_out_time': null,
        'check_in_timestamp': now.toIso8601String(),
      });

      _loadFromLocalStorage();

      final isOnline = await InternetConnection().hasInternetAccess;
      if (isOnline) {
        final syncResult = await SyncService().syncPendingEvents();
        _loadFromLocalStorage();
        return AttendanceActionResult(
          isSuccess: true,
          message: syncResult.syncedCount > 0
              ? "Checked in successfully at $formattedTime (Online)."
              : "Checked in at $formattedTime (Saved offline - Pending Sync).",
          isSavedOffline: syncResult.syncedCount == 0,
        );
      } else {
        return AttendanceActionResult(
          isSuccess: true,
          message: "Checked in at $formattedTime (Saved offline - Pending Sync).",
          isSavedOffline: true,
        );
      }
    } catch (e) {
      log("Check-in error: $e");
      return AttendanceActionResult(
        isSuccess: false,
        message: "An unexpected error occurred: ${e.toString()}",
      );
    } finally {
      _isProcessingAction = false;
      notifyListeners();
    }
  }

  /// Perform Check-Out using real API or local queue if offline
  Future<AttendanceActionResult> performCheckOut() async {
    if (_isProcessingAction) {
      return AttendanceActionResult(
        isSuccess: false,
        message: "An action is already in progress.",
      );
    }

    _isProcessingAction = true;
    notifyListeners();

    try {
      if (_todayStatus != 'checked_in') {
        return AttendanceActionResult(
          isSuccess: false,
          message: "Check-out is only permitted after check-in.",
        );
      }

      final locationResult = await LocationService.getCurrentCoordinates();
      if (!locationResult.isSuccess) {
        return AttendanceActionResult(
          isSuccess: false,
          message: locationResult.errorMessage ?? "Failed to acquire location.",
        );
      }

      if (!locationResult.isWithinGeofence) {
        return AttendanceActionResult(
          isSuccess: false,
          message: locationResult.errorMessage ??
              "You are outside the permitted office attendance area (max 200m).",
        );
      }

      final now = DateTime.now();
      final idempotencyKey = "evt_${now.millisecondsSinceEpoch}_${now.microsecond}";
      final formattedTime = DateFormat('hh:mm a').format(now);
      final todayStr = DateFormat('yyyy-MM-dd').format(now);

      final event = AttendanceEvent(
        idempotencyKey: idempotencyKey,
        eventType: 'check_out',
        timestamp: now.toUtc().toIso8601String(),
        latitude: locationResult.latitude!,
        longitude: locationResult.longitude!,
        syncStatus: AttendanceSyncStatus.pending,
        date: todayStr,
      );

      final duration = _checkInDateTime != null
          ? now.difference(_checkInDateTime!)
          : const Duration(hours: 8);
      final durationStr = "${duration.inHours}h ${duration.inMinutes % 60}m";

      _todayStatus = 'checked_out';
      _checkOutTime = formattedTime;
      _elapsedTimer?.cancel();

      _records.insert(
        0,
        AttendanceRecord(
          id: idempotencyKey,
          date: todayStr,
          checkIn: _checkInTime,
          checkOut: formattedTime,
          duration: durationStr,
          syncStatus: AttendanceSyncStatus.pending,
        ),
      );

      await LocalStorageService.addPendingEvent(event);
      await LocalStorageService.saveAttendanceHistory(_records);
      await LocalStorageService.saveTodayAttendance({
        'date': todayStr,
        'today_status': 'checked_out',
        'check_in_time': _checkInTime,
        'check_out_time': formattedTime,
        'check_in_timestamp': _checkInDateTime?.toIso8601String(),
        'duration': durationStr,
      });

      _loadFromLocalStorage();

      final isOnline = await InternetConnection().hasInternetAccess;
      if (isOnline) {
        final syncResult = await SyncService().syncPendingEvents();
        _loadFromLocalStorage();
        return AttendanceActionResult(
          isSuccess: true,
          message: syncResult.syncedCount > 0
              ? "Checked out successfully at $formattedTime (Online)."
              : "Checked out at $formattedTime (Saved offline - Pending Sync).",
          isSavedOffline: syncResult.syncedCount == 0,
        );
      } else {
        return AttendanceActionResult(
          isSuccess: true,
          message: "Checked out at $formattedTime (Saved offline - Pending Sync).",
          isSavedOffline: true,
        );
      }
    } catch (e) {
      log("Check-out error: $e");
      return AttendanceActionResult(
        isSuccess: false,
        message: "An unexpected error occurred: ${e.toString()}",
      );
    } finally {
      _isProcessingAction = false;
      notifyListeners();
    }
  }

  /// Manual "Sync Now" action
  Future<SyncResult> triggerManualSync() async {
    final result = await SyncService().syncPendingEvents();
    _loadFromLocalStorage();
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    SyncService().removeListener(_onSyncUpdate);
    super.dispose();
  }
}
