import 'package:team_18_final_project/core/error/failures.dart';

/// Base class for session-related failures
abstract class SessionFailure extends Failure {
  const SessionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Session expired failure
class SessionExpiredFailure extends SessionFailure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.code = 'session-expired',
    super.details,
  });
}

/// Invalid session failure
class InvalidSessionFailure extends SessionFailure {
  const InvalidSessionFailure({
    super.message = 'Invalid session. Please log in again.',
    super.code = 'invalid-session',
    super.details,
  });
}

/// Session not found failure
class SessionNotFoundFailure extends SessionFailure {
  const SessionNotFoundFailure({
    super.message = 'No active session found.',
    super.code = 'session-not-found',
    super.details,
  });
}

/// Session creation failure
class SessionCreationFailure extends SessionFailure {
  const SessionCreationFailure({
    super.message = 'Failed to create session.',
    super.code = 'session-creation-failed',
    super.details,
  });
}

/// Session storage failure
class SessionStorageFailure extends SessionFailure {
  const SessionStorageFailure({
    super.message = 'Failed to store session data.',
    super.code = 'session-storage-failed',
    super.details,
  });
}

/// Generic session failure for unknown errors
class GenericSessionFailure extends SessionFailure {
  const GenericSessionFailure({
    super.message = 'A session error occurred.',
    super.code,
    super.details,
  });
}
