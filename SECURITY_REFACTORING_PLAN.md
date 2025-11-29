# Security Module Refactoring Plan

## Current Issues

Your security module has **architectural debt** that violates Clean Architecture and SOLID principles:

### Problems Identified

1. **Mixed Paradigms**: You have both old static services and new interface-based services coexisting
2. **Dependency Inversion Violation**: Old services (`AppLockService`, `BiometricService`, etc.) are static utility classes, making them impossible to mock or swap
3. **Single Responsibility Violation**: `SecureStorageService` has 300+ lines with mixed concerns (auth, biometric, sessions, transactions, user data)
4. **Tight Coupling**: Many files still depend on concrete implementations instead of interfaces
5. **No Testability**: Static services cannot be properly unit tested

## Current State Analysis

### Old Pattern (❌ Violations)
```dart
// lib/core/security/app_lock_service.dart
class AppLockService {
  static Future<void> resetLock() async {
    await SecureStorageService.saveAutoLockActivity();  // Tight coupling
  }
}

// lib/core/security/biometric_service.dart
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();  // Hard dependency
}

// lib/core/security/secure_storage_service.dart
class SecureStorageService {
  static const _storage = FlutterSecureStorage(...);  // Static singleton
  static Future<void> write(String key, String value) async {...}
  // 300+ lines of mixed responsibilities
}
```

**Issues:**
- Static methods = cannot inject dependencies = cannot test
- Tight coupling to concrete implementations
- God object anti-pattern (`SecureStorageService` does everything)

### New Pattern (✅ Clean Architecture)
```dart
// lib/core/security/interfaces/i_app_lock_service.dart
abstract class IAppLockService {
  Future<Either<Failure, void>> resetLock();  // Returns typed errors
}

// lib/core/security/implementations/app_lock_service_impl.dart
class AppLockServiceImpl implements IAppLockService {
  final ISecureStorage _secureStorage;  // Dependency injection
  AppLockServiceImpl({required ISecureStorage secureStorage})
      : _secureStorage = secureStorage;
}

// lib/core/di/di.dart
sl.registerLazySingleton<IAppLockService>(
  () => AppLockServiceImpl(secureStorage: sl<ISecureStorage>()),
);
```

**Benefits:**
- Dependency injection enables testing
- Either monad for type-safe error handling
- Single responsibility per service
- Loose coupling through interfaces

## Migration Strategy

### Phase 1: Create Missing Interfaces ✅ (Partially Done)

**Completed:**
- ✅ `IAppLockService` + `AppLockServiceImpl`
- ✅ `IBiometricService` + `LocalAuthBiometricImpl`
- ✅ `ISecureStorage` + `FlutterSecureStorageImpl`
- ✅ `ISessionManager` + `SessionManagerImpl`

**Needed:**
- ❌ `IAuditLogService` + implementation
- ❌ `IScreenshotPreventionService` + implementation
- ❌ `IRootDetectionService` + implementation
- ❌ `IBlurService` + implementation

### Phase 2: Refactor Usage Points

Replace all static service calls with injected interfaces:

```dart
// ❌ BEFORE (25 files affected)
import 'package:team_18_final_project/core/security/app_lock_service.dart';

await AppLockService.resetLock();
await SecureStorageService.saveAuthToken(token);
```

```dart
// ✅ AFTER
class LoginScreen extends StatelessWidget {
  final IAppLockService appLockService;
  final ISecureStorage secureStorage;

  const LoginScreen({
    required this.appLockService,
    required this.secureStorage,
  });

  void _onLogin() async {
    await appLockService.resetLock();
    await secureStorage.write(key: 'auth_token', value: token);
  }
}
```

### Phase 3: Break Down God Objects

**Current:** `SecureStorageService` has 339 lines doing everything

**Refactor to:**
```
lib/core/security/
├── interfaces/
│   ├── i_secure_storage.dart          # Generic key-value storage
│   ├── i_auth_credential_store.dart   # Auth tokens, user credentials
│   ├── i_biometric_store.dart         # Biometric settings
│   └── i_session_store.dart           # Session/lock timestamps
└── implementations/
    ├── flutter_secure_storage_impl.dart
    ├── auth_credential_store_impl.dart
    ├── biometric_store_impl.dart
    └── session_store_impl.dart
```

Apply **Single Responsibility Principle** - each store manages one concern.

### Phase 4: Remove Legacy Code

After migration is complete, delete:
- `app_lock_service.dart` (replaced by `IAppLockService`)
- `biometric_service.dart` (replaced by `IBiometricService`)
- `secure_storage_service.dart` (replaced by domain-specific stores)
- `session_manager.dart` (replaced by `ISessionManager`)
- `audit_log_service.dart` (after interface created)
- `screenshot_prevention_service.dart` (after interface created)
- `root_detection_service.dart` (after interface created)
- `blur_service.dart` (after interface created)
- `local_auth_service.dart`
- `screenshot_prevention.dart`
- `root_detection.dart`

