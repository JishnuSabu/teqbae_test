import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/common/status/status_model.dart';
import 'package:teqbae_test/model/help/departments_model.dart';
import 'package:teqbae_test/model/help/help_tickets_list_model.dart';

class HelpService {
  static Future<DepartmentsModel?> departmentsListService() async {
    try {
      var response = await DioClient().get(Endpoints.departmentsList);
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api department list request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in department list request',
        );
      }
      final model = DepartmentsModel.fromJson(response);
      log("Parsed department list Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in department list request: ${e.response?.statusCode}');
      log('Error message in department list request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in department list request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<StatusModel?> helpTicketsCreateService({
    required String subject,
    required String departmentId,
    required String description,
    dynamic files,
    String priority = 'Low',
  }) async {
    try {
      Map<String, dynamic> body = {
        "subject": subject,
        "department_id": departmentId,
        "description": description,
        "priority": priority.toLowerCase(),
      };

      log("passed help ticket  create data -: $body");
      FormData formData = FormData.fromMap(body);

      if (files != null) {
        if (files is List<String> && files.isNotEmpty) {
          for (String path in files) {
            if (path.isNotEmpty) {
              formData.files.add(
                MapEntry(
                  "files[]",
                  await MultipartFile.fromFile(
                    path,
                    filename: path.split('/').last,
                  ),
                ),
              );
            }
          }
        } else if (files is String && files.isNotEmpty) {
          formData.files.add(
            MapEntry(
              "files[]",
              await MultipartFile.fromFile(
                files,
                filename: files.split('/').last,
              ),
            ),
          );
        }
      }
      var response = await DioClient().post(
        Endpoints.helpTicketCreate,
        data: formData,
      );
      log("leave request API Response   = = = = = = = = = = = = : $response");
      log('Response of api help ticket create: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in help ticket  create',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed help ticket  create Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in help ticket  createt: ${e.response?.statusCode}');
      log('Error message in help ticket  create: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in help ticket  create: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<HelpTicketsListModel?> helpTicketsListService({
    String? search,
  }) async {
    try {
      Map<String, dynamic> body = {"search": search ?? ""};
      log("passed help ticket list data -: $body");
      var response = await DioClient().post(
        Endpoints.helpTicketList,
        data: body,
      );
      log(
        "help ticket list API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api help ticket list: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in help ticket list',
        );
      }
      final model = HelpTicketsListModel.fromJson(response);
      log("Parsed help ticket list details Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in help ticket list: ${e.response?.statusCode}');
      log('Error message in help ticket list: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in help ticket list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
