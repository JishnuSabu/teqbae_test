import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/payslip/payslip_current_month_data_model.dart';
import 'package:teqbae_test/model/payslip/payslip_detail_model.dart';
import 'package:teqbae_test/model/payslip/payslip_list_model.dart';

class PayrollService {
  static Future<PayslipCurrentMonthDataModel?>
  paySlipCurrentMonthDataService() async {
    try {
      var response = await DioClient().get(Endpoints.payRollCurrentMonthData);
      log('Response of api  payslip current month data: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in payslip current month data',
        );
      }
      final model = PayslipCurrentMonthDataModel.fromJson(response);
      log("Parsed  payslip current month data Model: $model");
      return model;
    } on DioException catch (e) {
      log(
        'DioException in  payslip current month data: ${e.response?.statusCode}',
      );
      log('Error message in payslip current month data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  payslip current month data: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<PayslipListModel?> payRollListService({
    required String limit,
  }) async {
    try {
      Map<String, dynamic> body = {"limit": limit};
      // log("passed  attendance summary data -: $body");
      var response = await DioClient().post(Endpoints.payRollList, data: body);
      log('Response of api payslip list: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in  payslip list',
        );
      }
      final model = PayslipListModel.fromJson(response);
      log("Parsed  payslip list: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  payslip list: ${e.response?.statusCode}');
      log('Error message in  payslip list: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  payslip list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<PayslipDetailsModel?> paySlipDetailsService({
    required String paySlipId,
  }) async {
    try {
      var response = await DioClient().get(
        "${Endpoints.paySlipDetails}$paySlipId",
      );
      log('Response of api payslip details: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in  payslip details',
        );
      }
      final model = PayslipDetailsModel.fromJson(response);
      log("Parsed  payslip details: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  payslip details: ${e.response?.statusCode}');
      log('Error message in  payslip details: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  payslip details: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
