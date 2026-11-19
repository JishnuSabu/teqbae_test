import 'dart:developer';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/leave/leave_balance_model.dart';
import 'package:teqbae_test/model/leave/leave_request_model.dart';

class LeaveService {
  /// GET /leave/balance
  static Future<LeaveBalanceModel?> getLeaveBalance() async {
    try {
      final response = await DioClient().get(Endpoints.leaveBalance);
      log('Response of api leave/balance: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in leave/balance',
        );
      }
      return LeaveBalanceModel.fromJson(response);
    } catch (e) {
      log("Error in getLeaveBalance: $e");
      rethrow;
    }
  }

  /// GET /leave/requests
  static Future<List<LeaveRequestModel>> getLeaveRequests() async {
    try {
      final response = await DioClient().get(Endpoints.leaveRequests);
      log('Response of api leave/requests: $response');
      if (response is Map<String, dynamic> && response['requests'] is List) {
        return (response['requests'] as List)
            .map((r) => LeaveRequestModel.fromJson(r as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log("Error in getLeaveRequests: $e");
      rethrow;
    }
  }

  /// POST /leave/requests
  static Future<Map<String, dynamic>?> submitLeaveRequest(
    Map<String, dynamic> requestData,
  ) async {
    try {
      log("Submitting leave request: $requestData");
      final response = await DioClient().post(
        Endpoints.leaveRequests,
        data: requestData,
      );
      log('Response of api leave/requests: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in leave/requests',
        );
      }
      return response;
    } catch (e) {
      log("Error in submitLeaveRequest: $e");
      rethrow;
    }
  }
}
