import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

/// Implementation of IAppLockService
class AppLockServiceImpl implements IAppLockService {
  final ISecureStorage _secureStorage;
  Timer? _autoLockTimer;
  final StreamController<bool> _lockStateController =
      StreamController<bool>.broadcast();

  AppLockServiceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, bool>> isLocked() async {
    try {
      final result = await _secureStorage.read(
        key: StorageKeysConfig.appLocked,
      );

      return result.fold(
        (failure) => const Right(false),
        (value) => Right(value == 'true'),
      );
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> lock() async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.appLocked,
        value: 'true',
      );

      if (writeResult.isLeft()) {
        return writeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      }

      await _secureStorage.write(
        key: StorageKeysConfig.lockTimestamp,
        value: DateTime.now().toIso8601String(),
      );

      _lockStateController.add(true);
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to lock app',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> unlock() async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.appLocked,
        value: 'false',
      );

      if (writeResult.isLeft()) {
        return writeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      }

      await _secureStorage.delete(key: StorageKeysConfig.lockTimestamp);

      _lockStateController.add(false);
      _startAutoLockTimer();
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to unlock app',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> resetLock() async {
    return updateActivity();
  }

  @override
  Future<Either<Failure, void>> updateActivity() async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.lastActivityTime,
        value: DateTime.now().toIso8601String(),
      );

      if (writeResult.isLeft()) {
        return writeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      }

      // Restart auto-lock timer
      _startAutoLockTimer();
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to update activity',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> enableAutoLock({Duration? timeout}) async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.autoLockEnabled,
        value: 'true',
      );

      if (writeResult.isLeft()) {
        return writeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      }

      if (timeout != null) {
        await setAutoLockTimeout(timeout);
      }

      _startAutoLockTimer();
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to enable auto-lock',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disableAutoLock() async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.autoLockEnabled,
        value: 'false',
      );

      if (writeResult.isLeft()) {
        return writeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      }

      _autoLockTimer?.cancel();
      _autoLockTimer = null;
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to disable auto-lock',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isAutoLockEnabled() async {
    try {
      final result = await _secureStorage.read(
        key: StorageKeysConfig.autoLockEnabled,
      );

      return result.fold(
        (failure) => const Right(true), // Default to enabled for security
        (value) => Right(value != 'false'),
      );
    } catch (e) {
      return const Right(true); // Default to enabled for security
    }
  }

  @override
  Future<Either<Failure, Duration>> getAutoLockTimeout() async {
    try {
      final result = await _secureStorage.read(
        key: StorageKeysConfig.autoLockTimeout,
      );

      return result.fold(
        (failure) => const Right(SecurityConfig.autoLockTimeout),
        (value) {
          if (value == null) {
            return const Right(SecurityConfig.autoLockTimeout);
          }
          final seconds = int.tryParse(value);
          if (seconds == null) {
            return const Right(SecurityConfig.autoLockTimeout);
          }
          return Right(Duration(seconds: seconds));
        },
      );
    } catch (e) {
      return const Right(SecurityConfig.autoLockTimeout);
    }
  }

  @override
  Future<Either<Failure, void>> setAutoLockTimeout(Duration timeout) async {
    try {
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.autoLockTimeout,
        value: timeout.inSeconds.toString(),
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to set auto-lock timeout',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<bool> get lockStateStream => _lockStateController.stream;

  @override
  Future<void> dispose() async {
    _autoLockTimer?.cancel();
    _autoLockTimer = null;
    await _lockStateController.close();
  }

  /// Starts the auto-lock timer
  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();

    // Check if auto-lock is enabled
    isAutoLockEnabled().then((result) {
      result.fold(
        (failure) => null,
        (enabled) {
          if (!enabled) return;

          // Get timeout duration
          getAutoLockTimeout().then((timeoutResult) {
            timeoutResult.fold(
              (failure) => null,
              (timeout) {
                _autoLockTimer = Timer(timeout, () {
                  // Check last activity time
                  _secureStorage
                      .read(key: StorageKeysConfig.lastActivityTime)
                      .then((result) {
                    result.fold(
                      (failure) => lock(),
                      (lastActivityStr) {
                        if (lastActivityStr == null) {
                          lock();
                          return;
                        }

                        final lastActivity = DateTime.parse(lastActivityStr);
                        final now = DateTime.now();
                        final inactiveDuration = now.difference(lastActivity);

                        if (inactiveDuration >= timeout) {
                          lock();
                        } else {
                          // Restart timer for remaining time
                          final remaining = timeout - inactiveDuration;
                          _autoLockTimer?.cancel();
                          _autoLockTimer = Timer(remaining, () => lock());
                        }
                      },
                    );
                  });
                });
              },
            );
          });
        },
      );
    });
  }
}
