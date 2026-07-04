import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../exceptions.dart';

class DioHandler {
  static AppException handle(final dynamic error) {
    if (error is DioException) return _handleDio(error);
    return ServerException(message: error.toString());
  }

  static AppException _handleDio(final DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        final message = _extractMessage(e.response);
        return _mapByCode(e.response?.statusCode, message);

      default:
        return ServerException(message: e.message ?? 'errors.unknown'.tr());
    }
  }

  /// Extracts error message from JSend response format or falls back to generic.
  /// Expects: { "status": "fail", "message": "...", "statusCode": N }
  static String _extractMessage(final Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      // JSend format: { "message": "..." }
      if (data.containsKey('message') && data['message'] is String) {
        return data['message'] as String;
      }
    }
    return response?.statusMessage ?? 'errors.server_error'.tr();
  }

  static AppException _mapByCode(final int? code, final String message) {
    switch (code) {
      case 400:
        return ServerException(message: message, statusCode: 400);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        return ValidationException(message: message);
      case 429:
        return TooManyRequestsException(message: message);
      case 500:
      case 502:
      case 503:
        return ServerException(message: message, statusCode: code);
      default:
        return ServerException(message: message);
    }
  }
}
