# Configuration Reference Guide

Quick reference for all configuration constants available in the app.

## Import

```dart
// Import all configs at once
import 'package:team_18_final_project/core/config/app_config.dart';

// Or import individually
import 'package:team_18_final_project/core/config/timing_config.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
```

---

## TimingConfig

### UI Delays
```dart
TimingConfig.shortDelay                  // Duration(milliseconds: 500)
TimingConfig.mediumDelay                 // Duration(seconds: 2)
TimingConfig.longDelay                   // Duration(seconds: 5)
```

### Biometric Delays
```dart
TimingConfig.biometricScanDelay         // Duration(milliseconds: 500)
TimingConfig.biometricSuccessDelay      // Duration(seconds: 2)
TimingConfig.biometricFailureDelay      // Duration(seconds: 2)
```

### Navigation Delays
```dart
TimingConfig.navigationDelay            // Duration(seconds: 2)
TimingConfig.autoNavigationDelay        // Duration(milliseconds: 500)
```

### Network Timeouts
```dart
TimingConfig.connectionTimeout          // Duration(seconds: 30)
TimingConfig.receiveTimeout             // Duration(seconds: 30)
TimingConfig.sendTimeout                // Duration(seconds: 30)
```

### Session & App Lock
```dart
TimingConfig.sessionTimeoutMinutes      // 30
TimingConfig.sessionTimeout             // Duration(minutes: 30)
TimingConfig.sessionPollInterval        // Duration(seconds: 30)
TimingConfig.autoLockTimeoutSeconds     // 120
TimingConfig.autoLockTimeout            // Duration(seconds: 120)
```

---

## ValidationConfig

### Password Rules
```dart
ValidationConfig.minPasswordLength      // 8
ValidationConfig.maxPasswordLength      // 128
ValidationConfig.requireUppercase       // true
ValidationConfig.requireLowercase       // true
ValidationConfig.requireNumber          // true
ValidationConfig.requireSpecialChar     // true
```

### Regex Patterns
```dart
ValidationConfig.emailRegex             // Email validation pattern
ValidationConfig.uppercaseRegex         // [A-Z]
ValidationConfig.lowercaseRegex         // [a-z]
ValidationConfig.numberRegex            // [0-9]
ValidationConfig.specialCharRegex       // Special characters
ValidationConfig.phoneRegex             // Phone number pattern
ValidationConfig.nameRegex              // Name validation pattern
```

### Field Lengths
```dart
ValidationConfig.minPhoneLength         // 10
ValidationConfig.maxPhoneLength         // 15
ValidationConfig.minNameLength          // 2
ValidationConfig.maxNameLength          // 50
ValidationConfig.minDisplayNameLength   // 3
ValidationConfig.maxDisplayNameLength   // 30
```

---

## ValidationMessagesConfig

### Email Messages
```dart
ValidationMessagesConfig.emailRequired
ValidationMessagesConfig.emailInvalid
```

### Password Messages
```dart
ValidationMessagesConfig.passwordRequired
ValidationMessagesConfig.passwordTooShort
ValidationMessagesConfig.passwordTooWeak
ValidationMessagesConfig.passwordMissingUppercase
ValidationMessagesConfig.passwordMissingNumber
ValidationMessagesConfig.passwordMissingSpecialChar
ValidationMessagesConfig.confirmPasswordRequired
ValidationMessagesConfig.passwordsDoNotMatch
```

### Dynamic Messages
```dart
ValidationMessagesConfig.getPasswordMinLengthMessage(8)
// Returns: "Password must be at least 8 characters"
```

### Phone & Name Messages
```dart
ValidationMessagesConfig.phoneRequired
ValidationMessagesConfig.phoneInvalid
ValidationMessagesConfig.nameRequired
ValidationMessagesConfig.fullNameRequired
```

### Network Error Messages
```dart
ValidationMessagesConfig.connectionTimedOut
ValidationMessagesConfig.noInternet
ValidationMessagesConfig.serverError
ValidationMessagesConfig.unexpectedError
```

---

## NetworkConfig

### API URLs
```dart
NetworkConfig.coinGeckoBaseUrl          // "https://api.coingecko.com/api/v3"
```

### HTTP Headers
```dart
NetworkConfig.acceptHeader              // "Accept"
NetworkConfig.acceptValue               // "application/json"
NetworkConfig.contentTypeHeader         // "Content-Type"
NetworkConfig.contentTypeValue          // "application/json"
NetworkConfig.apiKeyHeader              // "x-cg-demo-api-key"
```

### HTTP Status Codes
```dart
NetworkConfig.statusOk                  // 200
NetworkConfig.statusCreated             // 201
NetworkConfig.statusBadRequest          // 400
NetworkConfig.statusUnauthorized        // 401
NetworkConfig.statusNotFound            // 404
NetworkConfig.statusTooManyRequests     // 429
NetworkConfig.statusInternalServerError // 500
```

### Error Messages
```dart
NetworkConfig.rateLimitExceeded
NetworkConfig.unauthorizedRequest
```

