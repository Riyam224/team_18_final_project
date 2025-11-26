# Security Features - Quick Reference Guide

## 🚀 Quick Start

### 1. Biometric Login
```dart
// Check if available
final available = await LocalAuthService.isBiometricAvailable();

if (available) {
  // Authenticate
  final success = await LocalAuthService.authenticate(
    reason: 'Login to your account'
  );

  if (success) {
    // Login successful
  }
}
```

### 2. Store User Session
```dart
// After successful login
await SecureStorageService.saveAuthToken(token);
await SecureStorageService.saveUserId(userId);
await SessionManager.startSession();
```

### 3. Save Transaction
```dart
// Save encrypted transaction history
final transactions = [
  {'id': '1', 'amount': 100.0, 'date': '2025-01-01'},
  {'id': '2', 'amount': 50.0, 'date': '2025-01-02'},
];

await SecureStorageService.saveTransactionHistory(transactions);

// Retrieve encrypted transactions
final history = await SecureStorageService.getTransactionHistory();
```

### 4. Logout
```dart
// Normal logout (keeps biometric settings)
await SessionManager.logout();

// Complete logout (removes everything)
await SessionManager.completeLogout();
```

---

## 📱 Common Use Cases

### Lock Screen Implementation
```dart
class AppLockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final authenticated = await LocalAuthService.authenticate(
              reason: 'Unlock app to continue'
            );

            if (authenticated) {
              AppLockService.updateActivity();
              SessionManager.updateActivity();
              Navigator.pop(context);
            }
          },
          child: Text('Unlock with Biometrics'),
        ),
      ),
    );
  }
}
```

### Settings Screen - Configure Timeouts
```dart
class SecuritySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Auto-lock timeout
        ListTile(
          title: Text('Auto-lock timeout'),
          subtitle: Text('Lock after inactivity'),
          trailing: DropdownButton<int>(
            items: [1, 2, 5, 10].map((min) =>
              DropdownMenuItem(value: min, child: Text('$min min'))
            ).toList(),
            onChanged: (value) async {
              await AppLockService.setAutoLockTimeout(value!);
            },
          ),
        ),

        // Session timeout
        ListTile(
          title: Text('Session timeout'),
          subtitle: Text('Logout after inactivity'),
          trailing: DropdownButton<int>(
            items: [15, 30, 60].map((min) =>
              DropdownMenuItem(value: min, child: Text('$min min'))
            ).toList(),
            onChanged: (value) async {
              await SessionManager.setSessionTimeout(value!);
            },
          ),
        ),
      ],
    );
  }
}
```

### Protected Screen Example
```dart
// This screen is automatically protected by AppRouteObserver
class PortfolioScreen extends StatelessWidget {
  // Route: /portfolio
  // Screenshot & recording blocked automatically
  // Background blur enabled automatically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Portfolio')),
      body: FutureBuilder(
        future: SecureStorageService.getTransactionHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return ListTile(
                  title: Text('Amount: ${transaction['amount']}'),
                  subtitle: Text('Date: ${transaction['date']}'),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

---

## 🔧 Configuration

### Change Default Timeouts
```dart
// In main.dart or after dependencies setup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  // Configure defaults
  await AppLockService.setAutoLockTimeout(5); // 5 minutes
  await SecureStorageService.saveSessionTimeout(45); // 45 minutes

  runApp(const FintechApp());
}
```

### Disable Root Detection
```dart
// In main.dart, comment out or remove:
// await _performSecurityChecks();
```

### Add More Protected Routes
```dart
// In lib/core/observers/app_route_observer.dart
final List<String> sensitiveRoutes = [
  '/portfolio',
  '/transactions',
  '/payment',
  '/your-new-route', // Add here
];
```

---

## 🐛 Troubleshooting

### Biometrics Not Working
```dart
// Debug biometric availability
final available = await LocalAuthService.isBiometricAvailable();
print('Biometrics available: $available');

final types = await LocalAuthService.getAvailableBiometrics();
print('Available types: $types');

final hasFingerprint = await LocalAuthService.hasFingerprint();
final hasFace = await LocalAuthService.hasFaceID();
print('Fingerprint: $hasFingerprint, Face: $hasFace');
```

### Session Keeps Expiring
```dart
// Check current timeout
final timeout = await SessionManager.getSessionTimeout();
print('Session timeout: $timeout minutes');

