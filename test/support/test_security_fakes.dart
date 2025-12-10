import 'dart:async';
import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_blur_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_screenshot_prevention_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';
import 'package:team_18_final_project/features/auth/domain/failures/session_failure.dart';
import 'package:team_18_final_project/features/auth/domain/failures/storage_failure.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';

class InMemorySecureStorage implements ISecureStorage {
  final Map<String, String> _store = HashMap();

  @override
  Future<Either<StorageFailure, void>> write({
    required String key,
    required String value,
  }) async {
    _store[key] = value;
    return const Right(null);
  }

  @override
  Future<Either<StorageFailure, String?>> read({required String key}) async {
    return Right(_store[key]);
  }

  @override
  Future<Either<StorageFailure, void>> delete({required String key}) async {
    _store.remove(key);
    return const Right(null);
  }

  @override
  Future<Either<StorageFailure, void>> deleteAll() async {
    _store.clear();
    return const Right(null);
  }

  @override
  Future<Either<StorageFailure, bool>> containsKey(
      {required String key}) async {
    return Right(_store.containsKey(key));
  }

  @override
  Future<Either<StorageFailure, Map<String, String>>> readAll() async {
    return Right(Map.unmodifiable(_store));
  }
}

class NoopBiometricService implements IBiometricService {
  @override
  Future<Either<BiometricFailure, bool>> authenticate({
    required String localizedReason,
  }) async =>
      const Right(false);

  @override
  Future<Either<BiometricFailure, List<AvailableBiometricType>>>
      getAvailableBiometrics() async => const Right([]);

  @override
  Future<Either<BiometricFailure, bool>> isAvailable() async =>
      const Right(false);

  @override
  Future<Either<BiometricFailure, bool>> isEnrolled() async =>
      const Right(false);

  @override
  Future<void> stopAuthentication() async {}
}

class InMemorySessionManager implements ISessionManager {
  AuthSessionEntity? _session;
  final _controller = StreamController<bool>.broadcast();
  Duration _timeout = const Duration(minutes: 30);

  @override
  Stream<bool> get sessionStateStream => _controller.stream;

  @override
  Future<Either<SessionFailure, void>> startSession({
    required String userId,
    required String token,
    String? refreshToken,
    Duration? customTimeout,
  }) async {
    _timeout = customTimeout ?? _timeout;
    _session = AuthSessionEntity(
      userId: userId,
      token: token,
      refreshToken: refreshToken,
      startedAt: DateTime.now(),
    );
    _controller.add(true);
    return const Right(null);
  }

  @override
  Future<Either<SessionFailure, void>> endSession() async {
    _session = null;
    _controller.add(false);
    return const Right(null);
  }

  @override
  Future<Either<SessionFailure, AuthSessionEntity?>> getCurrentSession() async {
    return Right(_session);
  }

  @override
  Future<Either<SessionFailure, bool>> isSessionValid() async {
    if (_session == null) return const Right(false);
    final elapsed = DateTime.now().difference(_session!.startedAt);
    return Right(elapsed < _timeout);
  }

  @override
  Future<Either<SessionFailure, void>> updateActivity() async {
    return const Right(null);
  }

  @override
  Future<Either<SessionFailure, Duration?>> getTimeRemaining() async {
    if (_session == null) return const Right(null);
    final elapsed = DateTime.now().difference(_session!.startedAt);
    return Right(_timeout - elapsed);
  }

