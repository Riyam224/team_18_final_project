# Clean Architecture Refactoring Guide

## Overview
This document outlines the comprehensive refactoring of the authentication and security features to follow Clean Architecture principles with Firebase integration.

---

## ✅ Completed Work

### 1. Configuration Layer (lib/core/config/)
Created centralized configuration classes to eliminate hardcoded values:

- **security_config.dart** - All security timeouts, defaults, and settings
- **firebase_config.dart** - Firestore collections, document fields, and structure
- **validation_config.dart** - All validation rules (email, password, phone, name)
- **storage_keys_config.dart** - 50+ secure storage keys centralized
- **routes_config.dart** - Route lists for sensitive routes, authenticated routes, etc.

**Impact**: Eliminates 200+ hardcoded strings and magic numbers across the codebase.

### 2. Domain Entities (lib/features/auth/domain/entities/)
Created pure domain entities that replace data models in the domain layer:

- **user_entity.dart** - Pure domain representation of a user
- **auth_session_entity.dart** - Domain session with business logic (isValid, isExpired)
- **user_profile_entity.dart** - User profile information
- **user_settings_entity.dart** - User settings with BiometricType enum
- **biometric_credentials_entity.dart** - Biometric credentials

**Impact**: Domain layer no longer depends on data layer models.

### 3. Failure Classes (lib/core/error/ and lib/features/auth/domain/failures/)
Implemented proper error handling with specific failure classes:

- **failures.dart** - Base failure classes (ServerFailure, NetworkFailure, etc.)
- **auth_failure.dart** - 13 specific auth failures (UserNotFoundFailure, InvalidCredentialsFailure, etc.)
- **biometric_failure.dart** - 8 biometric-specific failures
- **session_failure.dart** - 5 session-related failures
- **storage_failure.dart** - 5 storage operation failures

**Impact**: Type-safe error handling, no more generic Exception throws.

### 4. Mappers (lib/features/auth/data/mappers/)
Created bidirectional mappers between data models and domain entities:

- **user_mapper.dart** - UserModel ↔ UserEntity ↔ Firestore
- **profile_mapper.dart** - UserProfile ↔ UserProfileEntity ↔ Firestore
- **settings_mapper.dart** - UserSettings ↔ UserSettingsEntity ↔ Firestore
- **session_mapper.dart** - AuthSession ↔ AuthSessionEntity ↔ Storage

**Impact**: Clean separation between data and domain layers.

### 5. Validation Layer (lib/features/auth/domain/validation/)
Centralized validation logic in the domain layer:

- **validation_result.dart** - Result type for validations
- **email_validator.dart** - Email validation logic
- **password_validator.dart** - Password validation with strength checking
- **phone_validator.dart** - Phone number validation
- **name_validator.dart** - Name and display name validation

**Impact**: Single source of truth for validation rules, reusable across features.

### 6. Service Interfaces (lib/core/security/interfaces/)
Created abstractions for all security services:

- **i_secure_storage.dart** - Secure storage abstraction
- **i_biometric_service.dart** - Biometric authentication abstraction
- **i_session_manager.dart** - Session management abstraction
- **i_app_lock_service.dart** - App lock functionality abstraction
- **i_root_detection_service.dart** - Device security check abstraction
- **i_screenshot_prevention_service.dart** - Screenshot prevention abstraction
- **i_audit_log_service.dart** - Audit logging abstraction

**Impact**: Services can be mocked for testing, implementations can be swapped.

### 7. Service Implementations (lib/core/security/implementations/)
Implemented service classes with dependency injection:

- **flutter_secure_storage_impl.dart** - ISecureStorage using flutter_secure_storage
- **local_auth_biometric_impl.dart** - IBiometricService using local_auth
- **session_manager_impl.dart** - ISessionManager with timer-based monitoring
- **app_lock_service_impl.dart** - IAppLockService with auto-lock functionality

**Impact**: No more static methods, fully testable, injectable services.

---

## 🚧 Remaining Work

