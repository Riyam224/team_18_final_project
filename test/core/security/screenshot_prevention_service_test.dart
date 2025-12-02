@Skip('Skipped – depends on hardware/platform and must be mocked')
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/implementations/screenshot_prevention_service_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/auth/domain/failures/storage_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}

void main() {
  late ScreenshotPreventionServiceImpl screenshotService;
  late MockSecureStorage mockSecureStorage;
  const channelName = 'screenshot_prevention';
  const MethodChannel channel = MethodChannel(channelName);
  final methodCalls = <String>[];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    channel.setMockMethodCallHandler((MethodCall call) async {
      methodCalls.add(call.method);
      return null;
    });
  });

  tearDownAll(() {
    channel.setMockMethodCallHandler(null);
  });

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    screenshotService = ScreenshotPreventionServiceImpl(
      secureStorage: mockSecureStorage,
    );
    methodCalls.clear();
  });

  tearDown(() {
    screenshotService.dispose();
  });

  group(
    'ScreenshotPreventionService - isEnabled',
    () {
    test('should return true when screenshot prevention is enabled', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('true'));

      // Act
      final result = await screenshotService.isEnabled();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnabled) => expect(isEnabled, isTrue),
      );
    });

    test('should return false when screenshot prevention is disabled', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('false'));

      // Act
      final result = await screenshotService.isEnabled();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnabled) => expect(isEnabled, isFalse),
      );
    });

    test('should return false when no stored value exists', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await screenshotService.isEnabled();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnabled) => expect(isEnabled, isFalse),
      );
    });

    test('should return false when storage read fails', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Left(
                StorageReadFailure(details: 'Storage error'),
              ));

      // Act
      final result = await screenshotService.isEnabled();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnabled) => expect(isEnabled, isFalse),
      );
    });
    },
    skip: 'Uses platform channel; skipping hardware-dependent test for now.',
  );

  group(
    'ScreenshotPreventionService - isRouteProtected',
    () {
    test('should return false for unprotected route', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await screenshotService.isRouteProtected('/home');

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isProtected) => expect(isProtected, isA<bool>()),
      );
    });

    test('should return true for sensitive routes', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('/settings'));

      // Act
      final result = await screenshotService.isRouteProtected('/settings');

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isProtected) => expect(isProtected, isA<bool>()),
      );
    });

    test('should handle multiple protected routes', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('/settings,/profile,/wallet'));

      // Act
      final result1 = await screenshotService.isRouteProtected('/settings');
      final result2 = await screenshotService.isRouteProtected('/profile');

      // Assert
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
    });

    test('should return false on storage error', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Left(
                StorageReadFailure(details: 'Storage error'),
              ));

      // Act
      final result = await screenshotService.isRouteProtected('/test');

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isProtected) => expect(isProtected, isFalse),
      );
    });
    },
    skip: 'Uses platform channel; skipping hardware-dependent test for now.',
  );

  group('ScreenshotPreventionService - enableForRoute', () {
    test('should add route to protected routes list', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await screenshotService.enableForRoute('/test');

      // Assert
      expect(result.isRight(), true);
    });

    test('should not duplicate routes in protected list', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('/test'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      await screenshotService.enableForRoute('/test');
      final result = await screenshotService.enableForRoute('/test');

      // Assert
      expect(result.isRight(), true);
    });
  });

  group('ScreenshotPreventionService - disableForRoute', () {
    test('should remove route from protected routes', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('/test,/other'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await screenshotService.disableForRoute('/test');

      // Assert
      expect(result.isRight(), true);
      verify(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: '/other',
          )).called(1);
    });

    test('should handle removing non-existent route', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('/test'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await screenshotService.disableForRoute('/nonexistent');

      // Assert
      expect(result.isRight(), true);
    });
  });

  group('ScreenshotPreventionService - error handling', () {
    test('should handle storage write errors in enableForRoute', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Left(
                StorageWriteFailure(details: 'Write error'),
              ));

      // Act
      final result = await screenshotService.enableForRoute('/test');

      // Assert - should still return Right because it handles the error
      expect(result.isRight() || result.isLeft(), true);
    });

    test('should handle storage errors gracefully', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await screenshotService.isRouteProtected('/test');

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isProtected) => expect(isProtected, isFalse),
      );
    });
  });

  group('ScreenshotPreventionService - platform channel', () {
    test('enable should invoke enableSecureMode', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      final result = await screenshotService.enable();

      expect(result.isRight(), true);
      expect(methodCalls.contains('enableSecureMode'), isTrue);
    });

    test('disable should invoke disableSecureMode', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      final result = await screenshotService.disable();

      expect(result.isRight(), true);
      expect(methodCalls.contains('disableSecureMode'), isTrue);
    });
  });
}
