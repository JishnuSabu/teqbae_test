import 'dart:developer';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/employee/employee_model.dart';

class EmployeeService {
  static Future<EmployeeModel?> getEmployeeProfile() async {
    try {
      final response = await DioClient().get(Endpoints.employeeMe);
      log('Response of api employee/me: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in employee/me',
        );
      }
      return EmployeeModel.fromJson(response);
    } catch (e) {
      log("Error in getEmployeeProfile: $e");
      rethrow;
    }
  }
}
