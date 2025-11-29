# Quick Start Guide - Clean Architecture Implementation

## 📁 New File Structure

```
lib/
├── core/
│   ├── config/                          ✅ NEW - All configuration
│   │   ├── firebase_config.dart
│   │   ├── routes_config.dart
│   │   ├── security_config.dart
│   │   ├── storage_keys_config.dart
│   │   └── validation_config.dart
│   ├── error/                           ✅ UPDATED
│   │   └── failures.dart                ✅ NEW - Base failures
│   └── security/
│       ├── interfaces/                   ✅ NEW - Service abstractions
│       │   ├── i_app_lock_service.dart
│       │   ├── i_audit_log_service.dart
│       │   ├── i_biometric_service.dart
│       │   ├── i_root_detection_service.dart
│       │   ├── i_screenshot_prevention_service.dart
│       │   ├── i_secure_storage.dart
│       │   └── i_session_manager.dart
│       └── implementations/              ✅ NEW - Service implementations
│           ├── app_lock_service_impl.dart
│           ├── flutter_secure_storage_impl.dart
│           ├── local_auth_biometric_impl.dart
│           └── session_manager_impl.dart
│
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/              ✅ NEW - Data sources
        │   │   ├── auth_local_datasource.dart
        │   │   ├── auth_local_datasource_impl.dart
        │   │   ├── auth_remote_datasource.dart
        │   │   └── auth_remote_datasource_impl.dart
        │   ├── mappers/                  ✅ NEW - Data ↔ Domain
        │   │   ├── profile_mapper.dart
        │   │   ├── session_mapper.dart
        │   │   ├── settings_mapper.dart
        │   │   └── user_mapper.dart
        │   ├── models/                   ✅ EXISTING
        │   └── repositories/             ⏳ TO UPDATE
        │       └── auth_repository_impl.dart
        ├── domain/
        │   ├── entities/                 ✅ NEW - Pure domain
        │   │   ├── auth_session_entity.dart
        │   │   ├── biometric_credentials_entity.dart
        │   │   ├── user_entity.dart
        │   │   ├── user_profile_entity.dart
        │   │   └── user_settings_entity.dart
        │   ├── failures/                 ✅ NEW - Domain errors
        │   │   ├── auth_failure.dart
        │   │   ├── biometric_failure.dart
        │   │   ├── session_failure.dart
        │   │   └── storage_failure.dart
        │   ├── repositories/             ✅ EXISTING
        │   ├── usecases/                 ⏳ TO UPDATE
        │   └── validation/               ✅ NEW - Validators
        │       ├── email_validator.dart
        │       ├── name_validator.dart
        │       ├── password_validator.dart
        │       ├── phone_validator.dart
        │       └── validation_result.dart
        └── presentation/                 ⏳ TO UPDATE
```

---

## 🚀 How to Use the New Architecture

### 1. Using Configuration

**Before**:
```dart
const timeout = 120; // hardcoded
final regex = RegExp(r'^[a-zA-Z...'); // duplicated
await storage.write('user_id', userId); // magic string
```

**After**:
```dart
SecurityConfig.autoLockTimeoutSeconds
ValidationConfig.emailRegex
StorageKeysConfig.userId
FirebaseConfig.usersCollection
RoutesConfig.sensitiveRoutes
```

### 2. Using Validators

**Before**:
```dart
if (!email.contains('@')) {
  return 'Invalid email';
}
```

**After**:
```dart
final result = EmailValidator.validate(email);
if (!result.isValid) {
  return result.error; // "Please enter a valid email address"
}

// Or quick boolean check
if (EmailValidator.isValid(email)) { ... }
```

**All Validators**:
```dart
EmailValidator.validate(email)
PasswordValidator.validate(password)
PasswordValidator.validateMinimum(password)
PasswordValidator.validateConfirmation(password, confirmation)
PasswordValidator.getPasswordStrength(password) // 0-4
PhoneValidator.validate(phone)
PhoneValidator.validateRequired(phone)
NameValidator.validate(name)
NameValidator.validateDisplayName(displayName)
```

### 3. Using Entities

**Before** (data models in domain):
```dart
final user = UserModel(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  phone: '1234567890',
  password: 'password', // 🚨 password in domain!
  biometricEnabled: false,
);
```

**After** (pure domain entities):
```dart
final user = UserEntity(
  id: 'user123',
  email: 'john@example.com',
  displayName: 'John Doe',
  phoneNumber: '1234567890',
  isEmailVerified: false,
  createdAt: DateTime.now(),
);

// With business logic
if (session.isExpired) { ... }
if (session.isValid) { ... }
```

