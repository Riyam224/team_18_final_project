import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Interface for app lock operations
abstract class IAppLockService {
  /// Checks if the app is currently locked
  Future<Either<Failure, bool>> isLocked();

  /// Locks the app
  Future<Either<Failure, void>> lock();

  /// Unlocks the app
  Future<Either<Failure, void>> unlock();

  /// Resets the lock timer (called on user activity)
  Future<Either<Failure, void>> resetLock();

  /// Updates the last activity timestamp
  Future<Either<Failure, void>> updateActivity();

  /// Enables auto-lock feature
  Future<Either<Failure, void>> enableAutoLock({Duration? timeout});

  /// Disables auto-lock feature
  Future<Either<Failure, void>> disableAutoLock();

  /// Checks if auto-lock is enabled
  Future<Either<Failure, bool>> isAutoLockEnabled();

  /// Gets the auto-lock timeout duration
  Future<Either<Failure, Duration>> getAutoLockTimeout();

  /// Sets the auto-lock timeout duration
  Future<Either<Failure, void>> setAutoLockTimeout(Duration timeout);

  /// Stream of lock state changes
  Stream<bool> get lockStateStream;

  /// Disposes resources
  Future<void> dispose();
}
