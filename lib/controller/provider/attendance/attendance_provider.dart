import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teqbae_test/controller/service/attendance/attendance_service.dart';
import 'package:teqbae_test/core/network/api_response.dart';
import 'package:teqbae_test/core/network/mock_http_server.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/core/services/location_service.dart';
import 'package:teqbae_test/core/sync/sync_service.dart';
import 'package:teqbae_test/model/attendance/attendance_event.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';

class AttendanceActionResult {
  final bool isSuccess;
  final String message;
  final bool isSavedOffline;
  final bool isLocationDisabled;

  AttendanceActionResult({
    required this.isSuccess,
    required this.message,
    this.isSavedOffline = false,
    this.isLocationDisabled = false,
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

  // Last captured GPS coordinates
  double? _lastCheckInLatitude;
  double? _lastCheckInLongitude;
  double? get lastCheckInLatitude => _lastCheckInLatitude;
  double? get lastCheckInLongitude => _lastCheckInLongitude;

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
    _records = LocalStorageService.getAttendanceHistory()
        .where((r) => r.id != 'att-001' && r.id != 'att-002')
        .toList();

    final todayDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final todayData = LocalStorageService.getTodayAttendance();
    if (todayData != null) {
      final savedDate = todayData['date']?.toString();
      if (savedDate == todayDateStr) {
        _todayStatus =
            todayData['today_status']?.toString() ?? 'not_checked_in';
        _checkInTime = todayData['check_in_time']?.toString();
        _checkOutTime = todayData['check_out_time']?.toString();

        final checkInTimestamp = todayData['check_in_timestamp']?.toString();
        if (checkInTimestamp != null && checkInTimestamp.isNotEmpty) {
          _checkInDateTime = DateTime.tryParse(checkInTimestamp)?.toLocal();
        }
      } else {
        // New day — reset today's state but keep history
        _todayStatus = 'not_checked_in';
        _checkInTime = null;
        _checkOutTime = null;
        _checkInDateTime = null;
      }
    }

    // If today status is not checked in, check if history has today's record
    if (_todayStatus == 'not_checked_in') {
      final todayRecordIndex =
          _records.indexWhere((r) => r.date == todayDateStr);
      if (todayRecordIndex >= 0) {
        final rec = _records[todayRecordIndex];
        if (rec.checkOut != null && rec.checkOut!.isNotEmpty) {
          _todayStatus = 'checked_out';
          _checkInTime = rec.checkIn;
          _checkOutTime = rec.checkOut;
        } else if (rec.checkIn != null && rec.checkIn!.isNotEmpty) {
          _todayStatus = 'checked_in';
          _checkInTime = rec.checkIn;
        }
      }
    }

    // Also hydrate today's status from pending events if any
    if (_todayStatus == 'not_checked_in' && _pendingEvents.isNotEmpty) {
      final todayEvents =
          _pendingEvents.where((e) => e.date == todayDateStr).toList()
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      if (todayEvents.isNotEmpty) {
        final lastEvent = todayEvents.last;
        if (lastEvent.eventType == 'check_in') {
          _todayStatus = 'checked_in';
          _checkInDateTime ??=
              DateTime.tryParse(lastEvent.timestamp)?.toLocal();
          _checkInTime ??= _checkInDateTime != null
              ? DateFormat('hh:mm a').format(_checkInDateTime!)
              : null;
        } else if (lastEvent.eventType == 'check_out') {
          _todayStatus = 'checked_out';
          final checkInEvent = todayEvents.firstWhere(
              (e) => e.eventType == 'check_in',
              orElse: () => lastEvent);
          _checkInDateTime ??=
              DateTime.tryParse(checkInEvent.timestamp)?.toLocal();
          _checkInTime ??= _checkInDateTime != null
              ? DateFormat('hh:mm a').format(_checkInDateTime!)
              : null;
          final checkOutDt =
              DateTime.tryParse(lastEvent.timestamp)?.toLocal();
          _checkOutTime ??= checkOutDt != null
              ? DateFormat('hh:mm a').format(checkOutDt)
              : null;
        }
      }
    }

    final nonSeeds = _records.where((r) => !r.id.startsWith('seed-att-')).toList();
    final seeds = MockHttpServer.buildSeedRecords()
        .map((e) => AttendanceRecord.fromJson(e))
        .toList();
    final bool hasToday = _todayStatus == 'checked_in' ||
        _todayStatus == 'checked_out' ||
        nonSeeds.any((r) => r.date == todayDateStr);
    _records = [...nonSeeds, ...seeds].take(hasToday ? 5 : 4).toList();

    _updateElapsedTimer();
  }

  void _updateElapsedTimer() {
    _elapsedTimer?.cancel();
    if (_todayStatus == 'checked_in' && _checkInDateTime != null) {
      _elapsedWorkingDuration = DateTime.now().difference(_checkInDateTime!);
      if (_elapsedWorkingDuration.isNegative) {
        _elapsedWorkingDuration = Duration.zero;
      }
      _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_checkInDateTime != null) {
          _elapsedWorkingDuration =
              DateTime.now().difference(_checkInDateTime!);
          if (_elapsedWorkingDuration.isNegative) {
            _elapsedWorkingDuration = Duration.zero;
          }
          notifyListeners();
        }
      });
    } else {
      _elapsedWorkingDuration = Duration.zero;
    }
  }

  /// Fetch latest attendance history and today's status from mock API.
  /// Cache-first strategy: local today data wins over server when
  /// the server has less information (e.g. after a mock-server restart).
  Future<void> fetchAttendanceHistory() async {
    attendanceHistoryResponse = ApiResponse.loading();
    notifyListeners();

    // Always load from cache first so UI is instant
    _loadFromLocalStorage();

    try {
      final data = await AttendanceService.getAttendance();
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (data != null) {
        // ── Today's status ──
        if (data['today'] is Map<String, dynamic>) {
          final today = data['today'] as Map<String, dynamic>;
          final serverStatus =
              today['today_status']?.toString() ?? 'not_checked_in';

          final serverHasData = serverStatus == 'checked_in' ||
              serverStatus == 'checked_out';

          if (serverHasData) {
            _todayStatus = serverStatus;
            _checkInTime = today['check_in_time']?.toString() ?? _checkInTime;
            _checkOutTime =
                today['check_out_time']?.toString() ?? _checkOutTime;
            final serverTs = today['check_in_timestamp']?.toString();
            if (serverTs != null && serverTs.isNotEmpty) {
              _checkInDateTime =
                  DateTime.tryParse(serverTs)?.toLocal() ?? _checkInDateTime;
            }
          }
        }

        // ── Attendance history: merge server records with local today record ──
        if (data['records'] is List) {
          final serverRecords = (data['records'] as List)
              .map((item) =>
                  AttendanceRecord.fromJson(item as Map<String, dynamic>))
              .where((r) => r.id != 'att-001' && r.id != 'att-002')
              .toList();

          final todayRecordIndex =
              _records.indexWhere((r) => r.date == todayStr);
          AttendanceRecord? localTodayRecord;
          if (todayRecordIndex >= 0) {
            localTodayRecord = _records[todayRecordIndex];
          }

          serverRecords.removeWhere((r) => r.date == todayStr);

          if (localTodayRecord != null) {
            _records = [localTodayRecord, ...serverRecords];
          } else {
            _records = serverRecords;
          }

          final bool hasToday = localTodayRecord != null ||
              _todayStatus == 'checked_in' ||
              _todayStatus == 'checked_out';
          _records = _records.take(hasToday ? 5 : 4).toList();

          await LocalStorageService.saveAttendanceHistory(_records);
        }
      }

      // Persist the reconciled today data
      await LocalStorageService.saveTodayAttendance({
        'date': todayStr,
        'today_status': _todayStatus,
        'check_in_time': _checkInTime,
        'check_out_time': _checkOutTime,
        'check_in_timestamp': _checkInDateTime?.toIso8601String(),
        'duration': _todayStatus == 'checked_out'
            ? (_records.isNotEmpty ? _records.first.duration : null)
            : (_todayStatus == 'checked_in' ? 'In Progress' : null),
      });

      _updateElapsedTimer();
      attendanceHistoryResponse = ApiResponse.success(_records);
    } catch (e) {
      log("AttendanceProvider fetchAttendanceHistory error: $e");
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
          isLocationDisabled: locationResult.isServiceDisabled,
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
      _lastCheckInLatitude = locationResult.latitude;
      _lastCheckInLongitude = locationResult.longitude;
      _updateElapsedTimer();

      // Immediately add/update today's record in history
      final todayRecord = AttendanceRecord(
        id: idempotencyKey,
        date: todayStr,
        checkIn: formattedTime,
        checkOut: null,
        duration: "In Progress",
        syncStatus: AttendanceSyncStatus.pending,
      );
      _records.removeWhere((r) => r.date == todayStr);
      _records.insert(0, todayRecord);
      _records = _records.take(5).toList();

      await LocalStorageService.addPendingEvent(event);
      await LocalStorageService.saveAttendanceHistory(_records);
      await LocalStorageService.saveTodayAttendance({
        'date': todayStr,
        'today_status': 'checked_in',
        'check_in_time': formattedTime,
        'check_out_time': null,
        'check_in_timestamp': now.toIso8601String(),
        'duration': "In Progress",
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
          isLocationDisabled: locationResult.isServiceDisabled,
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

      Duration duration = Duration.zero;
      if (_checkInDateTime != null) {
        duration = now.difference(_checkInDateTime!);
        if (duration.isNegative) duration = Duration.zero;
      }
      final durationStr = "${duration.inHours}h ${duration.inMinutes % 60}m";

      _todayStatus = 'checked_out';
      _checkOutTime = formattedTime;
      _elapsedTimer?.cancel();
      _elapsedWorkingDuration = duration;

      final todayRecord = AttendanceRecord(
        id: idempotencyKey,
        date: todayStr,
        checkIn: _checkInTime,
        checkOut: formattedTime,
        duration: durationStr,
        syncStatus: AttendanceSyncStatus.pending,
      );
      _records.removeWhere((r) => r.date == todayStr);
      _records.insert(0, todayRecord);
      _records = _records.take(5).toList();

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
