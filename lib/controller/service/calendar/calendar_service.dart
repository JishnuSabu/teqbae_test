import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/calendar/holidays_model.dart';

class CalendarService {
  static Future<HolidaysModel?> calendarHolidaysService({String? year}) async {
    try {
      Map<String, dynamic> body = {"year": year ?? ""};
      log("passed holidays data -: $body");
      // var response = await DioClient().post(Endpoints.holidays, data: body);
      var response = await DioClient().get(Endpoints.holidays);
      log("holidays API Response   = = = = = = = = = = = = : $response");
      log('Response of api holidays: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(message: 'Invalid response format in holidays');
      }
      final model = HolidaysModel.fromJson(response);
      log("Parsed holidays Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in holidays: ${e.response?.statusCode}');
      log('Error message in holidays: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in holidays: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