  @override
  Future<Either<SessionFailure, void>> extendSession(
      {Duration? extension}) async {
    if (_session == null) return const Right(null);
    _timeout += extension ?? const Duration(minutes: 5);
    return const Right(null);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class InMemoryAppLockService implements IAppLockService {
  bool _locked = false;
  Duration _timeout = const Duration(minutes: 2);
  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get lockStateStream => _controller.stream;

  @override
  Future<Either<Failure, bool>> isLocked() async => Right(_locked);

  @override
  Future<Either<Failure, void>> lock() async {
    _locked = true;
    _controller.add(true);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unlock() async {
    _locked = false;
    _controller.add(false);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetLock() async {
    _locked = false;
    _controller.add(false);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateActivity() async => const Right(null);

  @override
  Future<Either<Failure, void>> enableAutoLock({Duration? timeout}) async {
    _timeout = timeout ?? _timeout;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> disableAutoLock() async => const Right(null);

  @override
  Future<Either<Failure, bool>> isAutoLockEnabled() async => const Right(true);

  @override
  Future<Either<Failure, Duration>> getAutoLockTimeout() async =>
      Right(_timeout);

  @override
  Future<Either<Failure, void>> setAutoLockTimeout(Duration timeout) async {
    _timeout = timeout;
    return const Right(null);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class NoopAuditLogService implements IAuditLogService {
  @override
  Future<Either<Failure, void>> log({
    required String event,
    Map<String, dynamic>? metadata,
  }) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<AuditLogEntry>>> getAll() async =>
      const Right(<AuditLogEntry>[]);

  @override
  Future<Either<Failure, List<AuditLogEntry>>> getRecent(
          {int limit = 50}) async =>
      const Right(<AuditLogEntry>[]);

  @override
  Future<Either<Failure, void>> clear() async => const Right(null);

  @override
  Future<Either<Failure, void>> cleanup({required int keepCount}) async =>
      const Right(null);
}

class NoopScreenshotPreventionService implements IScreenshotPreventionService {
  @override
  Future<Either<Failure, void>> disable() async => const Right(null);

  @override
  Future<Either<Failure, void>> disableForRoute(String route) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> enable() async => const Right(null);

  @override
  Future<Either<Failure, void>> enableForRoute(String route) async =>
      const Right(null);

  @override
  Future<Either<Failure, bool>> isEnabled() async => const Right(false);

  @override
  Future<Either<Failure, bool>> isRouteProtected(String route) async =>
      const Right(false);
}

class NoopRootDetectionService implements IRootDetectionService {
  @override
  Future<Either<Failure, bool>> isDeviceRooted() async => const Right(false);

  @override
  Future<Either<Failure, bool>> isOnEmulator() async => const Right(false);

  @override
  Future<Either<Failure, bool>> isMockLocationEnabled() async =>
      const Right(false);

  @override
  Future<Either<Failure, bool>> isDeveloperModeEnabled() async =>
      const Right(false);

  @override
  Future<Either<Failure, SecurityCheckResult>> performSecurityCheck() async =>
      const Right(SecurityCheckResult(
        isSecure: true,
        message: 'Test environment - assumed secure',
      ));

  @override
  Future<Either<Failure, bool>> isDeviceSecure() async => const Right(true);
}

class NoopBlurService implements IBlurService {
  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get blurStateStream => _controller.stream;

  @override
  Future<Either<Failure, void>> enableBlur() async {
    _controller.add(true);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> disableBlur() async {
    _controller.add(false);
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isBlurEnabled() async => const Right(false);

  @override
  Future<Either<Failure, void>> showBlur() async {
    _controller.add(true);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> hideBlur() async {
    _controller.add(false);
    return const Right(null);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class FakeEncryptionService implements IEncryptionService {
  @override
  Future<Either<Failure, String>> decrypt(String cipherText) async =>
      Right(cipherText);

  @override
  Future<Either<Failure, String>> encrypt(String plaintext) async =>
      Right(plaintext);
}

SecurityOverrides createTestSecurityOverrides() {
  return SecurityOverrides(
    secureStorage: () => InMemorySecureStorage(),
    encryption: (_) => FakeEncryptionService(),
    biometric: () => NoopBiometricService(),
    sessionManager: (_, __) => InMemorySessionManager(),
    appLock: (_) => InMemoryAppLockService(),
    auditLog: (_) => NoopAuditLogService(),
    screenshot: (_) => NoopScreenshotPreventionService(),
    rootDetection: () => NoopRootDetectionService(),
    blur: (_) => NoopBlurService(),
  );
}
