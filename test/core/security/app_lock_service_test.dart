import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/implementations/app_lock_service_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:fake_async/fake_async.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}

void main() {
  late AppLockServiceImpl appLockService;
  late MockSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    appLockService = AppLockServiceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  tearDown(() {
    appLockService.dispose();
  });

  group('AppLockService', () {
    test('should return false when appLocked flag is not set', () async {
      when(() => mockSecureStorage.read(
            key: StorageKeysConfig.appLocked,
          )).thenAnswer((_) async => const Right(null));

      final result = await appLockService.isLocked();

      result.fold(
        (failure) => fail('Should not fail'),
        (isLocked) => expect(isLocked, isFalse),
      );
      verify(() => mockSecureStorage.read(key: StorageKeysConfig.appLocked))
          .called(1);
    });

    test('should return true when appLocked flag is true', () async {
      when(() => mockSecureStorage.read(
            key: StorageKeysConfig.appLocked,
          )).thenAnswer((_) async => const Right('true'));

      final result = await appLockService.isLocked();

      result.fold(
        (failure) => fail('Should not fail'),
        (isLocked) => expect(isLocked, isTrue),
      );
      verify(() => mockSecureStorage.read(key: StorageKeysConfig.appLocked))
          .called(1);
    });

    test('should set auto-lock timeout', () async {
      // Arrange
      const newTimeout = Duration(seconds: 120);
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await appLockService.setAutoLockTimeout(newTimeout);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: '120',
          )).called(1);
    });

    test('should get auto-lock timeout', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('120'));

      // Act
      final result = await appLockService.getAutoLockTimeout();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (timeout) => expect(timeout, equals(const Duration(seconds: 120))),
      );
    });

    test('lock() and unlock() should update flag and emit stream events', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      final stream = appLockService.lockStateStream.take(2);

      await appLockService.lock();
      await appLockService.unlock();

      await expectLater(stream, emitsInOrder([true, false]));
    });

    test('should start auto-lock timer and lock after timeout', () async {
      // Arrange mock reads/writes
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((invocation) async {
        final key = invocation.namedArguments[#key] as String;
        if (key == StorageKeysConfig.autoLockEnabled) {
          return const Right('true');
        }
        if (key == StorageKeysConfig.autoLockTimeout) {
          return const Right('1'); // 1 second
        }
        if (key == StorageKeysConfig.lastActivityTime) {
          final past = DateTime.now().subtract(const Duration(seconds: 5));
          return Right(past.toIso8601String());
        }
        if (key == StorageKeysConfig.appLocked) {
          return const Right('false');
        }
        return const Right(null);
      });

      fakeAsync((async) {
        // Start timer via updateActivity
        appLockService.updateActivity();
        // Fast-forward past timeout
        async.elapse(const Duration(seconds: 2));
      });

      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.appLocked,
            value: 'true',
          )).called(greaterThanOrEqualTo(1));
    });
  });
}
