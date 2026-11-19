import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:teqbae_test/controller/service/attendance/attendance_service.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/model/attendance/attendance_event.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';

class SyncResult {
  final int totalCount;
  final int syncedCount;
  final int rejectedCount;
  final int remainingCount;
  final String message;

  SyncResult({
    required this.totalCount,
    required this.syncedCount,
    required this.rejectedCount,
    required this.remainingCount,
    required this.message,
  });
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;

  SyncService._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final l in _listeners) {
      l();
    }
  }

  /// Initialize connectivity listener for auto-sync when network returns
  void initConnectivityMonitor({required Future<void> Function() onAutoSync}) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      final isConnected = results.any(
        (r) =>
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.wifi ||
            r == ConnectivityResult.ethernet,
      );

      log("📶 [SyncService] Connectivity change detected: isConnected=$isConnected");
      if (isConnected) {
        final pending = LocalStorageService.getPendingEvents();
        if (pending.isNotEmpty) {
          log("🔄 [SyncService] Internet restored with ${pending.length} pending events. Initiating auto-sync...");
          await onAutoSync();
        }
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _listeners.clear();
  }

  /// Synchronize all pending events in strict FIFO order using POST /attendance/events
  Future<SyncResult> syncPendingEvents() async {
    if (_isSyncing) {
      log("⏳ [SyncService] Sync already in progress, skipping concurrent call.");
      return SyncResult(
        totalCount: 0,
        syncedCount: 0,
        rejectedCount: 0,
        remainingCount: 0,
        message: "Sync already in progress",
      );
    }

    _isSyncing = true;
    _notifyListeners();

    int syncedCount = 0;
    int rejectedCount = 0;
    final List<AttendanceEvent> pendingEvents =
        LocalStorageService.getPendingEvents();

    // Sort strictly by timestamp ascending (FIFO order: check-in before check-out)
    pendingEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final totalCount = pendingEvents.length;
    log("🔄 [SyncService] Starting sync for $totalCount pending events (FIFO order)");

    final List<AttendanceEvent> remainingEvents = List.from(pendingEvents);
    final List<AttendanceRecord> currentHistory =
        LocalStorageService.getAttendanceHistory();

    try {
      for (final event in pendingEvents) {
        try {
          final response = await AttendanceService.sendAttendanceEvent(event.toJson());

          if (response != null && response['status'] == true) {
            syncedCount++;
            remainingEvents
                .removeWhere((e) => e.idempotencyKey == event.idempotencyKey);

            final historyIndex = currentHistory.indexWhere(
              (r) => r.id == event.idempotencyKey || r.date == event.date,
            );
            if (historyIndex >= 0) {
              currentHistory[historyIndex] =
                  currentHistory[historyIndex].copyWith(
                syncStatus: AttendanceSyncStatus.synced,
              );
            }
            log("✅ [SyncService] Event ${event.eventType} (${event.idempotencyKey}) SYNCED");
          } else {
            // Check for server conflict
            final msg = (response?['message']?.toString() ?? '').toLowerCase();
            if (msg.contains('already') || msg.contains('conflict')) {
              rejectedCount++;
              remainingEvents
                  .removeWhere((e) => e.idempotencyKey == event.idempotencyKey);
              final historyIndex = currentHistory.indexWhere(
                (r) => r.id == event.idempotencyKey || r.date == event.date,
              );
              if (historyIndex >= 0) {
                currentHistory[historyIndex] =
                    currentHistory[historyIndex].copyWith(
                  syncStatus: AttendanceSyncStatus.rejected,
                );
              }
              log("❌ [SyncService] Event ${event.eventType} REJECTED due to conflict: $msg");
            } else {
              log("⚠️ [SyncService] Event returned failure: $msg. Halting batch to preserve ordering.");
              break;
            }
          }
        } on DioException catch (dioErr) {
          if (dioErr.response?.statusCode == 409) {
            rejectedCount++;
            remainingEvents
                .removeWhere((e) => e.idempotencyKey == event.idempotencyKey);
            final historyIndex = currentHistory.indexWhere(
              (r) => r.id == event.idempotencyKey || r.date == event.date,
            );
            if (historyIndex >= 0) {
              currentHistory[historyIndex] =
                  currentHistory[historyIndex].copyWith(
                syncStatus: AttendanceSyncStatus.rejected,
              );
            }
            log("❌ [SyncService] Event ${event.eventType} REJECTED due to 409 Conflict");
          } else {
            log("⚠️ [SyncService] Dio error (${dioErr.response?.statusCode}): $dioErr");
            break;
          }
        } catch (e) {
          log("⚠️ [SyncService] Network/Timeout error while syncing ${event.idempotencyKey}: $e");
          break;
        }
      }

      // Persist updated remaining pending queue and updated history
      await LocalStorageService.savePendingEvents(remainingEvents);
      await LocalStorageService.saveAttendanceHistory(currentHistory);
    } finally {
      _isSyncing = false;
      _notifyListeners();
    }

    final message = totalCount == 0
        ? "No pending events to sync."
        : "Sync completed: $syncedCount synced, $rejectedCount rejected, ${remainingEvents.length} remaining.";

    log("🏁 [SyncService] $message");
    return SyncResult(
      totalCount: totalCount,
      syncedCount: syncedCount,
      rejectedCount: rejectedCount,
      remainingCount: remainingEvents.length,
      message: message,
    );
  }
}