### Log Prefixes
```dart
NetworkConfig.requestLogPrefix          // "🌐 [DioClient] Request →"
NetworkConfig.responseLogPrefix         // "✅ [DioClient] Response →"
NetworkConfig.errorLogPrefix            // "❌ [DioClient] Error →"
NetworkConfig.warningLogPrefix          // "⚠️"
```

---

## BiometricConfig

### Authentication Reasons
```dart
BiometricConfig.defaultAuthReason       // "Please authenticate to continue"
BiometricConfig.verifyIdentityReason    // "Verify your identity"
BiometricConfig.loginReason
BiometricConfig.setupReason
BiometricConfig.transactionReason
```

### Biometric Types
```dart
BiometricConfig.fingerprintType         // "fingerprint"
BiometricConfig.faceIdType              // "face"
BiometricConfig.noneType                // "none"
```

### Error Messages
```dart
BiometricConfig.authenticationFailed
BiometricConfig.fingerprintAuthFailed
BiometricConfig.faceIdAuthFailed
BiometricConfig.biometricNotAvailable
BiometricConfig.biometricNotEnrolled
```

---

## SecurityConfig

Uses delegation to other configs for better organization:

```dart
SecurityConfig.sessionTimeout           // → TimingConfig.sessionTimeout
SecurityConfig.autoLockTimeout          // → TimingConfig.autoLockTimeout
SecurityConfig.defaultBiometricReason   // → BiometricConfig.defaultAuthReason
SecurityConfig.maxAuditLogEntries       // → AuditLogConfig.maxAuditLogEntries
```

### Security Checks
```dart
SecurityConfig.enableRootDetection      // true
SecurityConfig.enableJailbreakDetection // true
SecurityConfig.enableEmulatorDetection  // true
SecurityConfig.enableScreenshotPrevention // true
```

---

## StorageKeysConfig

### Authentication Keys
```dart
StorageKeysConfig.userId
StorageKeysConfig.authToken
StorageKeysConfig.refreshToken
StorageKeysConfig.userEmail
```

### Biometric Keys
```dart
StorageKeysConfig.biometricEnabled
StorageKeysConfig.biometricType
StorageKeysConfig.biometricEmail
StorageKeysConfig.biometricPassword
```

### Session Keys
```dart
StorageKeysConfig.sessionId
StorageKeysConfig.sessionStartTime
StorageKeysConfig.lastActivityTime
StorageKeysConfig.sessionActive
```

### App Lock Keys
```dart
StorageKeysConfig.appLocked
StorageKeysConfig.lockTimestamp
StorageKeysConfig.autoLockEnabled
StorageKeysConfig.autoLockTimeout
```

---

## AuditLogConfig

### Settings
```dart
AuditLogConfig.maxAuditLogEntries       // 100
```

### Audit Log Types
```dart
AuditLogConfig.sessionStartType
AuditLogConfig.sessionEndType
AuditLogConfig.loginType
AuditLogConfig.logoutType
AuditLogConfig.biometricAuthType
```

### Audit Log Messages
```dart
AuditLogConfig.sessionStartedMessage
AuditLogConfig.userLoggedInMessage
AuditLogConfig.appLockedMessage
```

---

## FirebaseConfig

### Collections
```dart
FirebaseConfig.usersCollection          // "users"
```

### Fields
```dart
FirebaseConfig.emailField               // "email"
FirebaseConfig.displayNameField         // "displayName"
FirebaseConfig.biometricEnabledField    // "biometricEnabled"
FirebaseConfig.createdAtField           // "createdAt"
```

---

## Usage Examples

### Validation in Forms
```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return ValidationMessagesConfig.emailRequired;
  }
  if (!ValidationConfig.emailRegex.hasMatch(value)) {
    return ValidationMessagesConfig.emailInvalid;
  }
  return null;
}
```

### Network Configuration
```dart
final dio = Dio(
  BaseOptions(
    baseUrl: NetworkConfig.coinGeckoBaseUrl,
    connectTimeout: TimingConfig.connectionTimeout,
    headers: {
      NetworkConfig.acceptHeader: NetworkConfig.acceptValue,
    },
  ),
);
```

### Biometric Delays
```dart
Future.delayed(TimingConfig.biometricScanDelay, () {
  // Trigger biometric authentication
});
```

### Session Management
```dart
final isExpired = DateTime.now().difference(sessionStart) >
  TimingConfig.sessionTimeout;
```

---

## Best Practices

1. **Always use config constants** - Never hardcode values
2. **Import from app_config.dart** - Use the central export for convenience
3. **Document why you use specific configs** - Add comments explaining choices
4. **Don't modify config values at runtime** - They're meant to be compile-time constants
5. **Create new configs for new features** - Keep configs organized by domain

---

## Adding New Configuration Values

1. Choose or create appropriate config file
2. Add constant with descriptive name
3. Update this reference guide
4. Update app_config.dart export if needed
5. Replace hardcoded values in code
