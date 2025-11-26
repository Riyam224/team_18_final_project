# Security Features Documentation

This document outlines all the security features implemented in the Team 18 Fintech application.

## 🔐 Overview

The application implements comprehensive security measures to protect user data and ensure secure financial transactions:

1. **Biometric Authentication** (Fingerprint & Face ID)
2. **Encrypted Storage** for all sensitive data
3. **App Security** (Background blur, screenshot prevention)
4. **Root Detection** (Optional)
5. **Session Management** with automatic logout
6. **Auto-lock** after inactivity

---

## 1. Biometric Authentication

### Features
- ✅ **Fingerprint authentication** (Android & iOS)
- ✅ **Face ID support** (iOS)
- ✅ **Face unlock** (Android)
- ✅ **Fallback to PIN/Pattern** if biometrics fail

### Implementation
- **Service:** `lib/core/security/local_auth_service.dart`
- **Package:** `local_auth: ^3.0.0`

### Methods Available
```dart
// Check if biometrics are available
LocalAuthService.isBiometricAvailable()

// Get available biometric types
LocalAuthService.getAvailableBiometrics()

// Check for specific biometric types
LocalAuthService.hasFingerprint()
LocalAuthService.hasFaceID()

// Authenticate user
LocalAuthService.authenticate(reason: 'Please authenticate to continue')
```

### Configuration
**iOS:** `ios/Runner/Info.plist`
```xml
<key>NSFaceIDUsageDescription</key>
<string>Your face data is used to securely authenticate you.</string>
```

**Android:** `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

---

## 2. Encrypted Storage

### Features
- ✅ **Encrypted user credentials** (tokens, passwords)
- ✅ **Encrypted transaction history**
- ✅ **Secure biometric credentials storage**
- ✅ **Keychain (iOS) & EncryptedSharedPreferences (Android)**

### Implementation
- **Service:** `lib/core/security/secure_storage_service.dart`
- **Package:** `flutter_secure_storage: ^9.2.1`

### Data Encrypted
- User authentication tokens
- Refresh tokens
- User credentials for biometric login
- Transaction history
- Session timestamps
- App settings

### Methods Available
```dart
// User credentials
SecureStorageService.saveAuthToken(token)
SecureStorageService.getAuthToken()

// Biometric credentials
SecureStorageService.saveBiometricCredentials(email: email, password: password)
SecureStorageService.getBiometricEmail()
SecureStorageService.getBiometricPassword()

// Transaction history (encrypted)
SecureStorageService.saveTransactionHistory(transactions)
SecureStorageService.getTransactionHistory()

// Session management
SecureStorageService.saveLastActivity()
SecureStorageService.getLastActivity()

// Logout
SecureStorageService.clearUserData() // Keeps settings
SecureStorageService.completeLogout() // Removes everything
```

---

## 3. App Security

### 3.1 Background Blur
**Hides sensitive data when app goes to background**

- **Implementation:** `secure_application` package
- Automatically blurs app content in app switcher
- Prevents shoulder surfing
- Native implementation for both platforms

### 3.2 Screenshot Prevention
**Blocks screenshots on sensitive screens**

- **Sensitive screens:**
  - `/portfolio`
  - `/transactions`
  - `/buy-sell`
  - `/payment`
  - `/wallet`
  - `/settings`
  - `/profile`
  - `/account`

- **Implementation:** `lib/core/observers/app_route_observer.dart`
- Uses `SecureApplication` to block screenshots and screen recording
- Automatically enabled when navigating to sensitive screens

### Configuration
Screenshots are blocked using the `secure_application` package which sets:
- **Android:** `FLAG_SECURE` window flag
- **iOS:** Native blur and recording prevention

---

## 4. Root Detection (Optional)

### Features
- ✅ **Detects rooted/jailbroken devices**
- ✅ **Checks for emulator**
- ✅ **Detects development mode**
- ✅ **Location mocking detection**

### Implementation
- **Service:** `lib/core/security/root_detection_service.dart`
- **Package:** `safe_device: ^1.3.8`

### Methods Available
```dart
// Check if device is rooted/jailbroken
RootDetectionService.isDeviceRooted()

// Check if running on real device
RootDetectionService.isRealDevice()

// Check if development mode enabled
RootDetectionService.isDevelopmentModeEnabled()

// Comprehensive security check
final result = await RootDetectionService.performSecurityCheck()
if (!result.isSafe) {
  print(result.warningMessage);
}
```

### When to Use
Root detection runs on app startup. You can:
- Show warning to user
- Restrict certain features
- Log security events
- Deny access to the app (strict mode)

---

## 5. Session Management

### Features
- ✅ **Automatic session timeout** (default: 30 minutes)
- ✅ **Auto-logout on timeout**
- ✅ **Configurable timeout duration**
- ✅ **Activity tracking**

### Implementation
- **Service:** `lib/core/security/session_manager.dart`
- Tracks user activity
- Automatically logs out inactive users
- Secure token management

### Methods Available
```dart
// Initialize session manager
SessionManager.initialize(onSessionExpired: () {
  // Handle session expiration
})

// Start session after login
SessionManager.startSession()

// Check if session is valid
SessionManager.isSessionValid()

// Update activity
SessionManager.updateActivity()

// Configure timeout (in minutes)
SessionManager.setSessionTimeout(30)

