import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/common/status/status_model.dart';
import 'package:teqbae_test/model/forgot_password/forgot_password_otp_request_model.dart';

class ChangePasswordService {
  static Future<StatusModel?> changePswrdService({
    required String currentPswrd,
    required String newPswrd,
    required String cnfrmNewPswrd,
  }) async {
    try {
      Map<String, dynamic> body = {
        "current_password": currentPswrd,
        "new_password": newPswrd,
        "confirm_new_password": cnfrmNewPswrd,
      };
      log("passed change pswrd data -: $body");
      var response = await DioClient().post(Endpoints.changePswrd, data: body);
      log(
        "change pswrd request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api change pswrd request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in change pswrd request',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed change pswrd Model: $model");
      if (model.status == false) {
        throw ServerException(
          message: model.message ?? 'Failed to change password',
        );
      }
      return model;
    } on DioException catch (e) {
      log('DioException in change pswrd request: ${e.response?.statusCode}');
      log('Error message in change pswrd request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in change pswrd request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<ForgotPasswordOtpRequestModel?>
  forgotPasswordOtpRequestService({required String email}) async {
    try {
      Map<String, dynamic> body = {"email": email};
      log("passed forgot pswrd otp request data -: $body");
      var response = await DioClient().post(
        Endpoints.forgotPswrdOtpRequest,
        data: body,
      );
      log(
        "forgot pswrd otp request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api forgot pswrd otp request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in forgot pswrd otp request',
        );
      }
      final model = ForgotPasswordOtpRequestModel.fromJson(response);
      log("Parsed forgot pswrd otp request: $model");
      if (model.status == false) {
        throw ServerException(
          message: model.message ?? 'Failed to change password',
        );
      }
      return model;
    } on DioException catch (e) {
      log(
        'DioException in forgot pswrd otp request: ${e.response?.statusCode}',
      );
      log('Error message in forgot pswrd otp request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in forgot pswrd otp request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<StatusModel?> resetPswrdService({
    required String otp,
    required String newPswrd,
    required String cnfrmNewPswrd,
    required String userId,
  }) async {
    try {
      Map<String, dynamic> body = {
        "otp": otp,
        "new_password": newPswrd,
        "confirm_new_password": cnfrmNewPswrd,
        "user_id": userId,
      };
      log("passed reset pswrd data -: $body");
      var response = await DioClient().post(Endpoints.resetPswrd, data: body);
      log(
        "change reset pswrd request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api reset pswrd request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in reset pswrd request',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed reset pswrd Model: $model");
      if (model.status == false) {
        throw ServerException(
          message: model.message ?? 'Failed to reset pswrd',
        );
      }
      return model;
    } on DioException catch (e) {
      log('DioException in reset pswrd request: ${e.response?.statusCode}');
      log('Error message in reset pswrd request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in reset pswrd request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<ForgotPasswordOtpRequestModel?> resentOtpService({
    required String email,
    required String userId,
  }) async {
    try {
      Map<String, dynamic> body = {"email": email, "user_id": userId};
      log("passed resent otp data -: $body");
      var response = await DioClient().post(Endpoints.resetOtp, data: body);
      log(
        "change resent otp request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api resent otp request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in resent otp request',
        );
      }
      final model = ForgotPasswordOtpRequestModel.fromJson(response);
      log("Parsed resent otp Model: $model");
      if (model.status == false) {
        throw ServerException(message: model.message ?? 'Failed to resent otp');
      }
      return model;
    } on DioException catch (e) {
      log('DioException in resent otp request: ${e.response?.statusCode}');
      log('Error message in resent otp request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in resent otp request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
