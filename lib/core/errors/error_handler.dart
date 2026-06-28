import 'package:dio/dio.dart';
import 'package:gate_buddy/core/errors/failure.dart';
import 'package:gate_buddy/core/errors/handlers/dio_handler.dart';

import 'exceptions.dart';

class ErrorHandler {
  /// Single entry point for error handling in RemoteDs layer
  /// Converts any error to AppException and throws it.
  /// Usage: } catch (e) { ErrorHandler.handle(e); }
  static Never handle(final dynamic error) {
    final exception = _toException(error);
    throw exception;
  }

  /// Deprecated: use [handle] instead. Kept for backward compatibility.
  static Never handleException(final dynamic error) => handle(error);

  /// Convert any error to Failure for repo layer
  /// Usage: } catch (e) { return handleFailure(e); }
  static Failure handleFailure(final dynamic error) {
    final exception = _toException(error);
    return _toFailure(exception);
  }

  // ─── Internal: Exception Mapping ───────────────────────────────────────
  static AppException _toException(final dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) return DioHandler.handle(error);
    return ServerException(message: error?.toString() ?? 'Unknown error.');
  }

  static Failure _toFailure(final AppException e) {
    if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message);
    }
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundFailure(message: e.message);
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, errors: e.errors);
    }
    if (e is ConflictException) return ConflictFailure(message: e.message);
    if (e is NetworkException) return NetworkFailure(message: e.message);
    if (e is TimeoutException) return TimeoutFailure(message: e.message);
    if (e is TooManyRequestsException) {
      return TooManyRequestsFailure(message: e.message);
    }
    if (e is CacheException) return CacheFailure(message: e.message);
    if (e is ServerException) {
      return ServerFailure(message: e.message, code: e.statusCode);
    }
    return const UnknownFailure();
  }
}
