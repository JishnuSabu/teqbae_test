import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';
import 'package:teqbae_test/model/attendance/attendance_record.dart';
import 'package:teqbae_test/model/leave/leave_balance_model.dart';
import 'package:teqbae_test/model/leave/leave_request_model.dart';

enum MockScenario {
  normal,
  slow,
  timeout,
  serverError,
  duplicateConflict,
  leaveRejection,
}

class MockHttpServer {
  static HttpServer? _server;
  static int _port = 8085;
  static MockScenario activeScenario = MockScenario.normal;

  static String get baseUrl => 'http://127.0.0.1:$_port';
  static bool get isRunning => _server != null;

  // In-memory data store
  static Map<String, dynamic> employeeData = {
    "id": "EMP-0428",
    "name": "Alex Morgan",
    "department": "Engineering",
    "designation": "Senior Flutter Developer",
    "office": {
      "name": "REBS Headquarters",
      "latitude": 12.9716,
      "longitude": 77.5946,
      "radius_meters": 200.0,
      "timezone": "Asia/Kolkata",
    },
  };

  static Map<String, dynamic> todayAttendance = {
    "today_status": "not_checked_in",
    "check_in_time": null,
    "check_out_time": null,
    "check_in_timestamp": null,
    "check_out_timestamp": null,
  };