// Logout
SessionManager.logout() // Clears user data
SessionManager.completeLogout() // Clears everything
```

### Configuration
```dart
// Default timeout: 30 minutes
// Change in SecureStorageService or via:
SessionManager.setSessionTimeout(60) // 60 minutes
```

---

## 6. Auto-lock After Inactivity

### Features
- ✅ **Auto-lock after inactivity** (default: 2 minutes)
- ✅ **Configurable timeout**
- ✅ **Activity tracking**
- ✅ **Unlock with biometrics or PIN**

### Implementation
- **Service:** `lib/core/security/app_lock_service.dart`
- Monitors user interaction
- Locks app after specified inactivity
- Shows lock screen on resume

### Methods Available
```dart
// Check if app should lock
AppLockService.shouldLock()

// Update activity timestamp
AppLockService.updateActivity()

// Configure auto-lock timeout (in minutes)
AppLockService.setAutoLockTimeout(5)

// Get current timeout
AppLockService.getAutoLockTimeout()

// Enable/disable auto-lock
AppLockService.enableAutoLock()
AppLockService.disableAutoLock()
```

### How It Works
1. App tracks user interactions (touches, navigation)
2. When app goes to background, timestamp is saved
3. On resume, checks elapsed time
4. If timeout exceeded, navigates to `/app-lock` screen
5. User must authenticate to unlock

### Configuration
```dart
// Default: 2 minutes
// Change timeout:
AppLockService.setAutoLockTimeout(5) // 5 minutes
```

---

## 🔒 Security Flow

### App Launch
1. Initialize dependencies
2. Perform root detection check
3. Initialize session manager
4. Update last activity timestamp

### User Login
1. Authenticate with email/password or biometrics
2. Store encrypted tokens
3. Start session
4. Save credentials for biometric login (if enabled)

### App Background
1. Save activity timestamp
2. Blur app content (secure_application)
3. Block screenshots on sensitive screens

### App Resume
1. Check session validity
2. Check if auto-lock timeout exceeded
3. Show lock screen if needed
4. Require biometric/PIN authentication

### User Logout
1. Clear user data from secure storage
2. End session
3. Navigate to login screen

---

## 📱 Platform-Specific Security

### iOS
- Keychain for secure storage
- Face ID with proper usage description
- Background blur native implementation
- LAContext for biometric authentication

### Android
- EncryptedSharedPreferences
- FLAG_SECURE for screenshot prevention
- BiometricPrompt for fingerprint/face
- Background blur using secure window flags

---

## 🎯 Best Practices

1. **Always use SecureStorageService** for sensitive data
2. **Never log** sensitive information (tokens, passwords)
3. **Enable auto-lock** on production builds
4. **Test biometrics** on real devices, not emulators
5. **Handle session expiration** gracefully
6. **Show clear messages** when security features trigger
7. **Update activity** on user interactions
8. **Use HTTPS** for all API calls
9. **Validate** all user inputs
10. **Keep dependencies updated**

---

## 🧪 Testing Security Features

### Test Biometric Authentication
```dart
// Check availability
final available = await LocalAuthService.isBiometricAvailable();
print('Biometrics available: $available');

// Test authentication
final authenticated = await LocalAuthService.authenticate();
print('Authenticated: $authenticated');
```

### Test Auto-Lock
1. Set short timeout: `AppLockService.setAutoLockTimeout(1)` (1 minute)
2. Minimize app
3. Wait 1+ minutes
4. Resume app
5. Should show lock screen

### Test Session Timeout
1. Set short timeout: `SessionManager.setSessionTimeout(5)` (5 minutes)
2. Leave app idle for 5+ minutes
3. Should auto-logout

### Test Root Detection
```dart
final result = await RootDetectionService.performSecurityCheck();
print('Safe: ${result.isSafe}');
print('Rooted: ${result.isRooted}');
print('Real device: ${result.isRealDevice}');
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_secure_storage: ^9.2.1  # Encrypted storage
  local_auth: ^3.0.0              # Biometric authentication
  secure_application: ^4.1.0       # Background blur & screenshot prevention
  safe_device: ^1.3.8             # Root detection
```

---

## 🚀 Future Enhancements

- [ ] Certificate pinning for API calls
- [ ] Jailbreak detection improvements
- [ ] Two-factor authentication (2FA)
- [ ] Biometric re-authentication for sensitive actions
- [ ] Security event logging
- [ ] Anomaly detection
- [ ] VPN detection
- [ ] Device fingerprinting

---

## 📝 Notes

- All timestamps are stored in ISO8601 format
- Tokens are never logged or exposed
- Biometric data never leaves the device
- Root detection is optional but recommended
- Session timeout is independent from auto-lock timeout
- Background blur works automatically via `SecureApplication`

---

## 🆘 Troubleshooting

### Biometrics not working
- Ensure device has biometrics enrolled
- Check permissions in manifest (Android) and Info.plist (iOS)
- Test on real device, not emulator

### Auto-lock not triggering
- Check timeout value: `AppLockService.getAutoLockTimeout()`
- Ensure activity updates are called
- Verify `/app-lock` route exists

### Session keeps expiring
- Check timeout value: `SessionManager.getSessionTimeout()`
- Ensure `SessionManager.updateActivity()` is called on user interactions
- Verify session is started after login

---

**Last Updated:** 2025-11-26
**Version:** 1.0.0