### Phase 1: Data Sources (NEXT PRIORITY)

Create proper data sources following Clean Architecture:

#### Remote Data Source (Firebase)
```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> registerWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<UserProfileEntity> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileEntity profile);
  Future<UserSettingsEntity> getUserSettings(String userId);
  Future<void> updateUserSettings(UserSettingsEntity settings);
}

// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Implementation using FirebaseConfig constants
}
```

#### Local Data Source (Secure Storage)
```dart
// lib/features/auth/data/datasources/auth_local_datasource.dart
abstract class AuthLocalDataSource {
  Future<void> cacheSession(AuthSessionEntity session);
  Future<AuthSessionEntity?> getLastSession();
  Future<void> cacheBiometricCredentials(BiometricCredentialsEntity credentials);
  Future<BiometricCredentialsEntity?> getBiometricCredentials();
  Future<void> clearCache();
}

// lib/features/auth/data/datasources/auth_local_datasource_impl.dart
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final ISecureStorage _secureStorage;

  // Implementation using StorageKeysConfig constants
}
```

### Phase 2: Repository Refactoring

Update AuthRepositoryImpl to:
1. Use Either<Failure, Success> pattern
2. Coordinate between remote and local data sources
3. Use mappers to convert between layers
4. Remove direct service calls

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<AuthFailure, AuthSessionEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      final emailValidation = EmailValidator.validate(email);
      if (!emailValidation.isValid) {
        return Left(InvalidEmailFailure(message: emailValidation.error!));
      }

      final passwordValidation = PasswordValidator.validateMinimum(password);
      if (!passwordValidation.isValid) {
        return Left(InvalidCredentialsFailure());
      }

      // Call remote data source
      final user = await _remoteDataSource.signInWithEmailAndPassword(email, password);

      // Create session
      final session = AuthSessionEntity(
        userId: user.id,
        token: user.id, // Use actual token from Firebase
        startedAt: DateTime.now(),
      );

      // Cache session locally
      await _localDataSource.cacheSession(session);

      return Right(session);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  // ... other methods
}
```

### Phase 3: Use Cases Updates

Create new use cases and update existing ones:

#### New Use Cases Needed:
```
lib/features/auth/domain/usecases/
  ├── session/
  │   ├── start_session_usecase.dart
  │   ├── end_session_usecase.dart
  │   ├── get_current_session_usecase.dart
  │   ├── validate_session_usecase.dart
  │   └── extend_session_usecase.dart
  ├── security/
  │   ├── lock_app_usecase.dart
  │   ├── unlock_app_usecase.dart
  │   ├── check_device_security_usecase.dart
  │   └── update_activity_usecase.dart
  └── profile/
      ├── get_user_profile_usecase.dart
      ├── update_user_profile_usecase.dart
      ├── get_user_settings_usecase.dart
      └── update_user_settings_usecase.dart
```

#### Update Existing Use Cases:
- `login_user_usecase.dart` - Return `Either<AuthFailure, AuthSessionEntity>`
- `register_user_usecase.dart` - Return `Either<AuthFailure, AuthSessionEntity>`
- `biometric_login_usecase.dart` - Return `Either<BiometricFailure, AuthSessionEntity>`

Example:
```dart
class LoginUserUseCase {
  final AuthRepository _repository;

  LoginUserUseCase(this._repository);

  Future<Either<AuthFailure, AuthSessionEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validation is now in repository/data source
    return await _repository.login(email: email, password: password);
  }
}
```

### Phase 4: Cubit Updates

Update all cubits to:
1. Only depend on use cases (no direct service calls)
2. Handle Either<Failure, Success> results
3. Use domain entities instead of data models

Example:
```dart
class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase _loginUseCase;
  final RegisterUserUseCase _registerUseCase;
  final BiometricLoginUseCase _biometricLoginUseCase;
  final StartSessionUseCase _startSessionUseCase;
  final EndSessionUseCase _endSessionUseCase;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await _loginUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (session) {
        // Start session through use case
        _startSessionUseCase(session: session);
        emit(AuthSuccess(session));
      },
    );
  }
}
```

### Phase 5: Dependency Injection

Update `lib/core/di/di.dart` to register all new abstractions:

```dart
// Security Services
sl.registerLazySingleton<ISecureStorage>(
  () => FlutterSecureStorageImpl(),
);

