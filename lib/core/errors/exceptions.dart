/// Base Exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() =>
      statusCode != null ? '$message (HTTP $statusCode)' : message;
}

class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  CacheException({required super.message});
}

class NetworkException extends AppException {
  NetworkException({super.message = 'errors.no_internet'});
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'errors.unauthorized',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  ForbiddenException({
    super.message = 'errors.forbidden',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'errors.not_found',
    super.statusCode = 404,
  });
}

class TimeoutException extends AppException {
  TimeoutException({super.message = 'errors.timeout'});
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;
  ValidationException({
    super.message = 'errors.validation',
    this.errors,
    super.statusCode = 422,
  });
}

class ParseException extends AppException {
  ParseException({super.message = 'errors.parse_error'});
}

class ConflictException extends AppException {
  ConflictException({
    super.message = 'errors.conflict',
    super.statusCode = 409,
  });
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException({
    super.message = 'errors.too_many_requests',
    super.statusCode = 429,
  });
}
