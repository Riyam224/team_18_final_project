import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:team_18_final_project/features/auth/data/mappers/session_mapper.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/session_failure.dart';

/// Implementation of ISessionManager
class SessionManagerImpl implements ISessionManager {
  final ISecureStorage _secureStorage;
  final IEncryptionService _encryptionService;
  Timer? _sessionTimer;
  final StreamController<bool> _sessionStateController =
      StreamController<bool>.broadcast();

  SessionManagerImpl({
    required ISecureStorage secureStorage,
    required IEncryptionService encryptionService,
  })  : _secureStorage = secureStorage,
        _encryptionService = encryptionService;

  @override
  Future<Either<SessionFailure, void>> startSession({
    required String userId,
    required String token,
    String? refreshToken,
    Duration? customTimeout,
  }) async {
    try {
      // Create session entity
      final session = AuthSessionEntity(
        userId: userId,
        token: token,
        refreshToken: refreshToken,
        startedAt: DateTime.now(),
        expiresAt: DateTime.now().add(
          customTimeout ?? SecurityConfig.sessionTimeout,
        ),
      );

      // Store session data
      final sessionData = SessionMapper.toJson(session);
      final encrypted = await _encryptionService.encrypt(sessionData);
      final payload = encrypted.getOrElse(() => sessionData);
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.sessionId,
        value: payload,
      );

      if (writeResult.isLeft()) {
        return Left(SessionStorageFailure());
      }

      // Store active flag
      await _secureStorage.write(
        key: StorageKeysConfig.sessionActive,
        value: 'true',
      );

      // Store last activity time
      await _secureStorage.write(
        key: StorageKeysConfig.lastActivityTime,
        value: DateTime.now().toIso8601String(),
      );

      // Start session monitoring timer
      _startSessionMonitoring();

      // Notify listeners
      _sessionStateController.add(true);

      return const Right(null);
    } catch (e) {
      return Left(
        SessionCreationFailure(
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<SessionFailure, void>> endSession() async {
    try {
      // Clear session data
      await _secureStorage.delete(key: StorageKeysConfig.sessionId);
      await _secureStorage.delete(key: StorageKeysConfig.sessionActive);
      await _secureStorage.delete(key: StorageKeysConfig.lastActivityTime);
      await _secureStorage.delete(key: StorageKeysConfig.authToken);
      await _secureStorage.delete(key: StorageKeysConfig.refreshToken);

      // Stop timer
      _sessionTimer?.cancel();
      _sessionTimer = null;

      // Notify listeners
      _sessionStateController.add(false);

      return const Right(null);
    } catch (e) {
      return Left(
        GenericSessionFailure(
          message: 'Failed to end session',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<SessionFailure, AuthSessionEntity?>> getCurrentSession() async {
    try {
      final sessionResult = await _secureStorage.read(
        key: StorageKeysConfig.sessionId,
      );

      return await sessionResult.fold(
        (failure) async => Left(SessionNotFoundFailure()),
        (sessionData) async {
          if (sessionData == null) {
            return const Right(null);
          }

          final decrypted = await _encryptionService.decrypt(sessionData);
          final payload = decrypted.getOrElse(() => sessionData);
          final session = SessionMapper.fromJson(payload);
          return Right(session);
        },
      );
    } catch (e) {
      return Left(
        GenericSessionFailure(
          message: 'Failed to get current session',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<SessionFailure, bool>> isSessionValid() async {
    try {
      final sessionResult = await getCurrentSession();

      return sessionResult.fold(
        (failure) => const Right(false),
        (session) {
          if (session == null) {
            return const Right(false);
          }

          // Check if session is expired
          if (session.isExpired) {
            return const Right(false);
          }

          // Ensure monitoring keeps running after app relaunch
          if (_sessionTimer == null) {
            _startSessionMonitoring();
          }

          return const Right(true);
        },
      );
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<SessionFailure, void>> updateActivity() async {
    try {
      final now = DateTime.now();
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.lastActivityTime,
        value: now.toIso8601String(),
      );

      return writeResult.fold(
        (failure) => Left(SessionStorageFailure()),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        SessionStorageFailure(
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<SessionFailure, Duration?>> getTimeRemaining() async {
    try {
      final sessionResult = await getCurrentSession();

      return sessionResult.fold(
        (failure) => const Right(null),
        (session) {
          if (session == null || session.expiresAt == null) {
            return const Right(null);
          }

          final now = DateTime.now();
          if (now.isAfter(session.expiresAt!)) {
            return const Right(Duration.zero);
          }

          final remaining = session.expiresAt!.difference(now);
          return Right(remaining);
        },
      );
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<SessionFailure, void>> extendSession({
    Duration? extension,
  }) async {
    try {
      final sessionResult = await getCurrentSession();

      if (sessionResult.isLeft()) {
        return sessionResult.fold(
          (failure) => Left(failure),
          (_) => Left(SessionNotFoundFailure()),
        );
      }

      final session = sessionResult.getOrElse(() => null);
      if (session == null) {
        return Left(SessionNotFoundFailure());
      }

      final extensionDuration = extension ?? SecurityConfig.sessionTimeout;
      final newExpiresAt = DateTime.now().add(extensionDuration);

      final updatedSession = session.copyWith(
        expiresAt: newExpiresAt,
      );

      final sessionData = SessionMapper.toJson(updatedSession);
      final encrypted = await _encryptionService.encrypt(sessionData);
      final payload = encrypted.getOrElse(() => sessionData);
      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.sessionId,
        value: payload,
      );

      return writeResult.fold(
        (failure) => Left(SessionStorageFailure()),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        GenericSessionFailure(
          message: 'Failed to extend session',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<bool> get sessionStateStream => _sessionStateController.stream;

  @override
  Future<void> dispose() async {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    await _sessionStateController.close();
  }

  /// Starts monitoring session validity
  void _startSessionMonitoring() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(
      SecurityConfig.sessionPollInterval,
      (_) async {
        final isValid = await isSessionValid();
        isValid.fold(
          (failure) => _sessionStateController.add(false),
          (valid) {
            if (!valid) {
              // Session expired, end it
              endSession();
            }
          },
        );
      },
    );
  }
}
