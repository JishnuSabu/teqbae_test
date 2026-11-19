import 'package:teqbae_test/core/network/exceptions/dio_exceptions.dart';

import 'package:dio/dio.dart';

/// Server exception for business logic errors
class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  factory ServerException.fromDioException(DioException e) {
    return ServerException(message: DioExceptions.fromDioError(e).toString());
  }

  @override
  String toString() => message;
}

/// Network exception for connectivity issues
class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => message;
}