### 4. Using Mappers

```dart
// Firebase User → Domain Entity
final entity = UserMapper.fromFirebaseUser(firebaseUser);

// Domain Entity → Firestore Map
final firestoreData = UserMapper.toFirestore(userEntity);

// Domain Entity ↔ Data Model
final entity = ProfileMapper.fromModel(userProfile, userId);
final model = ProfileMapper.toModel(profileEntity);

// Session with JSON
final json = SessionMapper.toJson(sessionEntity);
final entity = SessionMapper.fromJson(json);
```

### 5. Using Failures

**Before**:
```dart
try {
  await firebaseAuth.signIn(...);
} catch (e) {
  throw Exception(e.toString()); // 🚨 Generic!
}
```

**After**:
```dart
try {
  final user = await remoteDataSource.signIn(...);
  return Right(user);
} on FirebaseAuthException catch (e) {
  return Left(_mapException(e));
}

AuthFailure _mapException(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return const UserNotFoundFailure();
    case 'wrong-password':
      return const InvalidCredentialsFailure();
    // ... etc
  }
}
```

**Available Failures**:
```dart
// Auth
UserNotFoundFailure()
InvalidCredentialsFailure()
EmailAlreadyExistsFailure()
WeakPasswordFailure()
InvalidEmailFailure()
AccountDisabledFailure()
TooManyRequestsFailure()
AuthNetworkFailure()

// Biometric
BiometricNotAvailableFailure()
BiometricNotEnrolledFailure()
BiometricAuthFailedFailure()
BiometricAuthCanceledFailure()
BiometricLockoutFailure()

// Session
SessionExpiredFailure()
InvalidSessionFailure()
SessionNotFoundFailure()

// Storage
StorageReadFailure()
StorageWriteFailure()
DataNotFoundFailure()
```

### 6. Using Services (Dependency Injection)

**Before** (static methods):
```dart
await SecureStorageService.write('key', 'value'); // 🚨 Static, untestable
await LocalAuthService.authenticate(); // 🚨 Static
SessionManager.startSession(userId, token); // 🚨 Static
```

**After** (injected services):
```dart
class SomeClass {
  final ISecureStorage _storage;
  final IBiometricService _biometric;
  final ISessionManager _session;

  SomeClass({
    required ISecureStorage storage,
    required IBiometricService biometric,
    required ISessionManager session,
  }) : _storage = storage,
       _biometric = biometric,
       _session = session;

  Future<void> doSomething() async {
    final result = await _storage.write(key: 'key', value: 'value');
    result.fold(
      (failure) => print('Error: ${failure.message}'),
      (_) => print('Success'),
    );

    final authResult = await _biometric.authenticate(
      localizedReason: 'Please authenticate',
    );
    // ... etc
  }
}
```

### 7. Using Data Sources

**Remote Data Source** (Firebase operations):
```dart
// In repository
final user = await _remoteDataSource.signInWithEmailAndPassword(
  email: email,
  password: password,
);

final profile = await _remoteDataSource.getUserProfile(userId);
await _remoteDataSource.updateUserProfile(profileEntity);

final settings = await _remoteDataSource.getUserSettings(userId);
await _remoteDataSource.updateUserSettings(settingsEntity);
```

**Local Data Source** (Caching):
```dart
// In repository
await _localDataSource.cacheSession(sessionEntity);
final session = await _localDataSource.getLastSession();

await _localDataSource.cacheBiometricCredentials(credentials);
final creds = await _localDataSource.getBiometricCredentials();

await _localDataSource.cacheUser(userEntity);
```

### 8. Repository Pattern (Either)

**Implementation**:
```dart
@override
Future<Either<AuthFailure, AuthSessionEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    // 1. Validate
    final emailValidation = EmailValidator.validate(email);
    if (!emailValidation.isValid) {
      return Left(InvalidEmailFailure(message: emailValidation.error!));
    }

    // 2. Call remote data source
    final user = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 3. Create domain entity
    final session = AuthSessionEntity(
      userId: user.id,
      token: user.id,
      startedAt: DateTime.now(),
    );

    // 4. Cache locally
    await _localDataSource.cacheSession(session);
    await _localDataSource.cacheUser(user);

    // 5. Return success
    return Right(session);
  } on FirebaseAuthException catch (e) {
    return Left(_mapFirebaseAuthException(e));
  } catch (e) {
    return Left(GenericAuthFailure(details: e.toString()));
  }
}
```