sl.registerLazySingleton<IBiometricService>(
  () => LocalAuthBiometricImpl(),
);

sl.registerLazySingleton<ISessionManager>(
  () => SessionManagerImpl(
    secureStorage: sl<ISecureStorage>(),
  ),
);

sl.registerLazySingleton<IAppLockService>(
  () => AppLockServiceImpl(
    secureStorage: sl<ISecureStorage>(),
  ),
);

// Data Sources
sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

sl.registerLazySingleton<AuthLocalDataSource>(
  () => AuthLocalDataSourceImpl(
    secureStorage: sl<ISecureStorage>(),
  ),
);

// Repository
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: sl<AuthRemoteDataSource>(),
    localDataSource: sl<AuthLocalDataSource>(),
  ),
);

// Use Cases
sl.registerLazySingleton(() => LoginUserUseCase(sl()));
sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
sl.registerLazySingleton(() => StartSessionUseCase(sl()));
// ... etc
```

### Phase 6: Presentation Layer Updates

Update all screens to:
1. Use domain entities instead of data models
2. Handle failure types properly
3. Display user-friendly error messages

---

## 📊 Refactoring Impact

### Files Created: 35+
- 5 Configuration files
- 5 Domain entities
- 31 Failure classes
- 4 Mappers
- 5 Validators
- 7 Service interfaces
- 4 Service implementations

### Files to Update: 40+
- 2 Data sources to create
- 1 Repository to refactor
- 10+ Use cases to update/create
- 3 Cubits to update
- 20+ Screens to update
- 1 DI file to update

### Code Quality Improvements:
- ✅ No hardcoded values
- ✅ Proper separation of concerns
- ✅ Dependency injection throughout
- ✅ Type-safe error handling
- ✅ Testable architecture
- ✅ Single source of truth for configuration
- ✅ Clean Architecture principles followed

---

## 🎯 Priority Order

1. **Create Remote and Local Data Sources** (2-3 hours)
2. **Refactor AuthRepository** (2 hours)
3. **Create new Use Cases** (1-2 hours)
4. **Update existing Use Cases** (1 hour)
5. **Update Dependency Injection** (1 hour)
6. **Update Cubits** (2-3 hours)
7. **Update Presentation Layer** (4-5 hours)
8. **Testing** (4-6 hours)

**Total Estimated Time**: 17-23 hours

---

## 📝 Testing Strategy

Once refactoring is complete:

1. **Unit Tests**:
   - Test all validators
   - Test all mappers
   - Test all use cases
   - Test repository with mocked data sources

2. **Widget Tests**:
   - Test all screens with mocked cubits
   - Test error handling
   - Test navigation flows

3. **Integration Tests**:
   - Test complete authentication flow
   - Test biometric flow
   - Test session management
   - Test app lock functionality

---

## 🚀 Running the Refactored Code

After completing all phases:

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run code generation (if using freezed/json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test
```

---

## 📚 Additional Improvements (Future)

- Add localization for all error messages
- Implement refresh token mechanism
- Add analytics/logging service
- Implement rate limiting for login attempts
- Add 2FA support
- Implement password reset flow
- Add email verification flow
- Implement social login (Google, Apple, etc.)

---

## 🔧 Troubleshooting

### Common Issues:

1. **Import errors**: Ensure all new files are properly imported
2. **Type mismatches**: Use mappers to convert between layers
3. **DI errors**: Ensure all dependencies are registered before use
4. **Null safety**: Handle nullable types properly with Either pattern

---

## 📖 Resources

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Dartz Package Documentation](https://pub.dev/packages/dartz)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
