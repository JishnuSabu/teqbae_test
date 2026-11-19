import 'dart:developer';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';

class AttendanceService {
  /// GET /attendance?month=YYYY-MM
  static Future<Map<String, dynamic>?> getAttendance({String? month}) async {
    try {
      final query = month != null ? {'month': month} : null;
      final response = await DioClient().get(
        Endpoints.attendance,
        queryParameters: query,
      );
      log('Response of api attendance: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(message: 'Invalid response format in attendance');
      }
      return response;
    } catch (e) {
      log("Error in getAttendance: $e");
      rethrow;
    }
  }

  /// POST /attendance/events
  static Future<Map<String, dynamic>?> sendAttendanceEvent(
    Map<String, dynamic> data,
  ) async {
    try {
      log("Sending attendance event: $data");
      final response = await DioClient().post(
        Endpoints.attendanceEvents,
        data: data,
      );
      log('Response of api attendance/events: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in attendance/events',
        );
      }
      return response;
    } catch (e) {
      log("Error in sendAttendanceEvent: $e");
      rethrow;
    }
  }
}
