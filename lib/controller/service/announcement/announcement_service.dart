import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/announcement/announcement_model.dart';
import 'package:teqbae_test/model/common/status/status_model.dart';

class AnnouncementService {
  static Future<AnnouncementModel?> announcementListService({
    String? search,
  }) async {
    try {
      Map<String, dynamic> body = {"search": search ?? ""};
      log("passed announcement list data -: $body");
      var response = await DioClient().post(
        Endpoints.announcementList,
        data: body,
      );
      log(
        "announcement list API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api announcement list: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in announcement list',
        );
      }
      final model = AnnouncementModel.fromJson(response);
      log("Parsed announcement list details Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in announcement list: ${e.response?.statusCode}');
      log('Error message in announcement list: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in announcement list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<StatusModel?> managerAnnouncementCreateApi({
    required String subject,
    required String description,
    // required String date,
    required dynamic files,
  }) async {
    try {
      Map<String, dynamic> body = {
        "name": subject,
        "description": description,
        // "date": date,
      };

      log("passed announcement create data -: $body");
      FormData formData = FormData.fromMap(body);

      if (files.isNotEmpty) {
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
        Endpoints.managerAnnouncementCreate,
        data: formData,
      );
      log(
        "announcement create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api announcement create: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in announcement create',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed announcement create Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in announcement  createt: ${e.response?.statusCode}');
      log('Error message in announcement  create: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in announcement  create: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
