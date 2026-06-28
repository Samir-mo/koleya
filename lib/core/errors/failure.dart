import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'errors.connection_error'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'errors.no_internet',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'errors.unauthorized',
    super.code = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'errors.forbidden',
    super.code = 403,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'errors.not_found',
    super.code = 404,
  });
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure({
    super.message = 'errors.validation',
    this.errors,
    super.code = 422,
  });

  @override
  List<Object?> get props => [message, code, errors];
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'errors.conflict',
    super.code = 409,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'errors.timeout',
  });
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    super.message = 'errors.too_many_requests',
    super.code = 429,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'errors.unknown'});
}
