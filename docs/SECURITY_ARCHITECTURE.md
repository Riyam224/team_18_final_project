# Security Architecture Documentation

## Overview

This document details the comprehensive security architecture implemented in the application, covering app-level locking, session management, biometric authentication, secure storage, and device security checks.

## Security Layers

```
┌─────────────────────────────────────────────────┐
│           Application Security Layers            │
├─────────────────────────────────────────────────┤
│  1. App Lock (Auto-lock on inactivity)          │
│  2. Session Management (Timeout & validation)   │
│  3. Biometric Authentication (Face/Touch ID)    │
│  4. Secure Storage (Encrypted credentials)      │
│  5. Blur Protection (Background security)       │
│  6. Root Detection (Device integrity)           │
└─────────────────────────────────────────────────┘
```

## Core Security Services

All security services are located in: `lib/core/security/`

### 1. AppLockService

**Location:** `lib/core/security/app_lock_service.dart`

**Purpose:** Manages automatic app locking after inactivity to protect sensitive data.

**Features:**
- Configurable auto-lock timeout (default: 2 minutes)
- Activity tracking with timestamp updates
- Lock state management
- Integration with app lifecycle

**Key Properties:**
```dart
bool _isLocked = false;
DateTime _lastActivityTime = DateTime.now();
Duration _autoLockTimeout = Duration(minutes: 2);
bool _autoLockEnabled = true;
```

**Public Methods:**

```dart
// Lock State Management
bool get isLocked => _isLocked;
void lock() => _isLocked = true;
void unlock() => _isLocked = false;
void resetLock() => _isLocked = false;

// Activity Tracking
void updateActivity() => _lastActivityTime = DateTime.now();
DateTime get lastActivityTime => _lastActivityTime;

// Auto-lock Configuration
bool shouldLock() {
  if (!_autoLockEnabled) return false;
  final elapsed = DateTime.now().difference(_lastActivityTime);
  return elapsed > _autoLockTimeout;
}

void enableAutoLock() => _autoLockEnabled = true;
void disableAutoLock() => _autoLockEnabled = false;

Future<void> setAutoLockTimeout(Duration timeout);
Future<Duration> getAutoLockTimeout();
```

**Usage Example:**
```dart
// In auth_cubit after successful login
final appLockService = GetIt.instance<AppLockService>();
appLockService.resetLock();  // Prevent immediate lock

// During biometric verification
appLockService.updateActivity();  // Reset inactivity timer

// Check if app should lock
if (appLockService.shouldLock()) {
  // Navigate to app lock screen
}
```

**Storage Keys:**
```dart
static const _keyAutoLockTimeout = 'auto_lock_timeout_seconds';
```

**Integration Points:**
- Called by `BiometricVerifyCubit` before authentication
- Reset by `AuthCubit` after successful login
- Checked by app lifecycle handlers for auto-lock trigger

---

### 2. SessionManager

**Location:** `lib/core/security/session_manager.dart`

**Purpose:** Manages user session lifecycle with automatic timeout and validation.

**Features:**
- Session timeout management (default: 30 minutes)
- Automatic session validation checks
- Session restoration on app restart
- Logout callback for expired sessions
- Periodic session health checks

**Key Properties:**
```dart
bool _isSessionActive = false;
DateTime? _lastActivityTime;
Duration _sessionTimeout = Duration(minutes: 30);
Timer? _sessionCheckTimer;
VoidCallback? _onSessionExpired;
```

**Public Methods:**

```dart
// Session Lifecycle
Future<void> startSession();
bool isSessionValid();
Future<void> endSession();
Future<void> restoreSession();

// Activity Management
void updateActivity();
DateTime? get lastActivityTime => _lastActivityTime;

// Session Validation
Future<void> checkSessionValidity() async {
  if (!isSessionValid()) {
    await endSession();
    _onSessionExpired?.call();  // Trigger logout
  }
}

// Session Info
Duration getRemainingSessionTime() {
  if (!_isSessionActive || _lastActivityTime == null) {
    return Duration.zero;
  }
  final elapsed = DateTime.now().difference(_lastActivityTime!);
  final remaining = _sessionTimeout - elapsed;
  return remaining.isNegative ? Duration.zero : remaining;
}

// Timeout Configuration
Future<void> setSessionTimeout(Duration timeout);
Duration getSessionTimeout() => _sessionTimeout;

// Callbacks
void setSessionExpiredCallback(VoidCallback callback);

// Cold Start Detection
Future<bool> hasValidSession();
```

