import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  bool get stringify => true;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Unauthorized access failure
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized access',
    super.code,
    super.details,
  }) : super(message: message);
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found',
    super.code,
    super.details,
  }) : super(message: message);
}

/// Permission denied failure
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({
    String message = 'Permission denied',
    super.code,
    super.details,
  }) : super(message: message);
}

/// Unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'An unexpected error occurred',
    super.code,
    super.details,
  }) : super(message: message);
}
