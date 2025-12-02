# Security Features - Complete Reference Guide

This document provides a comprehensive overview of all security features implemented in the application, their architecture, usage, and how to extend them.

---

## Table of Contents

- [Overview](#overview)
- [Security Architecture](#security-architecture)
- [Core Security Features](#core-security-features)
  - [1. Biometric Authentication](#1-biometric-authentication)
  - [2. Encrypted Storage](#2-encrypted-storage)
  - [3. Session Management](#3-session-management)
  - [4. App Lock / Auto-Lock](#4-app-lock--auto-lock)
  - [5. Screenshot Prevention](#5-screenshot-prevention)
  - [6. Background Blur](#6-background-blur)
  - [7. Root/Jailbreak Detection](#7-rootjailbreak-detection)
  - [8. Audit Logging](#8-audit-logging)
- [Implementation Details](#implementation-details)
- [Security Flow Diagrams](#security-flow-diagrams)
- [Configuration](#configuration)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

---

## Overview

The application implements a comprehensive, multi-layered security architecture following Clean Architecture principles. All security services are:

- **Interface-driven**: Using dependency injection for testability and flexibility
- **Encrypted**: Sensitive data is encrypted at rest using AES-256
- **Secure**: Platform-specific secure storage (Keychain/KeyStore)
- **Observable**: Security events can be monitored and audited
- **Configurable**: Security settings can be customized per user

### Security Principles

1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimal permissions requested
3. **Secure by Default**: Security features enabled by default
4. **Fail Secure**: System fails to a secure state
5. **Privacy First**: User data encrypted and protected

---

## Security Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  (UI, Screens, Cubits - Security-aware components)      │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────┴─────────────────────────────────┐
│                    Domain Layer                          │
│  (Use Cases, Entities, Repositories - Security logic)    │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────┴─────────────────────────────────┐
│                     Data Layer                           │
│  (Data Sources, Implementations - Encryption)            │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────┴─────────────────────────────────┐
│                     Core Layer                           │
│  (Security Services, Interfaces, Platform Channels)      │
└─────────────────────────────────────────────────────────┘
```

### Dependency Injection

All security services are registered in [lib/core/di/di.dart](../lib/core/di/di.dart):

```dart
// Security service setup order (dependencies matter!)
1. ISecureStorage          // Foundation - secure key-value store
2. IEncryptionService       // Data encryption using AES-256
3. IBiometricService        // Fingerprint/Face ID
4. ISessionManager          // Session lifecycle management
5. IAppLockService          // Auto-lock functionality
6. IAuditLogService         // Security event logging
7. IScreenshotPreventionService  // Screenshot blocking
8. IRootDetectionService    // Device integrity checks
9. IBlurService             // Background blur overlay
```

**File**: [lib/core/di/di.dart:70-128](../lib/core/di/di.dart#L70-L128)

---

## Core Security Features

### 1. Biometric Authentication

Secure authentication using device biometrics (Face ID, Touch ID, Fingerprint).

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_biometric_service.dart](../lib/core/security/interfaces/i_biometric_service.dart)
- **Implementation**: [lib/core/security/implementations/local_auth_biometric_impl.dart](../lib/core/security/implementations/local_auth_biometric_impl.dart)
- **Configuration**: [lib/core/config/biometric_config.dart](../lib/core/config/biometric_config.dart)

#### Features

- **Type Detection**: Automatically detects available biometric types
- **Enrollment Check**: Verifies biometrics are enrolled before use
- **Platform Mapping**: Maps Android strong/weak biometrics to unified types
- **Guarded Execution**: Prevents duplicate authentication prompts
- **Typed Failures**: Specific error types for different failure scenarios

#### Key Files

**Presentation Layer**:
- Login Screens:
  - [lib/features/auth/presentation/screens/login/fingerprint_verify_login_screen.dart](../lib/features/auth/presentation/screens/login/fingerprint_verify_login_screen.dart)
  - [lib/features/auth/presentation/screens/login/faceid_scanning_login_screen.dart](../lib/features/auth/presentation/screens/login/faceid_scanning_login_screen.dart)
- Register Screens:
  - [lib/features/auth/presentation/screens/register/fingerprint_setup_register_screen.dart](../lib/features/auth/presentation/screens/register/fingerprint_setup_register_screen.dart)
  - [lib/features/auth/presentation/screens/register/faceid_setup_register_screen.dart](../lib/features/auth/presentation/screens/register/faceid_setup_register_screen.dart)

**State Management**:
- [lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart](../lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart) - Login flow
- [lib/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart](../lib/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart) - Registration flow

**Domain Layer**:
- Use Cases:
  - [lib/features/auth/domain/usecases/biometric_login_usecase.dart](../lib/features/auth/domain/usecases/biometric_login_usecase.dart)
  - [lib/features/auth/domain/usecases/store_biometric_settings_usecase.dart](../lib/features/auth/domain/usecases/store_biometric_settings_usecase.dart)
- Entities:
  - [lib/features/auth/domain/entities/biometric_credentials_entity.dart](../lib/features/auth/domain/entities/biometric_credentials_entity.dart)
- Failures:
  - [lib/features/auth/domain/failures/biometric_failure.dart](../lib/features/auth/domain/failures/biometric_failure.dart)

#### Usage Example

```dart
// Check available biometrics
final biometricService = sl<IBiometricService>();
final result = await biometricService.getAvailableBiometrics();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (types) => print('Available: $types'),
);

// Authenticate
final authResult = await biometricService.authenticate(
  reason: 'Verify your identity to access the app',
);
```

#### Flow

1. **Registration**:
   - User completes email/password registration
   - System checks if biometrics are available
   - User opts in to biometric authentication
   - Credentials encrypted and stored securely
   - Biometric type preference saved

2. **Login**:
   - App detects stored biometric credentials
   - Shows biometric login option
   - User triggers biometric verification
   - `BiometricVerifyCubit.verify()` called (guarded against duplicates)
   - Platform biometric prompt shown (system-controlled)
   - On success: credentials retrieved, auto-login performed
   - On failure: user can retry or use password

**Important**: The native biometric prompt (Face ID/Touch ID) is system-controlled and cannot be moved or customized. Only trigger it when ready.

#### Configuration

[lib/core/config/biometric_config.dart](../lib/core/config/biometric_config.dart):
```dart
static const String defaultAuthReason = 'Authenticate to access the app';
static const String verifyIdentityReason = 'Verify your identity';
static const bool enableBiometricAuth = true;
static const bool useSensitiveAuth = true; // Android only
```

---

### 2. Encrypted Storage

AES-256 encryption for all sensitive data at rest.

#### Architecture

- **Secure Storage Interface**: [lib/core/security/interfaces/i_secure_storage.dart](../lib/core/security/interfaces/i_secure_storage.dart)
- **Secure Storage Implementation**: [lib/core/security/implementations/flutter_secure_storage_impl.dart](../lib/core/security/implementations/flutter_secure_storage_impl.dart)
- **Encryption Interface**: [lib/core/security/interfaces/i_encryption_service.dart](../lib/core/security/interfaces/i_encryption_service.dart)
- **Encryption Implementation**: [lib/core/security/implementations/encryption_service_impl.dart](../lib/core/security/implementations/encryption_service_impl.dart)
- **Storage Keys**: [lib/core/config/storage_keys_config.dart](../lib/core/config/storage_keys_config.dart)

#### Features

- **AES-256-GCM**: Military-grade encryption algorithm
- **Per-Device Keys**: Encryption key generated and stored in secure storage
- **Automatic Key Management**: Keys managed transparently
- **Platform Security**:
  - iOS: Keychain with biometric access control
  - Android: EncryptedSharedPreferences with KeyStore

#### What Gets Encrypted

1. **User Credentials** ([lib/features/auth/data/datasources/auth_local_datasource_impl.dart](../lib/features/auth/data/datasources/auth_local_datasource_impl.dart)):
   - Email addresses
   - Passwords (for biometric login)
   - Biometric type preferences

2. **Session Data** ([lib/core/security/implementations/session_manager_impl.dart](../lib/core/security/implementations/session_manager_impl.dart)):
   - User ID
   - Authentication tokens
   - Session timestamps

3. **Transaction History** ([lib/features/transactions/data/datasources/encrypted_transaction_data_source.dart](../lib/features/transactions/data/datasources/encrypted_transaction_data_source.dart)):
   - Transaction records
   - Amount and currency
   - Timestamps

4. **User Profile Data**:
   - Personal information
   - Settings and preferences

#### Implementation Example

```dart
// Encryption Service
final encryptionService = sl<IEncryptionService>();

// Encrypt data
final encrypted = await encryptionService.encrypt('sensitive data');
encrypted.fold(
  (failure) => print('Encryption failed: ${failure.message}'),
  (cipherText) => await secureStorage.write(key: 'data', value: cipherText),
);

// Decrypt data
final cipherText = await secureStorage.read(key: 'data');
final decrypted = await encryptionService.decrypt(cipherText);
```

#### Storage Keys Configuration

All storage keys are centralized in [lib/core/config/storage_keys_config.dart](../lib/core/config/storage_keys_config.dart):

```dart
// Session keys
static const String sessionUserId = 'session_user_id';
static const String sessionToken = 'session_token';

// Auth keys
static const String userEmail = 'user_email';
static const String encryptedPassword = 'encrypted_password';
static const String biometricEnabled = 'biometric_enabled';

// Transaction keys
static const String transactionHistory = 'transaction_history';
```

---

### 3. Session Management

Secure session lifecycle management with automatic expiration.

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_session_manager.dart](../lib/core/security/interfaces/i_session_manager.dart)
- **Implementation**: [lib/core/security/implementations/session_manager_impl.dart](../lib/core/security/implementations/session_manager_impl.dart)
- **Configuration**: [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)

#### Features

- **Encrypted Sessions**: Session data encrypted at rest
- **Auto-Expiration**: Configurable timeout (default: 30 minutes)
- **Activity Tracking**: Updates last activity timestamp on user interaction
- **Stream-Based**: Reactive session state changes
- **Auto-Logout**: Automatically logs out on session expiry

#### Session Lifecycle

1. **Start**: Created on successful login/registration
2. **Active**: Updated on user activity (taps, navigation)
3. **Expired**: Timeout reached without activity
4. **Ended**: User logs out or forced logout

#### Key Integration Points

**Main App** ([lib/main.dart](../lib/main.dart)):
```dart
// Initialize session manager
_sessionManager = sl<ISessionManager>();

// Listen to session state
_sessionStateSub = _sessionManager.sessionStateStream.listen((active) {
  if (!active && mounted) {
    appNavigatorKey.currentContext?.go(AppRoutes.login);
  }
});

// Update activity on user interaction
Listener(
  onPointerDown: (_) => _sessionManager.updateActivity(),
  child: MaterialApp.router(...),
);

// Handle app lifecycle
void didChangeAppLifecycleState(AppLifecycleState state) async {
  if (state == AppLifecycleState.resumed) {
    final isValid = await _sessionManager.isSessionValid();
    // Navigate based on session validity
  }
  if (state == AppLifecycleState.paused) {
    await _sessionManager.updateActivity();
  }
}
```

**Router Guard** ([lib/core/routing/app_router.dart:47-68](../lib/core/routing/app_router.dart#L47-L68)):
```dart
redirect: (context, state) async {
  final sessionManager = sl<ISessionManager>();
  final isValidResult = await sessionManager.isSessionValid();
  final authed = isValidResult.fold((_) => false, (valid) => valid);

  if (!authed && isProtectedRoute) return AppRoutes.login;
  return null;
}
```

#### Configuration

[lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart):
```dart
static const int sessionTimeoutMinutes = 30;
static const Duration sessionTimeout = Duration(minutes: 30);
static const Duration sessionPollInterval = Duration(minutes: 1);
```

#### Usage

```dart
final sessionManager = sl<ISessionManager>();

// Start session
await sessionManager.startSession(userId: 'user123', token: 'jwt_token');

// Check if valid
final isValid = await sessionManager.isSessionValid();

// Update activity
await sessionManager.updateActivity();

// End session
await sessionManager.endSession();
```

---

### 4. App Lock / Auto-Lock

Automatic application locking after inactivity period.

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_app_lock_service.dart](../lib/core/security/interfaces/i_app_lock_service.dart)
- **Implementation**: [lib/core/security/implementations/app_lock_service_impl.dart](../lib/core/security/implementations/app_lock_service_impl.dart)
- **Lock Screen**: [lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart](../lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart)
- **Configuration**: [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)

#### Features

- **Configurable Timeout**: Default 60 seconds, user-customizable
- **Activity Tracking**: Monitors user interactions
- **Stream-Based Lock State**: Reactive lock notifications
- **Biometric Unlock**: Prefer biometric if available
- **Fallback to Login**: Falls back to password if biometrics unavailable

#### How It Works

1. **Activity Monitoring**:
   - Every user interaction updates last activity timestamp
   - Tracked in [lib/main.dart](../lib/main.dart) via `Listener.onPointerDown`

2. **Lock Checking**:
   - Service polls last activity timestamp
   - Compares against configured timeout
   - Emits lock state changes via stream

3. **Lock Enforcement**:
   - Main app listens to lock state stream
   - Navigates to `/app-lock` when locked
   - App lock screen shows biometric/password options

4. **Unlock Flow**:
   - User attempts biometric unlock
   - Falls back to password if biometrics fail/unavailable
   - On success: navigates to previous screen

#### Integration

**Main App** ([lib/main.dart:109-114](../lib/main.dart#L109-L114)):
```dart
void _listenToAutoLock() {
  _lockStateSub = _appLockService.lockStateStream.listen((locked) {
    if (locked && mounted) {
      appNavigatorKey.currentContext?.go(AppRoutes.appLock);
    }
  });
}
```

**App Lock Screen** ([lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart](../lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart)):
- Shows biometric option if available
- Falls back to login screen if biometrics not available
- Uses `BiometricVerifyCubit` for verification

#### Configuration

[lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart):
```dart
static const int autoLockTimeoutSeconds = 60;
static const Duration autoLockTimeout = Duration(seconds: 60);
static const int defaultAutoLockTimeoutSeconds = 60;
```

#### User Settings

Users can customize auto-lock timeout in Settings screen:
- [lib/features/settings/presentation/screens/settings_screen.dart](../lib/features/settings/presentation/screens/settings_screen.dart)

---

### 5. Screenshot Prevention

Prevents screenshots and screen recordings on sensitive screens.

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_screenshot_prevention_service.dart](../lib/core/security/interfaces/i_screenshot_prevention_service.dart)
- **Implementation**: [lib/core/security/implementations/screenshot_prevention_service_impl.dart](../lib/core/security/implementations/screenshot_prevention_service_impl.dart)
- **Route Observer**: [lib/core/observers/app_route_observer.dart](../lib/core/observers/app_route_observer.dart)
- **Configuration**: [lib/core/config/security_config.dart](../lib/core/config/security_config.dart)

#### Platform Implementation

**Android** ([android/app/src/main/kotlin/com/example/team_18_final_project/MainActivity.kt](../android/app/src/main/kotlin/com/example/team_18_final_project/MainActivity.kt)):
```kotlin
// Sets FLAG_SECURE on the window
window.setFlags(
  WindowManager.LayoutParams.FLAG_SECURE,
  WindowManager.LayoutParams.FLAG_SECURE
)
```

**iOS** ([ios/Runner/AppDelegate.swift](../ios/Runner/AppDelegate.swift)):
```swift
// Adds a blur overlay to the window
let blurEffect = UIBlurEffect(style: .light)
let blurView = UIVisualEffectView(effect: blurEffect)
// Add to window
```

#### Route-Based Control

**Sensitive Routes** ([lib/core/config/security_config.dart:39-48](../lib/core/config/security_config.dart#L39-L48)):
```dart
static const List<String> sensitiveRoutes = [
  '/home',
  '/portfolio',
  '/transactions',
  '/coin-details',
  '/payment',
  '/buy-sell',
  '/settings',
  '/profile',
];
```

**Route Observer** ([lib/core/observers/app_route_observer.dart](../lib/core/observers/app_route_observer.dart)):
```dart
@override
void didPush(Route route, Route? previousRoute) {
  _handleRouteChange(route);
}

void _handleRouteChange(Route route) {
  final path = route.settings.name ?? '';
  if (_isSensitiveRoute(path)) {
    _screenshotService.enable();  // Enable protection
    _blurController?.secured = true;
  } else {
    _screenshotService.disable();  // Disable protection
    _blurController?.secured = false;
  }
}
```

#### Usage

Screenshot prevention is **automatic** and route-driven. No manual intervention needed.

To add a new sensitive route:

1. Add route to `SecurityConfig.sensitiveRoutes`
2. Route observer automatically applies protection

---

### 6. Background Blur

Blurs app content when app moves to background.

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_blur_service.dart](../lib/core/security/interfaces/i_blur_service.dart)
- **Implementation**: [lib/core/security/implementations/blur_service_impl.dart](../lib/core/security/implementations/blur_service_impl.dart)
- **Controller**: Uses `SecureApplication` package
- **Route Observer**: [lib/core/observers/app_route_observer.dart](../lib/core/observers/app_route_observer.dart)

#### Features

- **Route-Based**: Automatically enabled on sensitive routes
- **App Switcher Protection**: Prevents content visibility in app switcher
- **Configurable**: Can be toggled per route

#### Implementation

**Main App** ([lib/main.dart:88-90](../lib/main.dart#L88-L90)):
```dart
_secureController = SecureApplicationController(SecureApplicationState());
appRouteObserver.attachController(_secureController);
```

**SecureApplication Widget** ([lib/main.dart:198-201](../lib/main.dart#L198-L201)):
```dart
return SecureApplication(
  secureApplicationController: _secureController,
  child: MaterialApp.router(...),
);
```

**Route Observer** ([lib/core/observers/app_route_observer.dart](../lib/core/observers/app_route_observer.dart)):
```dart
void _handleRouteChange(Route route) {
  if (_isSensitiveRoute(path)) {
    _blurController?.secured = true;  // Enable blur
  } else {
    _blurController?.secured = false;  // Disable blur
  }
}
```

#### Behavior

- **Foreground**: App content visible normally
- **Background**: Blur overlay applied immediately
- **App Switcher**: Blurred preview shown
- **Return to Foreground**: Blur removed, may show app lock

---

### 7. Root/Jailbreak Detection

Detects compromised devices (rooted Android, jailbroken iOS).

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_root_detection_service.dart](../lib/core/security/interfaces/i_root_detection_service.dart)
- **Implementation**: [lib/core/security/implementations/root_detection_service_impl.dart](../lib/core/security/implementations/root_detection_service_impl.dart)
- **Warning Screen**: [lib/features/auth/presentation/screens/security_screens/root_warning_screen.dart](../lib/features/auth/presentation/screens/security_screens/root_warning_screen.dart)
- **Configuration**: [lib/core/config/security_config.dart](../lib/core/config/security_config.dart)

#### Detection Methods

Uses `safe_device` package to detect:
- **Android**: Root access, developer mode, ADB enabled
- **iOS**: Jailbreak status, Cydia presence
- **Both**: Emulator/simulator detection

#### Integration

**App Initialization** ([lib/main.dart:42-59](../lib/main.dart#L42-L59)):
```dart
Future<void> _performSecurityChecks() async {
  final rootDetectionService = sl<IRootDetectionService>();
  final result = await rootDetectionService.performSecurityCheck();

  result.fold(
    (failure) => debugPrint('Security check failed'),
    (securityCheck) {
      if (!securityCheck.isSecure) {
        debugPrint('⚠️ Security Warning: ${securityCheck.message}');
      }
    },
  );
}
```

**Runtime Check** ([lib/main.dart:156-176](../lib/main.dart#L156-L176)):
```dart
Future<void> _checkRootAndWarn() async {
  final result = await _rootDetectionService.performSecurityCheck();

  result.fold(
    (failure) => debugPrint('Root detection failed'),
    (securityCheck) async {
      if (!securityCheck.isSecure && mounted) {
        // Log event
        await _auditLogService.log(
          event: 'security_root_jailbreak_detected',
          metadata: {'message': 'Root/Jailbreak detected'},
        );

        // Show warning
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appNavigatorKey.currentContext?.go('/root-warning');
        });
      }
    },
  );
}
```

#### Warning Screen

Shows user a warning about compromised device security. User can:
- Acknowledge and proceed (at their own risk)
- Exit the app

**File**: [lib/features/auth/presentation/screens/security_screens/root_warning_screen.dart](../lib/features/auth/presentation/screens/security_screens/root_warning_screen.dart)

#### Configuration

[lib/core/config/security_config.dart:31-34](../lib/core/config/security_config.dart#L31-L34):
```dart
static const bool enableRootDetection = true;
static const bool enableJailbreakDetection = true;
static const bool enableEmulatorDetection = true;
```

---

### 8. Audit Logging

Security event logging for compliance and monitoring.

#### Architecture

- **Interface**: [lib/core/security/interfaces/i_audit_log_service.dart](../lib/core/security/interfaces/i_audit_log_service.dart)
- **Implementation**: [lib/core/security/implementations/audit_log_service_impl.dart](../lib/core/security/implementations/audit_log_service_impl.dart)
- **Configuration**: [lib/core/config/audit_log_config.dart](../lib/core/config/audit_log_config.dart)

#### Features

- **Structured Logging**: Event name + metadata
- **Encrypted Storage**: Logs encrypted at rest
- **Configurable Retention**: Max entries limit (default: 1000)
- **Query Support**: Retrieve logs for analysis

#### Logged Events

- User authentication (login/logout)
- Biometric verification attempts
- Session expiry/invalidation
- Security warnings (root/jailbreak detection)
- Failed authentication attempts
- App lock/unlock events

#### Usage

```dart
final auditLog = sl<IAuditLogService>();

// Log event
await auditLog.log(
  event: 'user_login_success',
  metadata: {
    'userId': 'user123',
    'method': 'biometric',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// Retrieve logs
final logsResult = await auditLog.getLogs();
logsResult.fold(
  (failure) => print('Failed to get logs'),
  (logs) => print('Found ${logs.length} events'),
);

// Clear old logs
await auditLog.clearLogs();
```

#### Configuration

[lib/core/config/audit_log_config.dart](../lib/core/config/audit_log_config.dart):
```dart
static const int maxAuditLogEntries = 1000;
static const bool enableAuditLogging = true;
```

---

## Implementation Details

### Security Service Initialization Order

**Critical**: Services must be initialized in dependency order!

[lib/core/di/di.dart:70-128](../lib/core/di/di.dart#L70-L128):

```
1. ISecureStorage           ← Foundation (no dependencies)
2. IEncryptionService       ← Depends on: ISecureStorage
3. IBiometricService        ← Independent
4. ISessionManager          ← Depends on: ISecureStorage, IEncryptionService
5. IAppLockService          ← Depends on: ISecureStorage
6. IAuditLogService         ← Depends on: ISecureStorage
7. IScreenshotPreventionService ← Depends on: ISecureStorage
8. IRootDetectionService    ← Independent
9. IBlurService             ← Depends on: ISecureStorage
```

### Platform Channels

**Method Channel**: `screenshot_prevention`

Used for screenshot prevention and blur functionality.

**Android** ([android/app/src/main/kotlin/com/example/team_18_final_project/MainActivity.kt](../android/app/src/main/kotlin/com/example/team_18_final_project/MainActivity.kt)):
- Method: `enable` - Sets `FLAG_SECURE`
- Method: `disable` - Clears `FLAG_SECURE`

**iOS** ([ios/Runner/AppDelegate.swift](../ios/Runner/AppDelegate.swift)):
- Method: `enable` - Adds blur overlay
- Method: `disable` - Removes blur overlay

---

## Security Flow Diagrams

### Biometric Login Flow

```
User Opens App
      │
      ↓
[Splash Screen]
      │
      ↓
Check Session Valid? ─No→ [Login Screen]
      │                         │
      Yes                       ↓
      ↓                   Biometric Available?
[Home Screen]                   │
                          Yes / No
                                │
                          ┌─────┴─────┐
                         Yes         No
                          │           │
                          ↓           ↓
              [Biometric Login]  [Password Login]
                          │           │
                    Tap to Verify     │
                          │           │
                          ↓           │
              BiometricVerifyCubit.verify()
                          │           │
                    Platform Prompt   │
                          │           │
                    ┌─────┴─────┐     │
                 Success    Failure   │
                    │           │     │
                    ↓           ↓     │
            [Home Screen]  [Retry / Password]
```

### Session & Lock Flow

```
App Launched
      │
      ↓
Initialize Services (DI)
      │
      ├──→ SessionManager
      ├──→ AppLockService
      └──→ RouteObserver
      │
      ↓
User Interaction
      │
      ├──→ Update SessionManager Activity
      └──→ Update AppLockService Activity
      │
      ↓
      ┌─────────────┬─────────────┐
      │             │             │
App Backgrounded  Timeout    Route Change
      │             │             │
      ↓             ↓             ↓
Save Timestamp  Check Lock?  Screenshot Control
      │             │             │
      ↓             ↓             ↓
Resume App    Lock if Idle   Enable/Disable
      │             │             │
      ↓             ↓             │
Session Valid? ←───┘             │
      │                          │
   Yes│No                        │
      │ │                        │
      │ └──→ [Login]             │
      │                          │
      ↓                          │
  Lock? ←────────────────────────┘
      │
   Yes│No
      │ │
      │ └──→ [Continue]
      │
      ↓
[App Lock Screen]
```

---

## Configuration

### Central Configuration Files

All security settings are centralized for easy management:

1. **Security Config**: [lib/core/config/security_config.dart](../lib/core/config/security_config.dart)
   - Sensitive routes
   - Enable/disable features
   - Default timeouts

2. **Timing Config**: [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)
   - Session timeout
   - Auto-lock timeout
   - Poll intervals

3. **Biometric Config**: [lib/core/config/biometric_config.dart](../lib/core/config/biometric_config.dart)
   - Auth reasons
   - Sensitive authentication
   - Biometric settings

4. **Audit Log Config**: [lib/core/config/audit_log_config.dart](../lib/core/config/audit_log_config.dart)
   - Max log entries
   - Enable/disable logging

5. **Storage Keys Config**: [lib/core/config/storage_keys_config.dart](../lib/core/config/storage_keys_config.dart)
   - Secure storage key names
   - Prevents key conflicts

### Customization

To change security settings:

1. Update config files (not individual implementations)
2. Restart app for changes to take effect
3. Test thoroughly after changes

Example - Change session timeout:

```dart
// lib/core/config/timing_config.dart
static const int sessionTimeoutMinutes = 60; // Changed from 30
```

---

## Testing

### Unit Tests

Security services have comprehensive unit tests:

- **Auth Tests**: [test/features/auth/](../test/features/auth/)
  - Domain validation
  - Use case logic
  - Cubit state management

Example test files:
- [test/features/auth/domain/validation/email_validator_test.dart](../test/features/auth/domain/validation/email_validator_test.dart)
- [test/features/auth/domain/validation/password_validator_test.dart](../test/features/auth/domain/validation/password_validator_test.dart)
- [test/features/auth/domain/usecases/login_user_usecase_test.dart](../test/features/auth/domain/usecases/login_user_usecase_test.dart)
- [test/features/auth/presentation/cubits/auth_cubit_test.dart](../test/features/auth/presentation/cubits/auth_cubit_test.dart)

### Recent test updates

- `test/core/security/app_lock_service_test.dart` now reflects `appLocked` flag semantics, lock/unlock stream emissions, and auto-lock timer behavior.
- `test/features/auth/presentation/cubits/biometric_verify_cubit_test.dart` verifies duplicate `verify()` calls are ignored and no emissions occur after disposal.
- `test/core/security/screenshot_prevention_service_test.dart` asserts platform channel calls to `enableSecureMode`/`disableSecureMode` alongside storage bookkeeping.

### Integration Tests

Located in [integration_test/](../integration_test/):
- Full authentication flows
- Biometric setup and verification
- Session management
- Navigation between secure screens

### Manual Testing Checklist

Before release, verify:

1. ✅ Biometric scan screens log `verify CALLED` once
2. ✅ No biometric prompts appear on success/home screens
3. ✅ Screenshot blocking works on sensitive routes (Android/iOS)
4. ✅ Screenshot blocking disabled on non-sensitive routes
5. ✅ Auto-lock triggers after configured inactivity
6. ✅ Unlock path works when biometrics unavailable
7. ✅ Session expiry logs out and clears tokens
8. ✅ API calls succeed post-biometric login
9. ✅ Transaction history persists and decrypts after restart
10. ✅ No plaintext sensitive data in logs or storage

### Debug Tools

**Biometric Debug Screen**: [lib/features/auth/presentation/debug/biometric_debug_screen.dart](../lib/features/auth/presentation/debug/biometric_debug_screen.dart)
- Test biometric availability
- Test authentication flow
- Check stored credentials
- Route: `/debug-biometrics`

**Biometric Test Screen**: [lib/features/auth/presentation/debug/biometric_test_screen.dart](../lib/features/auth/presentation/debug/biometric_test_screen.dart)
- Quick biometric tests
- Route: `/biometric-test`

---

## Troubleshooting

### Common Issues

#### 1. Biometric Prompt Appears Multiple Times

**Cause**: Multiple calls to `BiometricVerifyCubit.verify()`

**Solution**:
- Check for duplicate button taps
- Verify guard logic in cubit prevents re-entry
- Search codebase for stray `verify(` or `authenticate(` calls
- Add debug log: `debugPrint('verify CALLED');`

**File to check**: [lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart](../lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart)

#### 2. Screenshots Not Blocked

**Cause**: Route not in sensitive routes list or observer not attached

**Solution**:
- Add route to `SecurityConfig.sensitiveRoutes`
- Verify `AppRouteObserver` is attached to router
- Check platform channel implementation
- Test on physical device (not simulator)

**Files to check**:
- [lib/core/config/security_config.dart](../lib/core/config/security_config.dart)
- [lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart)

#### 3. Auto-Lock Not Triggering

**Cause**: Activity tracking not working or timeout too long

**Solution**:
- Verify `Listener.onPointerDown` calls `updateActivity()`
- Check timeout configuration
- Ensure lock state stream is subscribed
- Test with shorter timeout for debugging

**Files to check**:
- [lib/main.dart](../lib/main.dart)
- [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)

#### 4. Session Expiry Issues

**Cause**: Session not being updated or expiry logic broken

**Solution**:
- Verify `SessionManager.updateActivity()` called on interactions
- Check session timeout configuration
- Test session validity after timeout period
- Review session state stream subscriptions

**File to check**: [lib/core/security/implementations/session_manager_impl.dart](../lib/core/security/implementations/session_manager_impl.dart)

#### 5. Encrypted Data Not Decrypting

**Cause**: Encryption key lost or corrupted

**Solution**:
- Check secure storage accessibility
- Verify encryption service initialization
- Test on same device (keys are device-specific)
- Review error logs for encryption failures

**Files to check**:
- [lib/core/security/implementations/encryption_service_impl.dart](../lib/core/security/implementations/encryption_service_impl.dart)
- [lib/core/security/implementations/flutter_secure_storage_impl.dart](../lib/core/security/implementations/flutter_secure_storage_impl.dart)

### Debugging Tips

1. **Enable Verbose Logging**:
   - Add `debugPrint()` statements to track flow
   - Use `print()` for critical security events

2. **Check Dependency Injection**:
   - Verify all services registered in correct order
   - Test service retrieval: `final service = sl<IService>();`

3. **Platform-Specific Issues**:
   - **Android**: Check `MainActivity.kt` for channel implementation
   - **iOS**: Check `AppDelegate.swift` for channel implementation
   - Test on physical devices, not just simulators

4. **Clear App Data**:
   - Uninstall and reinstall app
   - Clears secure storage and resets state

5. **Review Audit Logs**:
   - Check audit logs for security events
   - Identify patterns in failures

---

## Extending Security Features

### Adding a New Sensitive Route

1. Add route to configuration:
```dart
// lib/core/config/security_config.dart
static const List<String> sensitiveRoutes = [
  '/home',
  '/your-new-route',  // Add here
];
```

2. Protection applied automatically by `AppRouteObserver`

### Creating a New Security Service

1. **Define Interface**:
```dart
// lib/core/security/interfaces/i_your_service.dart
abstract class IYourService {
  Future<Either<Failure, Success>> yourMethod();
}
```

2. **Implement Service**:
```dart
// lib/core/security/implementations/your_service_impl.dart
class YourServiceImpl implements IYourService {
  @override
  Future<Either<Failure, Success>> yourMethod() async {
    // Implementation
  }
}
```

3. **Register in DI**:
```dart
// lib/core/di/di.dart
sl.registerLazySingleton<IYourService>(
  () => YourServiceImpl(),
);
```

4. **Use in App**:
```dart
final service = sl<IYourService>();
await service.yourMethod();
```

### Customizing Biometric Messages

Edit [lib/core/config/biometric_config.dart](../lib/core/config/biometric_config.dart):
```dart
static const String defaultAuthReason = 'Your custom message';
```

### Adjusting Timeouts

Edit [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart):
```dart
static const int sessionTimeoutMinutes = 60;  // Your timeout
static const int autoLockTimeoutSeconds = 120;  // Your timeout
```

---

## Security Best Practices

### For Developers

1. **Never hardcode secrets** - Use environment variables or secure storage
2. **Always encrypt sensitive data** - Use `IEncryptionService`
3. **Validate all inputs** - Use domain validators
4. **Handle failures gracefully** - Use `Either<Failure, Success>` pattern
5. **Test security features** - Write unit and integration tests
6. **Log security events** - Use `IAuditLogService`
7. **Follow dependency order** - Initialize services correctly

### For Users

1. **Enable biometric authentication** - Faster and more secure
2. **Keep app updated** - Security patches and improvements
3. **Don't root/jailbreak device** - Compromises app security
4. **Use strong passwords** - If not using biometrics
5. **Enable auto-lock** - Protect when phone left unattended
6. **Review permissions** - Understand what app accesses

---

## Related Documentation

- [Architecture Guide](ARCHITECTURE.md) - Clean Architecture implementation
- [Authentication Flow](AUTH_FLOW.md) - Detailed auth flow documentation
- [Security Architecture](SECURITY_ARCHITECTURE.md) - Deep dive into security design
- [API Integration](API_INTEGRATION.md) - API security and integration
- [Testing Guide](../test/README.md) - How to test security features

---

## Summary

This application implements enterprise-grade security with:

- ✅ Multi-factor authentication (password + biometrics)
- ✅ End-to-end encryption for sensitive data
- ✅ Automatic session management with expiration
- ✅ Screenshot prevention on sensitive screens
- ✅ Device integrity checks (root/jailbreak detection)
- ✅ Comprehensive audit logging
- ✅ Auto-lock after inactivity
- ✅ Background blur protection

All security features follow Clean Architecture principles, are fully testable, and can be easily extended or customized.

For questions or issues, refer to the troubleshooting section or review the implementation files linked throughout this document.
