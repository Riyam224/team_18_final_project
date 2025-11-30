import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_user_credentials_usecase.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_state.dart';

class MockBiometricLoginUseCase extends Mock implements BiometricLoginUseCase {}

class MockStoreUserCredentialsUseCase extends Mock
    implements StoreUserCredentialsUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppLockService extends Mock implements IAppLockService {}

class MockSessionManager extends Mock implements ISessionManager {}

class FakeAuthFailure extends Fake implements AuthFailure {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthFailure());
  });

  late MockBiometricLoginUseCase mockLoginUseCase;
  late MockStoreUserCredentialsUseCase mockStoreCredentials;
  late MockAuthRepository mockRepository;
  late MockAppLockService mockAppLock;
  late MockSessionManager mockSessionManager;
  late BiometricVerifyCubit cubit;

  setUp(() {
    mockLoginUseCase = MockBiometricLoginUseCase();
    mockStoreCredentials = MockStoreUserCredentialsUseCase();
    mockRepository = MockAuthRepository();
    mockAppLock = MockAppLockService();
    mockSessionManager = MockSessionManager();

    cubit = BiometricVerifyCubit(
      biometricLoginUseCase: mockLoginUseCase,
      storeCredentials: mockStoreCredentials,
      repository: mockRepository,
      appLockService: mockAppLock,
      sessionManager: mockSessionManager,
    );
  });

  tearDown(() {
    cubit.close();
  });

  BiometricVerifyState _successStateMatcher(BiometricVerifyState state) =>
      state;

  group('verify()', () {
    test('emits once even when called multiple times', () async {
      final session = AuthSessionEntity(
        userId: 'u1',
        token: 't1',
        refreshToken: null,
        startedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      when(() => mockAppLock.updateActivity())
          .thenAnswer((_) async => const Right(null));
      when(() => mockAppLock.unlock())
          .thenAnswer((_) async => const Right(null));
      when(() => mockSessionManager.startSession(
            userId: any(named: 'userId'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => const Right(null));
      when(() => mockRepository.getBiometricType())
          .thenAnswer((_) async => const Right('fingerprint'));
      when(() => mockLoginUseCase())
          .thenAnswer((_) async => Right<AuthFailure, AuthSessionEntity>(session));
      when(() => mockStoreCredentials(
            userId: any(named: 'userId'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => Future.value());

      final emitted = <BiometricVerifyState>[];
      final sub = cubit.stream.listen(emitted.add);

      await cubit.verify();
      await cubit.verify(); // should be ignored by guard
      await Future.delayed(const Duration(milliseconds: 10));

      expect(emitted.length, 2);
      expect(emitted.first, isA<BiometricVerifyLoading>());
      expect(emitted.last, isA<BiometricVerifySuccess>());

      await sub.cancel();
    });

    test('does nothing when cubit is closed', () async {
      await cubit.close();
      await cubit.verify();
      expect(cubit.isClosed, isTrue);
    });
  });
}
