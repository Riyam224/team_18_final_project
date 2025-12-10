import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_blur_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

/// Implementation of IBlurService
/// Manages blur overlay state for privacy when app is backgrounded
class BlurServiceImpl implements IBlurService {
  final ISecureStorage _secureStorage;
  final StreamController<bool> _blurStateController =
      StreamController<bool>.broadcast();

  bool _isBlurEnabled = false;
  bool _isBlurVisible = false;

  BlurServiceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, void>> enableBlur() async {
    try {
      _isBlurEnabled = true;

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.blurEnabled,
        value: 'true',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) {
          _blurStateController.add(true);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to enable blur',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disableBlur() async {
    try {
      _isBlurEnabled = false;

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.blurEnabled,
        value: 'false',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) {
          _blurStateController.add(false);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to disable blur',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isBlurEnabled() async {
    try {
      final result = await _secureStorage.read(
        key: StorageKeysConfig.blurEnabled,
      );

      return result.fold(
        (failure) => const Right(true), // Default to enabled for security
        (value) {
          final enabled = value != 'false';
          _isBlurEnabled = enabled;
          return Right(enabled);
        },
      );
    } catch (e) {
      return const Right(true); // Default to enabled for security
    }
  }

  @override
  Future<Either<Failure, void>> showBlur() async {
    try {
      _isBlurVisible = true;
      _blurStateController.add(true);
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to show blur',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> hideBlur() async {
    try {
      _isBlurVisible = false;
      _blurStateController.add(false);
      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to hide blur',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<bool> get blurStateStream => _blurStateController.stream;

  /// Dispose resources
  Future<void> dispose() async {
    await _blurStateController.close();
  }

  /// Get current blur enabled state (synchronous)
  bool get isEnabled => _isBlurEnabled;

  /// Get current blur visibility state (synchronous)
  bool get isVisible => _isBlurVisible;
}
