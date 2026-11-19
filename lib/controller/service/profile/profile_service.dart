import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/common/settings/profile-picture_model.dart';
import 'package:teqbae_test/model/common/settings/profile_info_model.dart';

class ProfileService {
  static Future<EmployeeProfileInfoModel?> profileInfoService() async {
    try {
      var response = await DioClient().get(Endpoints.employeeProfileInfo);
      log('Response of api profile info: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in profile info',
        );
      }
      final model = EmployeeProfileInfoModel.fromJson(response);
      log("Parsed profile info Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  profile info: ${e.response?.statusCode}');
      log('Error message in  profile info: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  profile info: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  // update profile picture

  static Future<ProfilePictureModel?> updateProfilePictureService({
    required File image,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      };
      FormData formData = FormData.fromMap(body);
      log("passed se update profile picture data -: $body");
      var response = await DioClient().post(
        Endpoints.updateProfilePicture,
        data: formData,
      );
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api update profile picture: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in update profile picture',
        );
      }
      final model = ProfilePictureModel.fromJson(response);
      log("Parsed  update profile picture details Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  update profile picture: ${e.response?.statusCode}');
      log('Error message in  update profile picture: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  update profile picture: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
