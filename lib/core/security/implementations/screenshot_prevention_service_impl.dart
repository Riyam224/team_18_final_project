import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_screenshot_prevention_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

/// Implementation of IScreenshotPreventionService
class ScreenshotPreventionServiceImpl implements IScreenshotPreventionService {
  final ISecureStorage _secureStorage;
  static const MethodChannel _channel = MethodChannel('screenshot_prevention');

  final StreamController<bool> _stateController = StreamController<bool>.broadcast();
  bool _isEnabled = false;

  ScreenshotPreventionServiceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, void>> enable() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await _channel.invokeMethod('enableSecureMode');
      }

      _isEnabled = true;
      _stateController.add(true);

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.screenshotPreventionEnabled,
        value: 'true',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } on PlatformException catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Platform error enabling screenshot prevention',
          details: e.toString(),
        ),
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
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await _channel.invokeMethod('disableSecureMode');
      }

      _isEnabled = false;
      _stateController.add(false);

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.screenshotPreventionEnabled,
        value: 'false',
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } on PlatformException catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Platform error disabling screenshot prevention',
          details: e.toString(),
        ),
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

      // Check if route should have screenshot prevention
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
      return Right(protectedRoutes.contains(route) || _shouldProtectRoute(route));
    } catch (e) {
      return const Right(false);
    }
  }

  /// Internal method to get protected routes from storage
  Future<List<String>> _getProtectedRoutes() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.protectedRoutes,
    );

    return result.fold(
      (failure) => [],
      (value) {
        if (value == null || value.isEmpty) {
          return [];
        }
        return value.split(',');
      },
    );
  }

  /// Internal method to save protected routes
  Future<void> _saveProtectedRoutes(List<String> routes) async {
    await _secureStorage.write(
      key: StorageKeysConfig.protectedRoutes,
      value: routes.join(','),
    );
  }

  /// Check if a route should be protected based on config
  bool _shouldProtectRoute(String route) {
    return SecurityConfig.sensitiveRoutes.any(
      (sensitiveRoute) => route.startsWith(sensitiveRoute),
    );
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _stateController.close();
  }
}