**Usage Example:**
```dart
// Initialize in main.dart
final sessionManager = GetIt.instance<SessionManager>();
sessionManager.setSessionExpiredCallback(() {
  // Navigate to login
  context.go(AppRoutes.login);
});
await sessionManager.restoreSession();

// Start session after login
await sessionManager.startSession();

// Update activity on user interaction
sessionManager.updateActivity();

// Check remaining time
final remaining = sessionManager.getRemainingSessionTime();
print('Session expires in: ${remaining.inMinutes} minutes');
```

**Session Check Timer:**
- Runs every 1 minute
- Automatically validates session
- Triggers logout if session expired
- Canceled when session ends

**Storage Keys:**
```dart
static const _keyLastActivity = 'session_last_activity';
static const _keyIsActive = 'session_is_active';
static const _keySessionTimeout = 'session_timeout_seconds';
```

**Cold Start Flow:**
```dart
// In main.dart or splash screen
final hasSession = await sessionManager.hasValidSession();
if (hasSession) {
  await sessionManager.restoreSession();
  // Navigate to home
} else {
  // Navigate to login
}
```

---

### 3. BiometricService

**Location:** `lib/core/security/biometric_service.dart`

**Purpose:** Low-level wrapper for the `local_auth` package.

**Features:**
- Simple biometric authentication interface
- Device biometric capability checking

**Methods:**
```dart
Future<bool> canCheck();
Future<bool> authenticate({
  required String localizedReason,
  bool useErrorDialogs = true,
  bool stickyAuth = false,
});
```

**Usage Example:**
```dart
final biometricService = GetIt.instance<BiometricService>();

if (await biometricService.canCheck()) {
  final authenticated = await biometricService.authenticate(
    localizedReason: 'Please authenticate to login',
  );
}
```

---

### 4. LocalAuthService

**Location:** `lib/core/security/local_auth_service.dart`

**Purpose:** High-level biometric authentication service with comprehensive device detection.

**Features:**
- Detailed biometric type detection
- Platform-specific biometric checking
- Enhanced authentication flow
- Authentication cancellation support

**Methods:**

```dart
// Capability Detection
Future<bool> isBiometricAvailable();
Future<List<BiometricType>> getAvailableBiometrics();
Future<bool> hasFingerprint();
Future<bool> hasFaceID();

// Authentication
Future<bool> authenticate({
  String localizedReason = 'Please authenticate',
  bool useErrorDialogs = true,
  bool biometricOnly = true,
});

Future<void> stopAuthentication();
```

**Implementation Details:**

**Fingerprint Detection:**
```dart
Future<bool> hasFingerprint() async {
  if (!Platform.isAndroid && !Platform.isIOS) return false;

  final available = await isBiometricAvailable();
  if (!available) return false;

  final types = await getAvailableBiometrics();
  return types.contains(BiometricType.fingerprint) ||
         types.contains(BiometricType.strong) ||
         types.contains(BiometricType.weak);
}
```

**Face ID Detection (iOS-specific):**
```dart
Future<bool> hasFaceID() async {
  if (!Platform.isIOS) return false;

  final available = await isBiometricAvailable();
  if (!available) return false;

  final types = await getAvailableBiometrics();
  return types.contains(BiometricType.face);
}
```

**Usage Example:**
```dart
final localAuth = GetIt.instance<LocalAuthService>();

// Check capabilities
final hasFingerprint = await localAuth.hasFingerprint();
final hasFaceID = await localAuth.hasFaceID();

// Authenticate
if (await localAuth.isBiometricAvailable()) {
  final success = await localAuth.authenticate(
    localizedReason: 'Unlock app',
    biometricOnly: true,
  );
}
```

**BiometricType Enum (from local_auth):**
- `BiometricType.face` - Face ID (iOS)
- `BiometricType.fingerprint` - Touch ID (iOS) or Fingerprint (Android)
- `BiometricType.strong` - Strong biometric (Android)
- `BiometricType.weak` - Weak biometric (Android)
- `BiometricType.iris` - Iris scanner

