import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/dio_client.dart';
import 'package:teqbae_test/core/network/end_points.dart';
import 'package:teqbae_test/core/network/exceptions/server_exception.dart';
import 'package:teqbae_test/model/common/status/status_model.dart';
import 'package:teqbae_test/model/expense/expense_approval_model.dart';
import 'package:teqbae_test/model/expense/expense_category_model.dart';
import 'package:teqbae_test/model/expense/expense_list_model.dart';
import 'package:teqbae_test/model/expense/expense_summary_model.dart';
import 'package:teqbae_test/model/expense/hr_manager_expense_approve_List_model.dart';

class ExpenseService {
  static Future<ExpenseCategoryModel?> expenseCategoryService() async {
    try {
      var response = await DioClient().get(Endpoints.expenseCategory);
      log('Response of api  expense category: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense category',
        );
      }
      final model = ExpenseCategoryModel.fromJson(response);
      log("Parsed  expense category Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  expense category: ${e.response?.statusCode}');
      log('Error message in  expense category: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  expense category: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<StatusModel?> addExpenseService({
    required String date,
    required List<String> categoryIds,
    required String amount,
    required String remark,
    List<String>? images,
  }) async {
    try {
      final String categoryIdsStr = categoryIds.join(',');

      Map<String, dynamic> body = {
        "date": date,
        "category_ids": categoryIdsStr,
        "amount": amount,
        "remark": remark,
      };

      log("passed add expense data -: $body");
      FormData formData = FormData.fromMap(body);

      if (images != null && images.isNotEmpty) {
        for (String path in images) {
          formData.files.add(
            MapEntry(
              "images[]",
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      var response = await DioClient().post(
        Endpoints.addExpense,
        data: formData,
      );
      log("add expense API Response   = = = = = = = = = = = = : $response");
      log('Response of api add expense: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in add expense',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed add expense Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in add expense: ${e.response?.statusCode}');
      log('Error message in add expense: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in add expense: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<ExpenseListModel?> expenseListService({
    required String limit,
    String? status,
    String? timePeriod,
    String? search,
  }) async {
    try {
      Map<String, dynamic> body = {
        "limit": limit,
        "status": status ?? "null",
        "time_period": timePeriod ?? "null",
        "search": search ?? "",
      };
      log("passed expense list data -: $body");
      var response = await DioClient().post(Endpoints.expenseList, data: body);
      log('Response of api expense list: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense list',
        );
      }
      final model = ExpenseListModel.fromJson(response);
      log("Parsed expense list Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in expense list: ${e.response?.statusCode}');
      log('Error message in expense list: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in expense list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<ExpenseSummaryModel?> expenseSummaryService({
    required String month,
    required String year,
  }) async {
    try {
      Map<String, dynamic> body = {"month": month, "year": year};
      log("passed  expense summary data -: $body");
      var response = await DioClient().post(
        Endpoints.expenseSummary,
        data: body,
      );
      log('Response of api  expense summary: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense summary',
        );
      }
      final model = ExpenseSummaryModel.fromJson(response);
      log("Parsed expense summary Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in expense summary: ${e.response?.statusCode}');
      log('Error message in expense summary: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in expense summary: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static Future<StatusModel?> expenseDeleteService({
    required String expenseId,
  }) async {
    try {
      var response = await DioClient().delete(
        "${Endpoints.expenseDelete}$expenseId",
      );
      log('Response of api  expense delete: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense delete',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed  expense delete Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  expense delete: ${e.response?.statusCode}');
      log('Error message in  expense delete: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  expense delete: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  // expense approval list

  static Future<ExpenseApprovalListModel?> expenseApprovalListService({
    required String status,
    required String month,
    required String search,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "status": status,
        "time_period": month,
        "search": search,
      };
      log("passed se expense approval data -: $body");
      var response = await DioClient().post(
        Endpoints.expenseApprovalList,
        data: body,
      );
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api expense approval list: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense approval list',
        );
      }
      final model = ExpenseApprovalListModel.fromJson(response);
      log("Parsed  expense approval list Model: $model");
      return model;
    } on DioException catch (e) {
      log('DioException in  expense approval list: ${e.response?.statusCode}');
      log('Error message in  expense approval list: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  expense approval list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
  // expense approval

  static Future<StatusModel?> expenseApprovalService({
    required String status,
    required String expenseid,
    required String userid,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "status": status,
        "expense_id": expenseid,
        "user_id": userid,
      };
      log("passed se expense approval data -: $body");
      var response = await DioClient().post(
        Endpoints.expenseApproval,
        data: body,
      );
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api expense approval request: $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in expense approval request',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed  expense approval  details Model: $model");
      return model;
    } on DioException catch (e) {
      log(
        'DioException in  expense approval request: ${e.response?.statusCode}',
      );
      log('Error message in  expense approval request: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log("Unexpected error in  expense approval request: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  // hrmanagerexpenseapprovelist

  static Future<HrManagerExpenseApproveListModel?>
  hrmanagerexpenseapprovelistService({
    required String status,
    required String timeperiod,
    required String search,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "status": status,
        "time_period": timeperiod,
        "search": search,
      };
      log("passed se hrmanagerexpense approval data -: $body");
      var response = await DioClient().post(
        Endpoints.hrmanagerexpenseapprovelist,
        data: body,
      );
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api hrmanagerexpenseapprovelist : $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in hrmanagerexpenseapprovelist',
        );
      }
      final model = HrManagerExpenseApproveListModel.fromJson(response);
      log("Parsed  hrmanager expense approval list Model: $model");
      return model;
    } on DioException catch (e) {
      log(
        'DioException in  hrmanager expense approval list: ${e.response?.statusCode}',
      );
      log(
        'Error message in  hrmanager expense approval list: ${e.response?.data}',
      );
      rethrow;
    } catch (e) {
      log("Unexpected error in  hrmanager expense approval list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  // hrmanagerexpenseapproval

  static Future<StatusModel?> hrmanagerexpenseapprovalService({
    required String expenseid,
    required String status,
    required String userid,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "expense_id": expenseid,
        "status": status,
        "user_id": userid,
      };
      log("passed se hrmanagerexpense approval data -: $body");
      var response = await DioClient().post(
        Endpoints.hrmanagerexpenseapproval,
        data: body,
      );
      log(
        "customor create request API Response   = = = = = = = = = = = = : $response",
      );
      log('Response of api hrmanagerexpenseapprovelist : $response');
      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format in hrmanagerexpenseapprovelist',
        );
      }
      final model = StatusModel.fromJson(response);
      log("Parsed  hrmanager expense approval list Model: $model");
      return model;
    } on DioException catch (e) {
      log(
        'DioException in  hrmanager expense approval list: ${e.response?.statusCode}',
      );
      log(
        'Error message in  hrmanager expense approval list: ${e.response?.data}',
      );
      rethrow;
    } catch (e) {
      log("Unexpected error in  hrmanager expense approval list: $e");
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
