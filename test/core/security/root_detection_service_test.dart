@Skip('Skipped – depends on hardware/platform and must be mocked')
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/security/implementations/root_detection_service_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';

void main() {
  late RootDetectionServiceImpl rootDetectionService;

  setUp(() {
    rootDetectionService = RootDetectionServiceImpl();
  });

  group('RootDetectionService - isDeviceRooted', () {
    test('should return Right when checking device rooted status', () async {
      // Act
      final result = await rootDetectionService.isDeviceRooted();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return bool value for rooted status', () async {
      // Act
      final result = await rootDetectionService.isDeviceRooted();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isRooted) => expect(isRooted, isA<bool>()),
      );
    });
  });

  group('RootDetectionService - isOnEmulator', () {
    test('should return Right when checking emulator status', () async {
      // Act
      final result = await rootDetectionService.isOnEmulator();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return bool value for emulator status', () async {
      // Act
      final result = await rootDetectionService.isOnEmulator();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isEmulator) => expect(isEmulator, isA<bool>()),
      );
    });
  });

  group('RootDetectionService - isMockLocationEnabled', () {
    test('should return Right(false) for mock location', () async {
      // Act
      final result = await rootDetectionService.isMockLocationEnabled();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (isMock) => expect(isMock, isFalse),
      );
    });
  });

  group('RootDetectionService - isDeveloperModeEnabled', () {
    test('should return Right when checking developer mode', () async {
      // Act
      final result = await rootDetectionService.isDeveloperModeEnabled();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return bool value for developer mode status', () async {
      // Act
      final result = await rootDetectionService.isDeveloperModeEnabled();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isDev) => expect(isDev, isA<bool>()),
      );
    });
  });

  group('RootDetectionService - performSecurityCheck', () {
    test('should return SecurityCheckResult', () async {
      // Act
      final result = await rootDetectionService.performSecurityCheck();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (checkResult) {
          expect(checkResult, isA<SecurityCheckResult>());
          expect(checkResult.isSecure, isA<bool>());
          expect(checkResult.message, isA<String>());
          expect(checkResult.warnings, isA<List<String>>());
        },
      );
    });

    test('should include appropriate message in security check', () async {
      // Act
      final result = await rootDetectionService.performSecurityCheck();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (checkResult) {
          expect(checkResult.message.isNotEmpty, true);
        },
      );
    });

    test('should return warnings list', () async {
      // Act
      final result = await rootDetectionService.performSecurityCheck();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (checkResult) {
          expect(checkResult.warnings, isNotNull);
        },
      );
    });
  });

  group('RootDetectionService - isDeviceSecure', () {
    test('should return Right when checking device security', () async {
      // Act
      final result = await rootDetectionService.isDeviceSecure();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return bool value for device security', () async {
      // Act
      final result = await rootDetectionService.isDeviceSecure();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isSecure) => expect(isSecure, isA<bool>()),
      );
    });

    test('should match performSecurityCheck result', () async {
      // Act
      final securityCheckResult = await rootDetectionService.performSecurityCheck();
      final isSecureResult = await rootDetectionService.isDeviceSecure();

      // Assert
      final expectedIsSecure = securityCheckResult.fold(
        (failure) => false,
        (checkResult) => checkResult.isSecure,
      );

      final actualIsSecure = isSecureResult.fold(
        (failure) => false,
        (isSecure) => isSecure,
      );

      expect(actualIsSecure, equals(expectedIsSecure));
    });
  });
}