---

### 5. SecureStorageService

**Location:** `lib/core/security/secure_storage_service.dart`

**Purpose:** Encrypted storage for sensitive user data using `flutter_secure_storage`.

**Features:**
- Hardware-backed encryption (where available)
- Keychain storage (iOS) / Keystore (Android)
- Credential management
- Session data persistence
- Transaction history encryption

**Storage Architecture:**
```
SecureStorageService
    ↓
flutter_secure_storage
    ↓
Platform Storage
    ├─ iOS: Keychain
    └─ Android: EncryptedSharedPreferences + Keystore
```

**Stored Data Categories:**

**1. Authentication Data:**
```dart
static const keyAuthToken = 'auth_token';
static const keyRefreshToken = 'refresh_token';
static const keyUserId = 'user_id';
```

**2. Biometric Data:**
```dart
static const keyBiometricEmail = 'biometric_email';
static const keyBiometricPassword = 'biometric_password';
static const keyBiometricEnabled = 'biometric_enabled';
static const keyBiometricType = 'biometric_type';
```

**3. Session Data:**
```dart
static const keyLastActivity = 'last_activity';
static const keySessionActive = 'session_active';
```

**4. App Lock Data:**
```dart
static const keyAutoLockTimeout = 'auto_lock_timeout';
```

**5. Transaction Data:**
```dart
static const keyTransactionHistory = 'transaction_history';
```

**Public Methods:**

**Authentication:**
```dart
Future<void> saveAuthToken(String token);
Future<String?> getAuthToken();

Future<void> saveRefreshToken(String token);
Future<String?> getRefreshToken();

Future<void> saveUserId(String userId);
Future<String?> getUserId();
```

**Biometric Credentials:**
```dart
Future<void> saveBiometricCredentials(String email, String password);
Future<String?> getBiometricEmail();
Future<String?> getBiometricPassword();

Future<void> setBiometricEnabled(bool enabled);
Future<bool> isBiometricEnabled();

Future<void> setBiometricType(String type);  // 'face' or 'fingerprint'
Future<String?> getBiometricType();
```

**Session Management:**
```dart
Future<void> saveLastActivity(DateTime dateTime);
Future<DateTime?> getLastActivity();

Future<void> setSessionActive(bool active);
Future<bool> isSessionActive();
```

**App Lock:**
```dart
Future<void> saveAutoLockTimeout(int seconds);
Future<int?> getAutoLockTimeout();
```

**Transaction History:**
```dart
Future<void> saveTransactionHistory(List<Map<String, dynamic>> transactions);
Future<List<Map<String, dynamic>>> getTransactionHistory();
```

**Data Cleanup:**
```dart
// Clear user data but keep settings
Future<void> clearUserData() async {
  await deleteAuthToken();
  await deleteRefreshToken();
  await deleteUserId();
  await deleteBiometricCredentials();
  // Biometric settings remain
}

// Complete logout - wipe everything
Future<void> completeLogout() async {
  await _storage.deleteAll();
}
```

**Usage Example:**
```dart
final storage = GetIt.instance<SecureStorageService>();

// Save login credentials
await storage.saveAuthToken('jwt_token_here');
await storage.saveUserId('user123');

// Save biometric credentials
await storage.saveBiometricCredentials(email, password);
await storage.setBiometricEnabled(true);
await storage.setBiometricType('face');

// Retrieve for biometric login
final email = await storage.getBiometricEmail();
final password = await storage.getBiometricPassword();

// Logout
await storage.clearUserData();
```

**Security Features:**
- Automatic encryption/decryption
- Platform-specific secure storage
- No plaintext storage of passwords
- Secure deletion of sensitive data

---

### 6. BlurService

**Location:** `lib/core/security/blur_service.dart`

**Purpose:** Prevents sensitive data from appearing in app switcher/recent apps.

**Features:**
- Automatically blurs app content when backgrounded
- Native platform integration
- Prevents screenshot leakage

**Implementation:**
```dart
class BlurService {
  static Widget wrapWithBlur(Widget child) {
    return SecureApplication(
      child: child,
    );
  }
}
```