  static List<Map<String, dynamic>> buildSeedRecords() {
    final now = DateTime.now();
    final records = <Map<String, dynamic>>[];
    final checkIns = ['09:05 AM', '09:12 AM', '09:02 AM', '08:58 AM'];
    final checkOuts = ['06:10 PM', '06:05 PM', '06:15 PM', '06:00 PM'];
    final durations = ['9h 5m', '8h 53m', '9h 13m', '9h 2m'];
    int dayOffset = 1;
    while (records.length < 4) {
      final day = now.subtract(Duration(days: dayOffset));
      dayOffset++;
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        continue;
      }
      final idx = records.length;
      records.add({
        'id': 'seed-att-${idx + 1}',
        'date': DateFormat('yyyy-MM-dd').format(day),
        'check_in': checkIns[idx],
        'check_out': checkOuts[idx],
        'duration': durations[idx],
        'sync_status': 'synced',
      });
    }
    return records;
  }

  static List<Map<String, dynamic>> attendanceRecords = buildSeedRecords();

  static final Set<String> processedIdempotencyKeys = {};

  static Map<String, dynamic> leaveBalance = {
    "casual": 10,
    "sick": 5,
    "total": 15,
  };

  static List<Map<String, dynamic>> leaveRequests = [];

  static void resetData() {
    activeScenario = MockScenario.normal;
    processedIdempotencyKeys.clear();
    todayAttendance = {
      "today_status": "not_checked_in",
      "check_in_time": null,
      "check_out_time": null,
      "check_in_timestamp": null,
      "check_out_timestamp": null,
    };
    leaveBalance = {
      "casual": 10,
      "sick": 5,
      "total": 15,
    };
    attendanceRecords = buildSeedRecords();
    log("🔄 [MockHttpServer] In-memory database reset to initial values.");
  }

  static void loadPersistedData() {
    try {
      final savedToday = LocalStorageService.getTodayAttendance();
      if (savedToday != null) {
        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        if (savedToday['date'] == todayStr) {
          todayAttendance = Map<String, dynamic>.from(savedToday);
        }
      }
      final savedHistory = LocalStorageService.getAttendanceHistory();
      if (savedHistory.isNotEmpty) {
        final filtered = savedHistory
            .where((r) => r.id != 'att-001' && r.id != 'att-002')
            .toList();
        // If there are seed records, ensure only 4 seed records exist
        final nonSeeds = filtered.where((r) => !r.id.startsWith('seed-att-')).toList();
        final seeds = buildSeedRecords().map((e) => AttendanceRecord.fromJson(e)).toList();
        final combined = [...nonSeeds, ...seeds].take(nonSeeds.isNotEmpty ? 5 : 4).toList();

        attendanceRecords = combined.map((r) => r.toJson()).toList();
        LocalStorageService.saveAttendanceHistory(combined);
      } else {
        attendanceRecords = buildSeedRecords();
      }
      final savedLeaveBalance = LocalStorageService.getLeaveBalance();
      if (savedLeaveBalance != null && savedLeaveBalance.total > 0) {
        leaveBalance = savedLeaveBalance.toJson();
      }
      final savedLeaveRequests = LocalStorageService.getLeaveRequests();
      if (savedLeaveRequests.isNotEmpty) {
        final realRequests = savedLeaveRequests
            .where((r) => r.id != 'req-001' && r.id != 'req-002')
            .toList();
        leaveRequests = realRequests.map((r) => r.toJson()).toList();
        LocalStorageService.saveLeaveRequests(realRequests);
      } else {
        leaveRequests = [];
      }
    } catch (e) {
      log("Error loading persisted mock data: $e");
    }
  }

  /// Start the local mock HTTP server
  static Future<void> start({int port = 8085}) async {
    loadPersistedData();
    if (_server != null) return;
    _port = port;

    try {
      _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        _port,
        shared: true,
      );
      log("🚀 [MockHttpServer] Running at http://127.0.0.1:$_port");

      _server!.listen((HttpRequest request) async {
        _handleRequest(request);
      });
    } catch (e) {
      log("⚠️ [MockHttpServer] Could not bind to port $_port: $e");
    }
  }

  static Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    log("🛑 [MockHttpServer] Stopped.");
  }

  static Future<void> _handleRequest(HttpRequest req) async {
    // Add CORS headers
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add(
      "Access-Control-Allow-Methods",
      "GET, POST, PUT, DELETE, OPTIONS",
    );
    req.response.headers.add(
      "Access-Control-Allow-Headers",
      "Origin, Content-Type, Authorization, Accept",
    );

    if (req.method == "OPTIONS") {
      req.response.statusCode = HttpStatus.ok;
      await req.response.close();
      return;
    }

    final path = req.uri.path;
    final method = req.method;

    log("📡 [MockHttpServer] $method $path (Scenario: ${activeScenario.name})");

    // Scenario handling: Slow delay
    if (activeScenario == MockScenario.slow) {
      await Future.delayed(const Duration(seconds: 4));
    }

    // Scenario handling: Timeout simulation
    if (activeScenario == MockScenario.timeout) {
      await Future.delayed(const Duration(seconds: 35));
    }

    // Scenario handling: Server error
    if (activeScenario == MockScenario.serverError &&
        !path.startsWith("/reviewer")) {
      _sendJson(
        req,
        HttpStatus.internalServerError,
        {"status": false, "message": "500 Internal Server Error (Simulated)"},
      );
      return;
    }

    // Body reading
    String bodyStr = "";
    if (method == "POST" || method == "PUT") {
      bodyStr = await utf8.decoder.bind(req).join();
    }
    Map<String, dynamic> bodyJson = {};
    if (bodyStr.isNotEmpty) {
      try {
        bodyJson = jsonDecode(bodyStr) as Map<String, dynamic>;
      } catch (_) {}
    }

    // Route matching
    try {
      // 1. GET /employee/me
      if (method == "GET" && path == "/employee/me") {
        _sendJson(req, HttpStatus.ok, employeeData);
        return;
      }

      // 2. GET /attendance
      if (method == "GET" && path == "/attendance") {
        _sendJson(req, HttpStatus.ok, {
          "status": true,
          "today": todayAttendance,
          "records": attendanceRecords,
        });
        return;
      }

      // 3. POST /attendance/events
      if (method == "POST" && path == "/attendance/events") {
        if (activeScenario == MockScenario.duplicateConflict) {
          _sendJson(
            req,
            HttpStatus.conflict,
            {
              "status": false,
              "message":
                  "409 Conflict: Attendance record already exists for today.",
            },
          );
          return;
        }

        final idempotencyKey = bodyJson['idempotency_key']?.toString();
        final eventType = bodyJson['event_type']?.toString();
        final timestampStr = bodyJson['timestamp']?.toString();

        if (idempotencyKey != null &&
            processedIdempotencyKeys.contains(idempotencyKey)) {
          // Idempotent retry: return success without duplicate insert
          _sendJson(req, HttpStatus.ok, {
            "status": true,
            "message": "Event already processed (Idempotent response).",
            "idempotency_key": idempotencyKey,
          });
          return;
        }

        final now = timestampStr != null
            ? DateTime.tryParse(timestampStr) ?? DateTime.now()
            : DateTime.now();
        final formattedTime = DateFormat('hh:mm a').format(now.toLocal());
        final todayStr = DateFormat('yyyy-MM-dd').format(now.toLocal());

        if (eventType == 'check_in') {
          if (todayAttendance['today_status'] == 'checked_in' ||
              todayAttendance['today_status'] == 'checked_out') {
            _sendJson(
              req,
              HttpStatus.conflict,
              {
                "status": false,
                "message": "Conflict: Already checked in for today.",
              },
            );
            return;
          }

          todayAttendance['today_status'] = 'checked_in';
          todayAttendance['check_in_time'] = formattedTime;
          todayAttendance['check_in_timestamp'] = now.toIso8601String();

          attendanceRecords.removeWhere((r) => r['date'] == todayStr);
          attendanceRecords.insert(0, {
            "id": idempotencyKey ?? "att_${now.millisecondsSinceEpoch}",
            "date": todayStr,
            "check_in": formattedTime,
            "check_out": null,
            "duration": "In Progress",
            "sync_status": "synced",
          });
          attendanceRecords = attendanceRecords.take(5).toList();
        } else if (eventType == 'check_out') {
          final checkInTs = todayAttendance['check_in_timestamp']?.toString();
          final checkInDt =
              checkInTs != null ? DateTime.tryParse(checkInTs) : null;
          final durationDiff =
              checkInDt != null ? now.difference(checkInDt) : Duration.zero;
          final durationStr =
              "${durationDiff.inHours}h ${durationDiff.inMinutes % 60}m";

          todayAttendance['today_status'] = 'checked_out';
          todayAttendance['check_out_time'] = formattedTime;
          todayAttendance['check_out_timestamp'] = now.toIso8601String();

          attendanceRecords.removeWhere((r) => r['date'] == todayStr);
          attendanceRecords.insert(0, {
            "id": idempotencyKey ?? "att_${now.millisecondsSinceEpoch}",
            "date": todayStr,
            "check_in": todayAttendance['check_in_time'] ?? formattedTime,
            "check_out": formattedTime,
            "duration": durationStr,
            "sync_status": "synced",
          });
          attendanceRecords = attendanceRecords.take(5).toList();
        }

        if (idempotencyKey != null) {
          processedIdempotencyKeys.add(idempotencyKey);
        }

        _sendJson(req, HttpStatus.created, {
          "status": true,
          "message": "$eventType recorded successfully.",
          "idempotency_key": idempotencyKey,
        });
        return;
      }

      // 4. GET /leave/balance
      if (method == "GET" && path == "/leave/balance") {
        _sendJson(req, HttpStatus.ok, leaveBalance);
        return;
      }

      // 5. GET /leave/requests
      if (method == "GET" && path == "/leave/requests") {
        _sendJson(req, HttpStatus.ok, {"requests": leaveRequests});
        return;
      }

      // 6. POST /leave/requests
      if (method == "POST" && path == "/leave/requests") {
        if (activeScenario == MockScenario.leaveRejection) {
          _sendJson(
            req,
            HttpStatus.unprocessableEntity,
            {
              "status": false,
              "message":
                  "422 Rejection: Department leave quota exceeded for this period.",
            },
          );
          return;
        }

        final leaveType = bodyJson['leave_type']?.toString() ?? 'Casual';
        final startDate = bodyJson['start_date']?.toString() ?? '';
        final endDate = bodyJson['end_date']?.toString() ?? '';
        final days = (bodyJson['days'] as num?)?.toInt() ?? 1;
        final reason = bodyJson['reason']?.toString() ?? '';

        final newRequest = {
          "id": "req-${DateTime.now().millisecondsSinceEpoch}",
          "leave_type": leaveType,
          "start_date": startDate,
          "end_date": endDate,
          "days": days,
          "reason": reason,
          "status": "Pending",
          "applied_at": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
        };

        leaveRequests.insert(0, newRequest);

        // Deduct balance
        if (leaveType.toLowerCase() == 'casual') {
          leaveBalance['casual'] =
              ((leaveBalance['casual'] as int) - days).clamp(0, 99);
        } else {
          leaveBalance['sick'] =
              ((leaveBalance['sick'] as int) - days).clamp(0, 99);
        }
        leaveBalance['total'] =
            (leaveBalance['casual'] as int) + (leaveBalance['sick'] as int);

        // Persist to local storage immediately
        await LocalStorageService.saveLeaveRequests(
          leaveRequests.map((e) => LeaveRequestModel.fromJson(e)).toList(),
        );
        await LocalStorageService.saveLeaveBalance(
          LeaveBalanceModel.fromJson(leaveBalance),
        );

        _sendJson(req, HttpStatus.created, {
          "status": true,
          "message": "Leave application submitted successfully.",
          "request": newRequest,
        });
        return;
      }

      // Reviewer control endpoints
      if (method == "POST" && path == "/reviewer/scenario") {
        final scenarioName = bodyJson['scenario']?.toString() ?? 'normal';
        activeScenario = MockScenario.values.firstWhere(
          (s) => s.name == scenarioName,
          orElse: () => MockScenario.normal,
        );
        _sendJson(req, HttpStatus.ok, {
          "status": true,
          "activeScenario": activeScenario.name,
        });
        return;
      }

      if (method == "POST" && path == "/reviewer/reset") {
        resetData();
        _sendJson(req, HttpStatus.ok, {
          "status": true,
          "message": "Database reset to initial mock state.",
        });
        return;
      }

      // Reviewer: set GPS simulation mode on the client
      // POST /reviewer/location  body: { "mode": "atOffice" | "outsideOffice" | "realGps" | "permissionDenied" | "permanentlyDenied" | "serviceDisabled" }
      if (method == "POST" && path == "/reviewer/location") {
        _sendJson(req, HttpStatus.ok, {
          "status": true,
          "message":
              "Location verification uses live device GPS with configurable office coordinates in Settings > Office Coordinates.",
          "available_modes": [
            "atOffice",
            "outsideOffice",
            "realGps",
            "permissionDenied",
            "permanentlyDenied",
            "serviceDisabled",
          ],
        });
        return;
      }

      // Fallback 404
      _sendJson(
        req,
        HttpStatus.notFound,
        {"status": false, "message": "Not Found: $method $path"},
      );
    } catch (e) {
      log("⚠️ [MockHttpServer] Handler error: $e");
      _sendJson(
        req,
        HttpStatus.internalServerError,
        {"status": false, "message": e.toString()},
      );
    }
  }

  static void _sendJson(HttpRequest req, int statusCode, dynamic data) {
    req.response.statusCode = statusCode;
    req.response.headers.contentType = ContentType.json;
    req.response.write(jsonEncode(data));
    req.response.close();
  }
}
