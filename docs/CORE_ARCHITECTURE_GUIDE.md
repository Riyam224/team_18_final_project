# Core Architecture - Complete Reference Guide

This document provides a comprehensive overview of the core layer architecture, explaining every component, service, and configuration in detail.

---

## Table of Contents

- [Overview](#overview)
- [Clean Architecture Layers](#clean-architecture-layers)
- [Core Directory Structure](#core-directory-structure)
- [Dependency Injection (DI)](#dependency-injection-di)
- [Configuration System](#configuration-system)
- [Security Services](#security-services)
- [Networking Layer](#networking-layer)
- [Routing System](#routing-system)
- [Common UI Components](#common-ui-components)
- [Utilities & Extensions](#utilities--extensions)
- [Error Handling](#error-handling)
- [Storage & Persistence](#storage--persistence)
- [Validation System](#validation-system)
- [Best Practices](#best-practices)

---

## Overview

The **core** layer is the foundation of the application, providing:

- **Reusable Services**: Security, networking, storage
- **Configuration**: Centralized app settings
- **UI Components**: Shared widgets and buttons
- **Utilities**: Themes, colors, extensions
- **Infrastructure**: DI, routing, error handling

### Core Principles

1. **Separation of Concerns**: Each component has a single responsibility
2. **Dependency Inversion**: Depend on abstractions (interfaces), not implementations
3. **Reusability**: Core components used across all features
4. **Testability**: All services are mockable and testable
5. **Configuration-Driven**: Settings centralized in config files

---

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  - Screens, Widgets, Cubits                                  │
│  - UI logic, state management                                │
│  - Located in: lib/features/*/presentation/                  │
└────────────────────────┬────────────────────────────────────┘
                         │ depends on
┌────────────────────────┴────────────────────────────────────┐
│                      Domain Layer                            │
│  - Use Cases, Entities, Repositories (interfaces)            │
│  - Business logic, validation rules                          │
│  - Located in: lib/features/*/domain/                        │
└────────────────────────┬────────────────────────────────────┘
                         │ depends on
┌────────────────────────┴────────────────────────────────────┐
│                       Data Layer                             │
│  - Data Sources, Repository Implementations                  │
│  - API calls, database operations, caching                   │
│  - Located in: lib/features/*/data/                          │
└────────────────────────┬────────────────────────────────────┘
                         │ depends on
┌────────────────────────┴────────────────────────────────────┐
│                       Core Layer                             │
│  - Security, Networking, Storage, DI, Config                 │
│  - Infrastructure components used by all layers              │
│  - Located in: lib/core/                                     │
└─────────────────────────────────────────────────────────────┘
```

**Dependency Rule**: Inner layers know nothing about outer layers. Dependencies point inward.

---

## Core Directory Structure

```
lib/core/
├── common_ui/              # Shared UI components
│   ├── buttons/            # Button widgets
│   ├── inputs/             # Input fields
│   └── widgets/            # Common widgets
├── config/                 # Configuration files
│   ├── app_config.dart
│   ├── security_config.dart
│   ├── biometric_config.dart
│   ├── timing_config.dart
│   ├── storage_keys_config.dart
│   └── ... (other configs)
├── constants/              # App constants
│   ├── app_assets.dart
│   ├── app_colors.dart
│   ├── app_strings.dart
│   ├── app_spacing.dart
│   └── app_sizing.dart
├── di/                     # Dependency injection
│   └── di.dart
├── error/                  # Error handling
│   ├── failure.dart
│   ├── failures.dart
│   ├── auth_error_msg.dart
│   └── firebase_error_mapper.dart
├── networking/             # HTTP client setup
│   ├── dio_client.dart
│   ├── endpoints.dart
│   └── api_error_handler.dart
├── observers/              # Route observers
│   └── app_route_observer.dart
├── routing/                # Navigation setup
│   ├── app_router.dart
│   └── route_names.dart
├── security/               # Security services
│   ├── interfaces/         # Service interfaces
│   └── implementations/    # Service implementations
├── storage/                # Storage utilities
│   └── shared_prefs.dart
├── utils/                  # Utility classes
│   ├── app_theme.dart
│   ├── app_colors.dart
│   └── light_theme.dart
├── validation/             # Input validation
│   ├── email_input.dart
│   ├── password_input.dart
│   └── validation.dart
└── extension/              # (deprecated) removed theme extensions in favor of Theme.of(context)
```

---

## Dependency Injection (DI)

**File**: [lib/core/di/di.dart](../lib/core/di/di.dart)

### Overview

Uses **GetIt** for service locator pattern. All dependencies registered at app startup.

### Setup Order

```dart
Future<void> setupDependencies() async {
  await _setupCore();      // Dio client
  await _setupSecurity();  // Security services
  await _setupAuth();      // Auth repositories & use cases
  await _setupHome();      // Home feature
  await _setupTransactions(); // Transaction feature
}
```

### Registration Types

1. **Lazy Singleton**: Created once when first accessed, reused thereafter
   ```dart
   sl.registerLazySingleton<ISecureStorage>(
     () => FlutterSecureStorageImpl(),
   );
   ```

2. **Factory**: New instance created each time
   ```dart
   sl.registerFactory(() => AuthCubit(...));
   ```

### Service Dependencies

Security services **must** be registered in this order:

```
ISecureStorage (foundation)
    ↓
IEncryptionService (depends on ISecureStorage)
    ↓
ISessionManager (depends on ISecureStorage, IEncryptionService)
    ↓
Other services (depend on above)
```

### Usage

```dart
// Retrieve service
final storage = sl<ISecureStorage>();

// Use in constructors (DI)
class AuthCubit {
  final LoginUserUseCase loginUseCase;
  AuthCubit({required this.loginUseCase});
}

// Register with DI
sl.registerFactory(() => AuthCubit(loginUseCase: sl()));
```

---

## Configuration System

All configuration centralized in `lib/core/config/` for easy management.

### Key Configuration Files

#### 1. App Config

**File**: [lib/core/config/app_config.dart](../lib/core/config/app_config.dart)

Global app settings:

```dart
class AppConstants {
  static const String appTitle = 'Fintech App';
  static const Size designSize = Size(375, 812);
  static const List<DeviceOrientation> allowedOrientations = [
    DeviceOrientation.portraitUp,
  ];
}
```

#### 2. Security Config

**File**: [lib/core/config/security_config.dart](../lib/core/config/security_config.dart)

Security settings and sensitive routes:

```dart
class SecurityConfig {
  static const bool enableRootDetection = true;
  static const bool enableScreenshotPrevention = true;

  static const List<String> sensitiveRoutes = [
    '/home',
    '/portfolio',
    '/transactions',
  ];
}
```

#### 3. Timing Config

**File**: [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)

Timeout and duration settings:

```dart
class TimingConfig {
  static const int sessionTimeoutMinutes = 30;
  static const int autoLockTimeoutSeconds = 60;
  static const Duration sessionPollInterval = Duration(minutes: 1);
}
```

#### 4. Storage Keys Config

**File**: [lib/core/config/storage_keys_config.dart](../lib/core/config/storage_keys_config.dart)

Centralized storage key names:

```dart
class StorageKeys {
  static const String sessionUserId = 'session_user_id';
  static const String userEmail = 'user_email';
  static const String biometricEnabled = 'biometric_enabled';
}
```

Benefits:
- Prevents key name conflicts
- Easy to find all storage keys
- Type-safe key access

#### 5. Biometric Config

**File**: [lib/core/config/biometric_config.dart](../lib/core/config/biometric_config.dart)

Biometric authentication settings:

```dart
class BiometricConfig {
  static const String defaultAuthReason = 'Authenticate to access the app';
  static const bool enableBiometricAuth = true;
  static const bool useSensitiveAuth = true; // Android only
}
```

---

## Security Services

All security services follow the **Interface → Implementation** pattern.

### Service Architecture

```
lib/core/security/
├── interfaces/
│   ├── i_secure_storage.dart
│   ├── i_encryption_service.dart
│   ├── i_biometric_service.dart
│   ├── i_session_manager.dart
│   ├── i_app_lock_service.dart
│   ├── i_audit_log_service.dart
│   ├── i_screenshot_prevention_service.dart
│   ├── i_root_detection_service.dart
│   └── i_blur_service.dart
└── implementations/
    ├── flutter_secure_storage_impl.dart
    ├── encryption_service_impl.dart
    ├── local_auth_biometric_impl.dart
    ├── session_manager_impl.dart
    ├── app_lock_service_impl.dart
    ├── audit_log_service_impl.dart
    ├── screenshot_prevention_service_impl.dart
    ├── root_detection_service_impl.dart
    └── blur_service_impl.dart
```

### Why Interfaces?

1. **Testability**: Easy to mock in tests
2. **Flexibility**: Swap implementations without changing code
3. **Dependency Inversion**: Depend on abstractions, not concretions
4. **Clean Architecture**: Core principle

### Key Services

See [SECURITY_FEATURES_OVERVIEW.md](SECURITY_FEATURES_OVERVIEW.md) for detailed documentation on each security service.

---

## Networking Layer

**Location**: `lib/core/networking/`

### Dio Client Setup

**File**: [lib/core/networking/dio_client.dart](../lib/core/networking/dio_client.dart)

Configured HTTP client with:
- Base URL configuration
- Timeout settings
- Logging interceptor (debug mode)
- Error handling interceptor
- Authentication headers

```dart
class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBaseUrl.coinGeckoBaseUrl,
        connectTimeout: NetworkConfig.connectionTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(LogInterceptor());

    return dio;
  }
}
```

### API Endpoints

**File**: [lib/core/networking/endpoints.dart](../lib/core/networking/endpoints.dart)

Centralized API endpoint definitions:

```dart
class ApiEndpoints {
  static const String marketData = '/coins/markets';
  static const String coinDetails = '/coins/{id}';
  static const String trending = '/search/trending';
}
```

### Error Handling

**File**: [lib/core/networking/api_error_handler.dart](../lib/core/networking/api_error_handler.dart)

Maps Dio exceptions to domain failures:

```dart
Failure handleApiError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return NetworkFailure(message: 'Connection timeout');
    case DioExceptionType.badResponse:
      return ServerFailure(statusCode: e.response?.statusCode);
    // ... other cases
  }
}
```

---

## Routing System

**Location**: `lib/core/routing/`

Uses **GoRouter** for declarative navigation.

### App Router

**File**: [lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart)

Key features:
- **Declarative routes**: Define all routes in one place
- **Authentication guard**: Redirects unauthenticated users
- **Route observer**: Monitors navigation for security
- **Shell routes**: Routes with bottom navigation

```dart
class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    observers: [appRouteObserver],
    initialLocation: AppRoutes.splash,

    redirect: (context, state) async {
      // Auth guard logic
      if (isProtectedRoute && !isAuthenticated) {
        return AppRoutes.login;
      }
      return null;
    },

    routes: [
      GoRoute(path: AppRoutes.splash, builder: ...),
      GoRoute(path: AppRoutes.login, builder: ...),
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: ...),
          GoRoute(path: AppRoutes.market, builder: ...),
        ],
      ),
    ],
  );
}
```

### Route Names

**File**: [lib/core/routing/route_names.dart](../lib/core/routing/route_names.dart)

Centralized route constants:

```dart
class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String market = '/market';
  // ... other routes
}
```

### Route Observer

**File**: [lib/core/observers/app_route_observer.dart](../lib/core/observers/app_route_observer.dart)

Monitors navigation events for:
- Screenshot prevention (enable/disable based on route)
- Background blur (enable/disable based on route)
- Security event logging

```dart
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    _handleRouteChange(route);
  }

  void _handleRouteChange(Route route) {
    final path = route.settings.name ?? '';
    if (_isSensitiveRoute(path)) {
      _screenshotService.enable();
      _blurController?.secured = true;
    } else {
      _screenshotService.disable();
      _blurController?.secured = false;
    }
  }
}
```

---

## Common UI Components

**Location**: `lib/core/common_ui/`

Reusable widgets used across all features.

### Button Components

#### Primary Button

**File**: [lib/core/common_ui/buttons/primary_button.dart](../lib/core/common_ui/buttons/primary_button.dart)

Main call-to-action button with consistent styling.

#### Secondary Button

**File**: [lib/core/common_ui/buttons/secondary_button.dart](../lib/core/common_ui/buttons/secondary_button.dart)

Alternative action button with outline style.

#### Circle Button

**File**: [lib/core/common_ui/buttons/circle_button.dart](../lib/core/common_ui/buttons/circle_button.dart)

Round icon button for actions.

### Input Components

#### Custom Text Field

**File**: [lib/core/common_ui/inputs/custom_text_field.dart](../lib/core/common_ui/inputs/custom_text_field.dart)

Styled text input with:
- Consistent design
- Error handling
- Prefix/suffix icons
- Validation support

### Widget Components

#### Bottom Navigation

**File**: [lib/core/common_ui/widgets/bottom_navigation.dart](../lib/core/common_ui/widgets/bottom_navigation.dart)

App bottom navigation bar.

#### Bottom Nav Shell

**File**: [lib/core/common_ui/widgets/bottom_nav_shell.dart](../lib/core/common_ui/widgets/bottom_nav_shell.dart)

Wrapper for screens with bottom navigation.

#### Custom Back Button

**File**: [lib/core/common_ui/widgets/custom_back_button.dart](../lib/core/common_ui/widgets/custom_back_button.dart)

Consistent back button styling.

---

## Utilities & Extensions

### Theme System

**Files**:
- [lib/core/utils/app_theme.dart](../lib/core/utils/app_theme.dart)
- [lib/core/utils/light_theme.dart](../lib/core/utils/light_theme.dart)
- [lib/core/utils/dark_theme.dart](../lib/core/utils/dark_theme.dart)

Provides:
- Light and dark themes
- System UI overlay configuration
- Material Design 3 support

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    // ... other configurations
  );

  static ThemeData get darkTheme => ThemeData.dark(
    // ... dark theme configurations
  );
}
```

### Colors

**File**: [lib/core/utils/app_colors.dart](../lib/core/utils/app_colors.dart)

Centralized color palette:

```dart
class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFB00020);
  // ... other colors
}
```

### Text Styles

**File**: [lib/core/config/app_text_styles.dart](../lib/core/config/app_text_styles.dart)

Consistent typography:

```dart
class AppTextStyles {
  static TextStyle get heading1 => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get body => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );
}
```

### Extensions

**Note**: Previous theme extensions removed; use `Theme.of(context)` directly for theme/brightness checks.

Dart extensions for convenience:

```dart
extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

---

## Error Handling

### Failure Classes

**File**: [lib/core/error/failure.dart](../lib/core/error/failure.dart)

Base failure class for error handling:

```dart
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message})
    : super(message: message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required String message, this.statusCode})
    : super(message: message);
}
```

### Using Either Pattern

All use cases and repositories return `Either<Failure, Success>`:

```dart
Future<Either<AuthFailure, UserEntity>> login(
  String email,
  String password,
) async {
  try {
    final user = await _authService.signIn(email, password);
    return Right(user);
  } catch (e) {
    return Left(AuthFailure(message: e.toString()));
  }
}
```

Benefits:
- Explicit error handling
- Type-safe errors
- Functional programming pattern
- Forces error consideration

---

## Storage & Persistence

### Secure Storage

**Interface**: [lib/core/security/interfaces/i_secure_storage.dart](../lib/core/security/interfaces/i_secure_storage.dart)

**Implementation**: [lib/core/security/implementations/flutter_secure_storage_impl.dart](../lib/core/security/implementations/flutter_secure_storage_impl.dart)

Platform-specific secure storage:
- **iOS**: Keychain
- **Android**: EncryptedSharedPreferences + KeyStore

```dart
abstract class ISecureStorage {
  Future<Either<StorageFailure, void>> write({
    required String key,
    required String value,
  });

  Future<Either<StorageFailure, String?>> read({
    required String key,
  });

  Future<Either<StorageFailure, void>> delete({
    required String key,
  });
}
```

### Shared Preferences

**File**: [lib/core/storage/shared_prefs.dart](../lib/core/storage/shared_prefs.dart)

For non-sensitive data:
- User preferences
- Theme settings
- App state

---

## Validation System

**Location**: `lib/core/validation/`

### Input Validators

Using **Formz** package for type-safe validation.

#### Email Validator

**File**: [lib/core/validation/email_input.dart](../lib/core/validation/email_input.dart)

```dart
class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!EmailValidator.isValid(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}
```

#### Password Validator

**File**: [lib/core/validation/password_input.dart](../lib/core/validation/password_input.dart)

Validates password strength:
- Minimum length
- Contains uppercase
- Contains lowercase
- Contains number
- Contains special character

---

## Best Practices

### 1. Configuration Management

✅ **DO**:
- Centralize all settings in `lib/core/config/`
- Use constants instead of magic strings/numbers
- Document configuration options

❌ **DON'T**:
- Hardcode values in implementations
- Duplicate configuration across files

### 2. Dependency Injection

✅ **DO**:
- Register services at app startup
- Use interfaces for dependencies
- Follow correct initialization order

❌ **DON'T**:
- Create instances with `new` keyword
- Access services before registration
- Create circular dependencies

### 3. Error Handling

✅ **DO**:
- Use `Either<Failure, Success>` pattern
- Create specific failure types
- Log errors appropriately

❌ **DON'T**:
- Catch and ignore exceptions
- Return null for errors
- Use generic error messages

### 4. Security

✅ **DO**:
- Encrypt sensitive data
- Use secure storage for credentials
- Follow least privilege principle

❌ **DON'T**:
- Store passwords in plaintext
- Log sensitive information
- Skip input validation

### 5. Code Organization

✅ **DO**:
- Follow Clean Architecture layers
- Keep files focused and small
- Use meaningful names

❌ **DON'T**:
- Mix concerns in one file
- Create god classes
- Use abbreviations excessively

---

## Summary

The core layer provides:

- ✅ **Dependency Injection**: GetIt for service locator
- ✅ **Configuration**: Centralized settings
- ✅ **Security Services**: 9 comprehensive security services
- ✅ **Networking**: Dio client with interceptors
- ✅ **Routing**: GoRouter with auth guards
- ✅ **UI Components**: Reusable widgets and buttons
- ✅ **Error Handling**: Either pattern for type-safe errors
- ✅ **Storage**: Secure and non-secure storage
- ✅ **Validation**: Type-safe input validation
- ✅ **Theming**: Light and dark theme support

All core components follow Clean Architecture principles and are fully testable.

---

## Related Documentation

- [Security Features Overview](SECURITY_FEATURES_OVERVIEW.md)
- [Architecture Guide](ARCHITECTURE.md)
- [API Integration](API_INTEGRATION.md)
- [File Structure](FILE_STRUCTURE.md)