**Usage in main.dart:**
```dart
@override
Widget build(BuildContext context) {
  return BlurService.wrapWithBlur(
    MaterialApp(
      // app configuration
    ),
  );
}
```

**How it works:**
- `SecureApplication` widget from `secure_application` package
- Detects app lifecycle changes
- Applies blur overlay when app is backgrounded
- Removes blur when app is foregrounded

**Platform Behavior:**
- **iOS:** Adds blur to app snapshot in app switcher
- **Android:** Prevents content from appearing in recent apps screen

---

### 7. RootDetectionService

**Location:** `lib/core/security/root_detection_service.dart`

**Purpose:** Detects compromised or unsafe devices that may pose security risks.

**Features:**
- Root/jailbreak detection
- Emulator detection
- Developer mode detection
- External storage access detection
- Location mocking detection

**SecurityCheckResult Model:**
```dart
class SecurityCheckResult {
  final bool isDeviceSecure;      // Overall security status
  final bool isRealDevice;        // Not an emulator
  final bool isJailbroken;        // Device is rooted/jailbroken
  final bool isDevelopmentMode;   // Developer options enabled
  final bool hasExternalStorage;  // External storage accessible
  final bool canMockLocation;     // Location spoofing possible
}
```

**Methods:**
```dart
Future<SecurityCheckResult> performSecurityCheck();
```

**Implementation Details:**
```dart
Future<SecurityCheckResult> performSecurityCheck() async {
  final isRealDevice = await SafeDevice.isRealDevice;
  final isJailbroken = await SafeDevice.isJailBroken;
  final isDevelopmentMode = await SafeDevice.isDevelopmentModeEnable;
  final hasExternalStorage = await SafeDevice.canAccessExternalStorage;
  final canMockLocation = await SafeDevice.canMockLocation;

  final isDeviceSecure = isRealDevice &&
                         !isJailbroken &&
                         !isDevelopmentMode;

  return SecurityCheckResult(
    isDeviceSecure: isDeviceSecure,
    isRealDevice: isRealDevice,
    isJailbroken: isJailbroken,
    isDevelopmentMode: isDevelopmentMode,
    hasExternalStorage: hasExternalStorage,
    canMockLocation: canMockLocation,
  );
}
```

**Usage Example:**
```dart
final rootDetection = GetIt.instance<RootDetectionService>();
final result = await rootDetection.performSecurityCheck();

if (!result.isDeviceSecure) {
  // Show warning to user
  if (result.isJailbroken) {
    print('Warning: Device is rooted/jailbroken');
  }
  if (!result.isRealDevice) {
    print('Warning: Running on emulator');
  }
  if (result.isDevelopmentMode) {
    print('Warning: Developer mode is enabled');
  }
}
```

**Security Recommendations:**
- Perform check on app startup
- Consider blocking critical operations on insecure devices
- Log security check results for audit
- Warn users about potential risks

---

## Security Flows

### 1. App Launch Security Flow

```
┌─────────────────┐
│  App Launched   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Root Detection  │
│ Security Check  │
└────────┬────────┘
         │
         ├─→ Insecure device → Show warning
         │
         ↓
┌─────────────────┐
│ Session Manager │
│ Restore Session │
└────────┬────────┘
         │
         ├─→ Valid session → Home
         └─→ No session → Login
```

### 2. Login Security Flow

```
┌─────────────────┐
│  User Logs In   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Store Auth Token│
│ in Secure       │
│ Storage         │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Start Session   │
│ (SessionManager)│
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Reset App Lock  │
│ (AppLockService)│
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Save Biometric  │
│ Credentials     │
│ (if enabled)    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Navigate to     │
│ Biometric Verify│
└─────────────────┘
```

### 3. Biometric Verification Security Flow

```
┌─────────────────┐
│ Biometric Screen│
│ Loaded          │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Update Activity │
│ (AppLockService)│
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Check Biometric │
│ Availability    │
└────────┬────────┘
         │
         ├─→ Not available → Fallback
         │
         ↓
┌─────────────────┐
│ Trigger Native  │
│ Biometric Prompt│
└────────┬────────┘
         │
         ├─→ Success → Retrieve credentials
         └─→ Failure → Show error
         │
         ↓
┌─────────────────┐
│ Login with      │
│ Stored Creds    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Start Session   │
└─────────────────┘
```

