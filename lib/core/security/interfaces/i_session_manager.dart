import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/session_failure.dart';

/// Interface for session management operations
abstract class ISessionManager {
  /// Starts a new session for the user
  Future<Either<SessionFailure, void>> startSession({
    required String userId,
    required String token,
    String? refreshToken,
    Duration? customTimeout,
  });

  /// Ends the current session
  Future<Either<SessionFailure, void>> endSession();

  /// Gets the current session
  Future<Either<SessionFailure, AuthSessionEntity?>> getCurrentSession();

  /// Checks if a session is valid
  Future<Either<SessionFailure, bool>> isSessionValid();

  /// Updates the last activity timestamp
  Future<Either<SessionFailure, void>> updateActivity();

  /// Gets the time remaining until session expires
  Future<Either<SessionFailure, Duration?>> getTimeRemaining();

  /// Extends the current session
  Future<Either<SessionFailure, void>> extendSession({Duration? extension});

  /// Stream of session state changes
  Stream<bool> get sessionStateStream;

  /// Disposes resources
  Future<void> dispose();
}