## File Structure (Target)

```
lib/core/security/
├── interfaces/              # Abstractions (Depend on these)
│   ├── i_app_lock_service.dart
│   ├── i_audit_log_service.dart
│   ├── i_biometric_service.dart
│   ├── i_root_detection_service.dart
│   ├── i_screenshot_prevention_service.dart
│   ├── i_secure_storage.dart
│   ├── i_session_manager.dart
│   └── i_blur_service.dart
├── implementations/         # Concrete implementations
│   ├── app_lock_service_impl.dart
│   ├── flutter_secure_storage_impl.dart
│   ├── local_auth_biometric_impl.dart
│   └── session_manager_impl.dart
└── [DELETED OLD FILES]
```

## SOLID Principles Applied

### ✅ Single Responsibility Principle (SRP)
Each service has one reason to change:
- `IAppLockService`: Only app locking logic
- `IBiometricService`: Only biometric authentication
- `ISecureStorage`: Only generic storage operations

### ✅ Open/Closed Principle (OCP)
Can add new implementations without modifying existing code:
```dart
// Tomorrow you can add HiveBiometricStore without breaking anything
sl.registerLazySingleton<IBiometricService>(
  () => HiveBiometricStore(), // New implementation
);
```

### ✅ Liskov Substitution Principle (LSP)
Any `IBiometricService` implementation can replace another:
```dart
// Works with LocalAuthBiometricImpl
final auth = sl<IBiometricService>();

// Works with MockBiometricService in tests
final auth = MockBiometricService();
```

### ✅ Interface Segregation Principle (ISP)
Clients depend only on methods they use:
```dart
// Login screen only needs biometric, not storage
class LoginScreen {
  final IBiometricService biometricService;  // Not entire security module
}
```

### ✅ Dependency Inversion Principle (DIP)
High-level modules depend on abstractions, not concretions:
```dart
// ✅ AuthCubit depends on interface
class AuthCubit {
  final IBiometricService _biometricService;  // Abstract
}

// ❌ OLD: AuthCubit depends on concrete class
class AuthCubit {
  void login() {
    BiometricService.authenticate();  // Static, concrete
  }
}
```

## Clean Code Improvements

### 1. Type-Safe Error Handling
```dart
// ✅ NEW: Explicit error types
Future<Either<BiometricFailure, bool>> authenticate();

// ❌ OLD: Silent failures
Future<bool> authenticate() {
  try { ... } catch (_) { return false; }  // Lost error context
}
```

### 2. Dependency Injection
```dart
// ✅ NEW: Constructor injection
class AppLockServiceImpl implements IAppLockService {
  final ISecureStorage _secureStorage;
  AppLockServiceImpl({required ISecureStorage secureStorage});
}

// ❌ OLD: Hard-coded dependencies
class AppLockService {
  static Future<void> resetLock() {
    SecureStorageService.save(...);  // Can't swap or mock
  }
}
```

### 3. Testability
```dart
// ✅ NEW: Easy to test
test('should lock app after timeout', () {
  final mockStorage = MockSecureStorage();
  final service = AppLockServiceImpl(secureStorage: mockStorage);
  // Test with mock
});

// ❌ OLD: Impossible to test
test('should lock app', () {
  // Can't mock AppLockService.shouldLock() - it's static!
});
```

## Files Requiring Updates (25 total)

### Critical (Presentation Layer)
1. `lib/features/auth/presentation/screens/login/login_screen.dart`
2. `lib/features/auth/presentation/screens/register/register_screen.dart`
3. `lib/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart`
4. `lib/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart`
5. `lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart`
6. `lib/features/settings/presentation/screens/settings_screen.dart`
7. `lib/features/home/presentation/screens/home_screen.dart`

### Infrastructure
8. `lib/main.dart`
9. `lib/core/observers/app_route_observer.dart`
10. `lib/core/routing/app_router.dart`
11. `lib/features/splash/presentation/screens/splash_screen.dart`

### Data Layer
12. `lib/features/auth/data/repositories/auth_repository_impl.dart`
13. `lib/features/auth/data/datasources/firebase_user_service.dart`
14. `lib/features/transactions/data/datasources/encrypted_transaction_data_source.dart`

### Internal (Self-references - delete these files)
15-25. Various old security service files

## Benefits After Refactoring

1. **Testability**: All services mockable for unit tests
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add new implementations (e.g., Hive, SQLCipher)
4. **Type Safety**: Compile-time error detection with `Either<L, R>`
5. **Documentation**: Interfaces serve as contracts
6. **Debugging**: Explicit error types instead of silent failures

## Next Steps

Would you like me to:
1. **Start the migration** by creating missing interfaces?
2. **Generate a detailed file-by-file migration checklist**?
3. **Refactor all 25 usage points** to use the new architecture?
4. **Create comprehensive unit tests** for the new services?

Just say "start migration" and I'll begin! 🚀