**Usage in Use Case**:
```dart
class LoginUserUseCase {
  final AuthRepository _repository;

  Future<Either<AuthFailure, AuthSessionEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
```

**Usage in Cubit**:
```dart
Future<void> login(String email, String password) async {
  emit(AuthLoading());

  final result = await _loginUseCase(
    email: email,
    password: password,
  );

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (session) => emit(AuthSuccess(session)),
  );
}
```

---

## 🔧 Common Patterns

### Pattern 1: Validation in Repository
```dart
Future<Either<AuthFailure, T>> someMethod(String email) async {
  // Always validate at repository level
  final validation = EmailValidator.validate(email);
  if (!validation.isValid) {
    return Left(InvalidEmailFailure(message: validation.error!));
  }

  // Proceed with operation...
}
```

### Pattern 2: Exception Mapping
```dart
try {
  // Firebase operation
} on FirebaseAuthException catch (e) {
  return Left(_mapFirebaseAuthException(e));
} on FirebaseException catch (e) {
  return Left(_mapFirebaseException(e));
} catch (e) {
  return Left(GenericAuthFailure(details: e.toString()));
}
```

### Pattern 3: Mapper Usage
```dart
// Always use mappers between layers
final user = await _remoteDataSource.signIn(email, password);
final userEntity = UserMapper.fromFirebaseUser(user); // Data → Domain

final firestoreData = ProfileMapper.toFirestore(profileEntity); // Domain → Data
await _firestore.collection('users').doc(id).set(firestoreData);
```

### Pattern 4: Service Injection
```dart
// In di.dart
sl.registerLazySingleton<ISecureStorage>(
  () => FlutterSecureStorageImpl(),
);

// In class
class MyRepository {
  final ISecureStorage _storage;
  MyRepository({required ISecureStorage storage}) : _storage = storage;
}

// Get from DI
final repo = MyRepository(storage: sl<ISecureStorage>());
```

---

## 📝 Cheat Sheet

### Config Access
```dart
SecurityConfig.sessionTimeout
FirebaseConfig.usersCollection
ValidationConfig.emailRegex
StorageKeysConfig.userId
RoutesConfig.sensitiveRoutes
```

### Validation
```dart
EmailValidator.validate(email).isValid
PasswordValidator.validate(password).error
PhoneValidator.clean(phone)
PasswordValidator.getPasswordStrength(password)
```

### Mappers
```dart
UserMapper.fromFirebaseUser(fbUser)
UserMapper.toFirestore(entity)
SessionMapper.toJson(entity)
SessionMapper.fromJson(json)
SettingsMapper.biometricTypeToString(type)
```

### Failures
```dart
const UserNotFoundFailure()
InvalidCredentialsFailure(message: 'Custom')
Left(BiometricNotAvailableFailure())
```

### Either Pattern
```dart
result.fold(
  (failure) => handleError(failure),
  (success) => handleSuccess(success),
)

result.isLeft() // true if failure
result.isRight() // true if success
result.getOrElse(() => defaultValue)
```

---

## 🎯 Next Steps for You

1. **Review the architecture**
   - Read `CLEAN_ARCHITECTURE_SUMMARY.md`
   - Understand the layer separation
   - Review created files

2. **Complete repository refactoring**
   - Start with `auth_repository_impl.dart`
   - Follow the pattern in this guide
   - Use data sources, not direct Firebase

3. **Update dependency injection**
   - Register all services
   - Register all data sources
   - Register all use cases

4. **Update use cases**
   - Return Either types
   - Remove infrastructure dependencies
   - Add validation

5. **Update cubits**
   - Inject use cases
   - Handle Either results
   - Use domain entities

6. **Update screens**
   - Display proper errors
   - Use domain entities
   - Better UX

---

## 📚 Documentation Links

- Main refactoring guide: `REFACTORING_GUIDE.md`
- Complete summary: `CLEAN_ARCHITECTURE_SUMMARY.md`
- This guide: `QUICK_START_GUIDE.md`

---

**Remember**:
- ✅ Configuration classes for ALL constants
- ✅ Validators for ALL input validation
- ✅ Mappers between ALL layers
- ✅ Either for ALL operations
- ✅ Entities in domain, Models in data
- ✅ Inject services, never use static

Good luck! 🚀