// Increase timeout
await SessionManager.setSessionTimeout(60); // 60 minutes

// Check if session is active
print('Session active: ${SessionManager.isActive}');
```

### Auto-lock Not Triggering
```dart
// Check timeout setting
final timeout = await AppLockService.getAutoLockTimeout();
print('Auto-lock timeout: $timeout minutes');

// Check last activity
final lastActivity = await SecureStorageService.getLastActivity();
print('Last activity: $lastActivity');

// Force update activity
await AppLockService.updateActivity();
```

### Clear All Data (Development Only)
```dart
// CAUTION: This removes ALL encrypted data
await SecureStorageService.completeLogout();
```

---

## 📊 Check Security Status

```dart
// Get comprehensive security status
Future<void> checkSecurityStatus() async {
  print('=== Security Status ===');

  // Biometrics
  final bioAvailable = await LocalAuthService.isBiometricAvailable();
  final bioTypes = await LocalAuthService.getAvailableBiometrics();
  print('Biometrics available: $bioAvailable');
  print('Types: $bioTypes');

  // Storage
  final hasToken = await SecureStorageService.getAuthToken() != null;
  final hasUser = await SecureStorageService.getUserId() != null;
  print('Has auth token: $hasToken');
  print('Has user ID: $hasUser');

  // Session
  final sessionActive = SessionManager.isActive;
  final sessionTimeout = await SessionManager.getSessionTimeout();
  print('Session active: $sessionActive');
  print('Session timeout: $sessionTimeout min');

  // Auto-lock
  final lockTimeout = await AppLockService.getAutoLockTimeout();
  final shouldLock = await AppLockService.shouldLock();
  print('Auto-lock timeout: $lockTimeout min');
  print('Should lock: $shouldLock');

  // Root detection
  final securityCheck = await RootDetectionService.performSecurityCheck();
  print('Device safe: ${securityCheck.isSafe}');
  print('Rooted: ${securityCheck.isRooted}');
  print('Real device: ${securityCheck.isRealDevice}');

  print('=====================');
}
```

---

## 🎯 Best Practices

### 1. Always Update Activity
```dart
// On any user interaction
AppLockService.updateActivity();
SessionManager.updateActivity();
```

### 2. Handle Session Expiration Gracefully
```dart
// Check before sensitive operations
if (await SessionManager.isSessionValid()) {
  // Proceed with operation
} else {
  // Redirect to login
  context.go('/login');
}
```

### 3. Store Sensitive Data Securely
```dart
// ✅ Good
await SecureStorageService.saveAuthToken(token);

// ❌ Bad
SharedPreferences.setString('token', token);
```

### 4. Use Biometrics for Re-authentication
```dart
// Before sensitive actions (transfer money, change settings)
final authenticated = await LocalAuthService.authenticate(
  reason: 'Confirm this transaction'
);

if (authenticated) {
  // Proceed with action
}
```

### 5. Logout Properly
```dart
// On logout button
await SessionManager.logout(); // Keeps biometric settings

// On "Forget device"
await SessionManager.completeLogout(); // Removes everything
```

---

## 🔗 File Locations

| Feature | File Path |
|---------|-----------|
| Biometric Auth | `lib/core/security/local_auth_service.dart` |
| Encrypted Storage | `lib/core/security/secure_storage_service.dart` |
| Session Manager | `lib/core/security/session_manager.dart` |
| App Lock | `lib/core/security/app_lock_service.dart` |
| Root Detection | `lib/core/security/root_detection_service.dart` |
| Route Observer | `lib/core/observers/app_route_observer.dart` |
| Main App | `lib/main.dart` |

---

## 📚 Additional Resources

- [Full Documentation](SECURITY_FEATURES.md)
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md)
- [Package: flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [Package: local_auth](https://pub.dev/packages/local_auth)
- [Package: secure_application](https://pub.dev/packages/secure_application)
- [Package: safe_device](https://pub.dev/packages/safe_device)

---

**Last Updated:** 2025-11-26
**Version:** 1.0.0