### 4. Auto-Lock Flow

```
┌─────────────────┐
│ App Backgrounded│
└────────┬────────┘
         │
         │ 2 minutes pass
         ↓
┌─────────────────┐
│ App Foregrounded│
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Check Should    │
│ Lock?           │
└────────┬────────┘
         │
         ├─→ No → Continue
         │
         ↓ Yes
┌─────────────────┐
│ Navigate to     │
│ App Lock Screen │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Biometric       │
│ Verification    │
└────────┬────────┘
         │
         ├─→ Success → Unlock app
         └─→ Failure → Stay locked
```

### 5. Session Timeout Flow

```
┌─────────────────┐
│ Session Timer   │
│ (every 1 min)   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Check Session   │
│ Validity        │
└────────┬────────┘
         │
         ├─→ Valid → Continue
         │
         ↓ Invalid
┌─────────────────┐
│ End Session     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Trigger Logout  │
│ Callback        │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Clear User Data │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Navigate to     │
│ Login Screen    │
└─────────────────┘
```

---

## Security Configuration

### Default Timeouts

```dart
// App Lock
Duration _autoLockTimeout = Duration(minutes: 2);

// Session
Duration _sessionTimeout = Duration(minutes: 30);
```

### Customization Example

```dart
// In settings screen or initialization
final appLockService = GetIt.instance<AppLockService>();
await appLockService.setAutoLockTimeout(Duration(minutes: 5));

final sessionManager = GetIt.instance<SessionManager>();
await sessionManager.setSessionTimeout(Duration(minutes: 60));
```

---

## Service Initialization

All security services should be registered in the dependency injection container:

**Location:** `lib/core/di/injection.dart` (or similar)

```dart
void setupSecurityServices() {
  final getIt = GetIt.instance;

  // Register as singletons
  getIt.registerLazySingleton(() => AppLockService());
  getIt.registerLazySingleton(() => SessionManager());
  getIt.registerLazySingleton(() => BiometricService());
  getIt.registerLazySingleton(() => LocalAuthService());
  getIt.registerLazySingleton(() => SecureStorageService());
  getIt.registerLazySingleton(() => RootDetectionService());
}
```

---

## Security App Lock Screen

**Location:** `lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart`

**Purpose:** Shown when app is locked due to inactivity.

**Features:**
- Biometric unlock option
- Manual password entry fallback
- Lock icon and message
- Theme-aware styling

**Flow:**
1. User returns to app after timeout
2. App detects lock should be active
3. Navigate to app lock screen
4. User authenticates via biometric or password
5. On success, unlock and return to previous screen

---

## Security Best Practices Implemented

### 1. Defense in Depth
- Multiple security layers (lock, session, biometric)
- No single point of failure

### 2. Secure by Default
- Auto-lock enabled by default
- Session timeout active by default
- Biometric storage opt-in

### 3. Data Protection
- All credentials encrypted at rest
- No plaintext password storage
- Secure deletion on logout

### 4. Platform Security
- Native biometric integration
- Hardware-backed encryption
- Keychain/Keystore usage

### 5. User Privacy
- Blur screen when backgrounded
- No data leakage in app switcher
- Root detection warns users

### 6. Session Management
- Automatic timeout
- Activity-based validation
- Periodic health checks

### 7. Error Handling
- Graceful biometric failures
- Fallback authentication methods
- User-friendly error messages

---

## Security Testing

### Test Scenarios

**1. App Lock Testing:**
- Background app for > 2 minutes
- Verify lock screen appears
- Test biometric unlock
- Test timeout customization

**2. Session Testing:**
- Let session expire (30 min)
- Verify automatic logout
- Test session restoration on restart
- Test activity updates extend session

**3. Biometric Testing:**
- Test Face ID flow
- Test Touch ID flow
- Test authentication failures
- Test authentication cancellation

**4. Storage Testing:**
- Save credentials
- Retrieve credentials
- Test clearUserData()
- Test completeLogout()

