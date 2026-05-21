import 'package:koleya/core/errors/failure.dart';
import 'package:koleya/core/errors/handlers/dio_handler.dart';

import 'exceptions.dart' hide NotFoundException;


class ErrorHandler {
  /// Call this in your data sources — throws AppException
  static Never handleException(final dynamic error) {
    if (error is AppException) throw error;



    // Future: FirebaseHandler.handle(error)
    // Future: ApiHandler.handle(error)

    throw ServerException(message: error?.toString() ?? 'Unknown error.');
  }

  /// Call this in your repositories — converts exception to Failure
  static Failure handleFailure(final dynamic error) {
    final exception = error is AppException ? error : DioHandler.handle(error);
    return _toFailure(exception);
  }


  static Failure _toFailure(final AppException e) {
    if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message);
    }
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundException(message: e.message);
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
