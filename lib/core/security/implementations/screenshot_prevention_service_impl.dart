import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_screenshot_prevention_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

class ScreenshotPreventionServiceImpl implements IScreenshotPreventionService {
  final ISecureStorage _secureStorage;
  static const MethodChannel _channel = MethodChannel('screenshot_prevention');

  final StreamController<bool> _stateController =
      StreamController<bool>.broadcast();

  ScreenshotPreventionServiceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  bool _isAndroid() =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool _isIOS() => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Future<Either<Failure, void>> enable() async {
    try {
      await _channel.invokeMethod('enableSecureMode');

      _stateController.add(true);

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.screenshotPreventionEnabled,
        value: 'true',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to enable screenshot prevention',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disable() async {
    try {
      // Allow Android and iOS to clear secure mode when navigating away from
      // sensitive screens. Native side no-ops if not supported.
      await _channel.invokeMethod('disableSecureMode');

      _stateController.add(false);

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.screenshotPreventionEnabled,
        value: 'false',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to disable screenshot prevention',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isEnabled() async {
    try {
      final result = await _secureStorage.read(
        key: StorageKeysConfig.screenshotPreventionEnabled,
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
  Future<Either<Failure, void>> enableForRoute(String route) async {
    try {
      final protectedRoutes = await _getProtectedRoutes();

      if (!protectedRoutes.contains(route)) {
        protectedRoutes.add(route);
        await _saveProtectedRoutes(protectedRoutes);
      }

      if (_shouldProtectRoute(route)) {
        return enable();
      }

      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to enable screenshot prevention for route',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disableForRoute(String route) async {
    try {
      final protectedRoutes = await _getProtectedRoutes();
      protectedRoutes.remove(route);
      await _saveProtectedRoutes(protectedRoutes);

      // ❗ Do not disable secure mode on Android
      if (_isIOS()) {
        await _channel.invokeMethod('disableSecureMode');
      }

      return const Right(null);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to disable screenshot prevention for route',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isRouteProtected(String route) async {
    try {
      final protectedRoutes = await _getProtectedRoutes();
      return Right(
          protectedRoutes.contains(route) || _shouldProtectRoute(route));
    } catch (e) {
      return const Right(false);
    }
  }

  Future<List<String>> _getProtectedRoutes() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.protectedRoutes,
    );

    return result.fold(
      (failure) => [],
      (value) {
        if (value == null || value.isEmpty) return [];
        return value.split(',');
      },
    );
  }

  Future<void> _saveProtectedRoutes(List<String> routes) async {
    await _secureStorage.write(
      key: StorageKeysConfig.protectedRoutes,
      value: routes.join(','),
    );
  }

  bool _shouldProtectRoute(String route) {
    return SecurityConfig.sensitiveRoutes.any(
      (sensitiveRoute) => route.startsWith(sensitiveRoute),
    );
  }

  Future<void> dispose() async {
    await _stateController.close();
  }
}