**5. Root Detection Testing:**
- Test on real device
- Test on emulator
- Test with developer mode on
- Verify warning display

### Debug Tools

**BiometricDebugScreen:** View biometric settings and test authentication
```dart
// Route: '/debug-biometrics'
```

**BiometricTestScreen:** Test biometric capabilities
```dart
// Route: '/biometric-test'
```

---

## Security Monitoring

### Logging

Consider adding security event logging:

```dart
// Example security logger
class SecurityLogger {
  static void logLogin(String userId) {
    print('[SECURITY] User logged in: $userId');
  }

  static void logBiometricAuth(bool success) {
    print('[SECURITY] Biometric auth: ${success ? 'SUCCESS' : 'FAILED'}');
  }

  static void logSessionExpired(String userId) {
    print('[SECURITY] Session expired: $userId');
  }

  static void logAppLock() {
    print('[SECURITY] App locked due to inactivity');
  }

  static void logRootDetection(SecurityCheckResult result) {
    print('[SECURITY] Device security check: ${result.isDeviceSecure}');
  }
}
```

### Analytics

Track security-related metrics:
- Biometric authentication success rate
- Session timeout frequency
- Auto-lock trigger rate
- Root detection results

---

## Integration with Features

### Home Screen
- Update session activity on user interaction
- Check app lock on app resume

### Settings Screen
- Configure auto-lock timeout
- Configure session timeout
- Enable/disable biometric
- View security status

### All Screens
- Wrap with blur protection
- Update activity on navigation
- Check session validity

---

## Migration Guide

### Adding Security to Existing App

1. **Install Dependencies:**
   ```yaml
   dependencies:
     flutter_secure_storage: ^latest
     local_auth: ^latest
     secure_application: ^latest
     safe_device: ^latest
   ```

2. **Copy Security Services:**
   - Copy all files from `lib/core/security/`

3. **Register Services:**
   - Add to dependency injection

4. **Wrap App with Blur:**
   ```dart
   BlurService.wrapWithBlur(MaterialApp(...))
   ```

5. **Initialize Session Manager:**
   ```dart
   await sessionManager.restoreSession();
   ```

6. **Add App Lock Screen:**
   - Add route for app lock
   - Check `shouldLock()` on app resume

7. **Integrate with Auth:**
   - Call `startSession()` after login
   - Call `resetLock()` after login
   - Save biometric credentials

---

## Future Security Enhancements

1. **Certificate Pinning** - Prevent MITM attacks
2. **Network Security** - Encrypted API communication
3. **Data Encryption at Rest** - Encrypt database
4. **Audit Logging** - Track security events
5. **Two-Factor Authentication** - Additional auth layer
6. **Biometric Re-enrollment** - Handle biometric changes
7. **Security Questions** - Account recovery
8. **Device Fingerprinting** - Detect device changes
9. **Anomaly Detection** - Unusual activity alerts
10. **Compliance Features** - GDPR, PCI-DSS support

---

## Common Security Issues & Solutions

### Issue: App doesn't lock automatically
**Solution:** Ensure `AppLockService.shouldLock()` is checked on app resume

### Issue: Session expires too quickly
**Solution:** Call `SessionManager.updateActivity()` on user interactions

### Issue: Biometric prompt shows twice
**Solution:** Call `AppLockService.resetLock()` after successful login

### Issue: Credentials not persisting
**Solution:** Verify `SecureStorageService` methods are awaited properly

### Issue: Root detection false positives
**Solution:** Check individual flags in `SecurityCheckResult` rather than just `isDeviceSecure`

---

## Security Contact

For security-related questions or to report vulnerabilities:
- Review: [SECURITY.md](../SECURITY.md)
- Check documentation in: `/docs/`
- Review source in: `lib/core/security/`

---

## Compliance Notes

### Data Privacy
- Biometric data never leaves device
- All storage is encrypted
- User data can be completely erased

### Platform Requirements
- iOS: Requires `NSFaceIDUsageDescription` in Info.plist
- Android: Requires `USE_BIOMETRIC` permission
- Both: Requires device passcode/PIN set up

### Security Standards
- Follows OWASP Mobile Security guidelines
- Implements secure storage best practices
- Uses platform-provided security features
- No custom cryptography implementation
