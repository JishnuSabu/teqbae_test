import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/common/auth/login_model.dart';

class AuthService {
  static Future<LoginModel?> loginService({
    required String userName,
    required String password,
  }) async {
    try {
      var formDataMap = {"user_name": userName, "password": password};
      log("passed se login data -: $formDataMap");
      FormData formData = FormData.fromMap(formDataMap);
      var response = await DioClient().post(Endpoints.login, data: formData);
      log("login api: ${Endpoints.login}");

      if (response is! Map<String, dynamic>) {
        throw ServerException(message: "Unexpected response format.");
      }
      LoginModel model = LoginModel.fromJson(response);
      return model;
    } on DioException catch (e) {
      log("DioException in login request: ${e.response?.statusCode}");
      log("Error message in login request: ${e.response?.data}");
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      log("Unexpected error in login request: $e");
      throw ServerException(message: "Unexpected error: ${e.toString()}");
    }
  }

  //!reset password service
  // static Future<StatusModel?> resetPasswordService({
  //   required String oldPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     var formDataMap = {
  //       "current_password": oldPassword,
  //       "password": newPassword,
  //     };
  //     log("passed se reset password data -: $formDataMap");
  //     FormData formData = FormData.fromMap(formDataMap);
  //     var response = await DioClient().post(
  //       Endpoints.resetPassword,
  //       data: formData,
  //     );
  //     log("reset password api: ${Endpoints.resetPassword}");

  //     if (response is! Map<String, dynamic>) {
  //       throw ServerException(message: "Unexpected response format.");
  //     }
  //     StatusModel model = StatusModel.fromJson(response);
  //     return model;
  //   } on DioException catch (e) {
  //     log("DioException in reset password request: ${e.response?.statusCode}");
  //     log("Error message in reset password request: ${e.response?.data}");
  //     rethrow;
  //   } on ServerException {
  //     rethrow;
  //   } catch (e) {
  //     log("Unexpected error in reset password request: $e");
  //     throw ServerException(message: "Unexpected error: ${e.toString()}");
  //   }
  // }
}
