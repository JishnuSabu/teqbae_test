import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:teqbae_test/core/network/base_url.dart';
import 'package:teqbae_test/core/services/local_storage/local_keys.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      contentType: 'application/json',
      baseUrl: BaseUrl.basePathUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = BaseUrl.basePathUrl;
          final authToken = LocalStorageService.getString(
            LocalStorageKey.USER_TOKEN_KEY,
          );

          if (authToken.isNotEmpty && !options.path.contains('login')) {
            options.headers['Authorization'] = 'Bearer $authToken';
            options.headers['Accept'] = 'application/json';
          }

          log('🌐 [DIO REQ] ${options.method} ${options.baseUrl}${options.path}');
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout) {
            log("⚠️ Network Error: Slow or No Internet Connection");
          }
          return handler.next(e);
        },
      ),
    );

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.get(
      uri,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response.data;
  }

  Future<dynamic> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.post(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.data;
  }

  Future<dynamic> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.put(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.data;
  }

  Future<dynamic> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}
