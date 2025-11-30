# Authentication Flow Documentation

## Overview

This document describes the authentication system implemented in the application, including login, registration, and biometric authentication flows.

## Architecture

The authentication system follows Clean Architecture principles with three main layers:

```
presentation/ (UI + State Management)
    ↓
domain/ (Business Logic)
    ↓
data/ (Repository Implementation)
```

## Directory Structure

```
lib/features/auth/
├── domain/
│   ├── repositories/
│   │   └── auth_repository.dart          # Abstract interface
│   └── usecases/
│       ├── login_user_usecase.dart       # Login business logic
│       ├── register_user_usecase.dart    # Registration logic
│       ├── biometric_login_usecase.dart  # Biometric login
│       └── store_biometric_settings_usecase.dart
├── data/
│   ├── repositories/
│   │   └── auth_repository_impl.dart     # Implementation with mocks
│   └── models/
│       └── user_model.dart               # User data model
└── presentation/
    ├── cubits/
    │   ├── auth_cubit/                   # Main auth state management
    │   ├── biometric_setup_cubit/        # Biometric setup state
    │   └── biometric_verify_cubit/       # Biometric verification state
    └── screens/
        ├── login/                        # Login flow screens
        └── register/                     # Registration flow screens
```

## State Management

### AuthCubit

**Location:** `lib/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart`

**States:**
- `AuthInitial` - Initial state
- `AuthLoading` - Processing authentication
- `AuthLoginSuccess` - Login completed successfully
- `AuthRegisterSuccess` - Registration completed successfully
- `AuthError` - Authentication failed with error message

**Methods:**
- `login(email, password)` - Standard email/password login
- `register(user)` - New user registration
- `loginWithBiometric()` - Biometric-based login using stored credentials

**Integration:**
- Integrates with `SessionManager` to start user sessions
- Resets `AppLockService` state to prevent immediate lock after login
- Stores credentials in `SecureStorageService`

### BiometricSetupCubit

**Location:** `lib/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart`

**Purpose:** Manages biometric setup during registration flow

**States:**
- `BiometricSetupInitial`
- `BiometricSetupSaving`
- `BiometricSetupSuccess`
- `BiometricSetupError`

**Flow:**
1. User completes registration
2. Dialog offers biometric setup option
3. User selects biometric type (Face ID/Touch ID)
4. Credentials stored securely for future biometric login

### BiometricVerifyCubit

**Location:** `lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart`

**Purpose:** Manages biometric verification during login

**States:**
- `BiometricVerifyInitial`
- `BiometricVerifyLoading`
- `BiometricVerifySuccess`
- `BiometricVerifyFailed`

**Key Features:**
- Updates `AppLockService` activity BEFORE authentication to prevent auto-lock
- Emits success state immediately upon biometric verification
- Persists login asynchronously after success
- Retrieves and emits stored biometric type

## User Flows

### 1. Standard Login Flow

```
┌─────────────────┐
│  Login Screen   │
│  - Email field  │
│  - Password     │
│  - Remember me  │
└────────┬────────┘
         │
         │ User submits credentials
         ↓
┌─────────────────┐
│   AuthCubit     │
│  validates &    │
│  calls usecase  │
└────────┬────────┘
         │
         │ Success
         ↓
┌─────────────────┐
│ Save credentials│
│ to secure       │
│ storage         │
└────────┬────────┘
         │
         ├─→ AppLockService.resetLock()
         ├─→ SessionManager.startSession()
         └─→ Save biometric credentials
         │
         ↓
┌─────────────────┐
│ Navigate to     │
│ Biometric       │
│ Verification    │
└─────────────────┘
```

**Implementation Details:**

**Login Screen:** `lib/features/auth/presentation/screens/login/login_screen.dart`
- Email validation (format check)
- Password validation (minimum 6 characters)
- "Remember me" checkbox
- Form validation before submission
- Error display from cubit state

**Key Code Flow:**
```dart
// On form submit
context.read<AuthCubit>().login(email, password);

// On success, navigate to biometric
if (state is AuthLoginSuccess) {
  // Route to Face ID or Fingerprint verification screen
}
```

### 2. Registration Flow

```
┌─────────────────┐
│ Register Screen │
│  - First Name   │
│  - Last Name    │
│  - Email        │
│  - Phone        │
│  - Password     │
│  - Confirm Pass │
└────────┬────────┘
         │
         │ User submits form
         ↓
┌─────────────────┐
│   AuthCubit     │
│  register()     │
└────────┬────────┘
         │
         │ Success
         ↓
┌─────────────────┐
│ Session started │
│ User credentials│
│ stored          │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Show dialog:    │
│ "Set up         │
│ biometric?"     │
└────────┬────────┘
         │
         ├─→ Yes: Navigate to biometric setup
         └─→ No: Navigate to home
```

**Implementation Details:**

**Register Screen:** `lib/features/auth/presentation/screens/register/register_screen.dart`
- Multi-field form validation
- Password confirmation matching
- Phone number formatting
- Email format validation
- Success dialog with biometric setup option

**UserModel:**
```dart
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final bool biometricEnabled;
}
```

### 3. Biometric Login Flow (Face ID)

```
┌─────────────────┐
│ Face ID         │
│ Scanning Screen │
└────────┬────────┘
         │
         │ Auto-triggers verification
         ↓
┌─────────────────┐
│ BiometricVerify │
│ Cubit.verify()  │
└────────┬────────┘
         │
         ├─→ Update AppLockService activity
         │
         ↓
┌─────────────────┐
│ LocalAuthService│
│ .authenticate() │
│ (Native prompt) │
└────────┬────────┘
         │
         │ Success
         ↓
┌─────────────────┐
│ Emit success    │
│ state           │
└────────┬────────┘
         │
         │ Async
         ↓
┌─────────────────┐
│ Retrieve stored │
│ email/password  │
│ from secure     │
│ storage         │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Call            │
│ BiometricLogin  │
│ UseCase         │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Navigate to     │
│ success screen  │
└─────────────────┘
```

**Biometric Screens:**
- `faceid_scanning_login_screen.dart` - Face ID scanning UI
- `faceid_verify_login_screen.dart` - Face ID verification handler
- `fingerprint_verify_login_screen.dart` - Touch ID prompt
- `fingerprint_verify_success_login_screen.dart` - Success confirmation

**Key Implementation Note:**
The biometric verification updates the activity timestamp BEFORE authentication to prevent the auto-lock from triggering during the biometric prompt.

```dart
// In biometric_verify_cubit.dart
Future<void> verify() async {
  // Update activity FIRST to prevent auto-lock
  appLockService.updateActivity();

  // Then authenticate
  final success = await localAuthService.authenticate();

  if (success) {
    emit(BiometricVerifySuccess(biometricType));
    // Async login persistence
    _persistLogin();
  }
}
```

### 4. Biometric Setup Flow (Registration)

```
┌─────────────────┐
│ Registration    │
│ Complete        │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Show Dialog:    │
│ "Enable Face ID │
│ or Touch ID?"   │
└────────┬────────┘
         │
         │ User selects type
         ↓
┌─────────────────┐
│ Navigate to     │
│ setup screen    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Biometric Setup │
│ Screen shows    │
│ instructions    │
└────────┬────────┘
         │
         │ User confirms
         ↓
┌─────────────────┐
│ Native biometric│
│ enrollment      │
│ (if needed)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Store biometric │
│ type & enable   │
│ flag in secure  │
│ storage         │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Show success    │
│ screen          │
└─────────────────┘
```

**Biometric Setup Screens:**
- `fingerprint_setup_register_screen.dart` - Touch ID setup
- `fingerprint_success_register_screen.dart` - Touch ID success
- `faceid_setup_register_screen.dart` - Face ID setup
- `faceid_scanning_register_screen.dart` - Face ID scanning
- `faceid_success_register_screen.dart` - Face ID success

## Data Models

### Domain Entity: RegisterUserEntity

**Location:** `lib/features/auth/domain/entities/register_user_entity.dart`

```dart
/// Domain entity for user registration
/// Used in domain layer - no infrastructure concerns
class RegisterUserEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final bool biometricEnabled;
}
```

### Data Model: UserModel

**Location:** `lib/features/auth/data/models/user_model.dart`

```dart
/// Data transfer object for API/UI communication
/// Used in data and presentation layers
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final bool biometricEnabled;

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**Mapping:** UI `UserModel` → Domain `RegisterUserEntity` → Repository

See `lib/features/auth/data/mappers/user_mapper.dart` for conversion methods.

## Repository Pattern

### AuthRepository (Interface)

**Location:** `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
abstract class AuthRepository {
  // Authentication operations
  Future<Either<AuthFailure, AuthSessionEntity>> login(
    String email,
    String password,
  );

  Future<Either<AuthFailure, AuthSessionEntity>> register(
    RegisterUserEntity user,  // Domain entity, not data model
  );

  Future<Either<AuthFailure, void>> signOut();

  // Credential storage
  Future<Either<AuthFailure, void>> storeUserCredentials({
    required String userId,
    required String token,
  });

  Future<Either<BiometricFailure, void>> storeCredentialsForBiometric({
    required String email,
    required String password,
  });

  // Biometric operations
  Future<Either<BiometricFailure, void>> storeBiometricSettings({
    required String email,
    required String password,
    required String biometricType,
  });

  Future<Either<AuthFailure, bool>> isBiometricEnabled();
  Future<Either<AuthFailure, String?>> getBiometricType();

  // User data operations
  Future<Either<AuthFailure, void>> storeUserData(RegisterUserEntity user);
  Future<Either<AuthFailure, String?>> getUserFirstName();
}
```

**Note:** Repository uses `RegisterUserEntity` (domain) not `UserModel` (data), following Clean Architecture principles.

### AuthRepositoryImpl (Implementation)

**Location:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

**Current Implementation:**
- Returns mock data for testing
- All credential storage delegated to `SecureStorageService`
- Ready for API integration (replace mock returns with HTTP calls)

**Mock Responses:**
```dart
Future<String> login(String email, String password) async {
  await Future.delayed(Duration(seconds: 1)); // Simulate network
  return 'mock_auth_token_12345';
}

Future<String> register(UserModel user) async {
  await Future.delayed(Duration(seconds: 1));
  return 'mock_user_id_67890';
}
```

## Use Cases

### LoginUserUseCase

**Location:** `lib/features/auth/domain/usecases/login_user_usecase.dart`

**Purpose:** Handles standard email/password login

**Flow:**
1. Validate email and password format
2. Call repository login method
3. Store credentials on success
4. Return authentication token

### RegisterUserUseCase

**Location:** `lib/features/auth/domain/usecases/register_user_usecase.dart`

**Purpose:** Handles new user registration

**Flow:**
1. Validate user data
2. Call repository register method
3. Store user credentials
4. Return user ID

### BiometricLoginUseCase

**Location:** `lib/features/auth/domain/usecases/biometric_login_usecase.dart`

**Purpose:** Handles biometric-based login

**Flow:**
1. Retrieve stored email/password from secure storage
2. Call standard login with stored credentials
3. Store credentials again (refresh)
4. Return authentication token

**Key Point:** Biometric login internally uses the same login flow but with stored credentials.

### StoreBiometricSettingsUseCase

**Location:** `lib/features/auth/domain/usecases/store_biometric_settings_usecase.dart`

**Purpose:** Saves biometric preferences after setup

**Stores:**
- Biometric type ('face' or 'fingerprint')
- Enabled flag (true/false)
- User email and password (encrypted in secure storage)

## Security Integration

### Session Management

After successful login, the `SessionManager` is initialized:

```dart
// In auth_cubit.dart
final sessionManager = GetIt.instance<SessionManager>();
await sessionManager.startSession();
```

**Session Features:**
- 30-minute timeout by default
- Automatic logout on session expiry
- Session restoration on app restart
- Periodic validity checks

### App Lock Reset

To prevent immediate lock after login:

```dart
// In auth_cubit.dart
final appLockService = GetIt.instance<AppLockService>();
appLockService.resetLock();
```

This ensures users aren't immediately prompted for biometric verification after just logging in.

### Secure Credential Storage

All sensitive data is stored using `SecureStorageService`:

**Stored Data:**
- Authentication token
- Refresh token
- User ID
- Biometric credentials (email, password) - encrypted
- Biometric settings (type, enabled flag)

**Storage Keys:**
```dart
static const keyAuthToken = 'auth_token';
static const keyUserId = 'user_id';
static const keyBiometricEmail = 'biometric_email';
static const keyBiometricPassword = 'biometric_password';
static const keyBiometricEnabled = 'biometric_enabled';
static const keyBiometricType = 'biometric_type';
```

## Navigation Routes

**Routing Configuration:** `lib/core/routing/app_router.dart`

**Auth Routes:**
```dart
AppRoutes.login                        // /login
AppRoutes.register                     // /register

// Registration biometric flows
AppRoutes.setFingerprintRegister       // /setFingerprintRegister
AppRoutes.fingerprintSuccessRegister   // /fingerprintSuccessRegister
AppRoutes.setFaceIDRegister            // /setFaceIDRegister
AppRoutes.faceIdScanningRegister       // /faceIdScanningRegister
AppRoutes.faceIdSuccessRegister        // /faceIdSuccessRegister

// Login biometric flows
AppRoutes.verifyFingerprintLogin       // /verifyFingerprintLogin
AppRoutes.verifyFingerprintLoginSuccess // /verifyFingerprintLoginSuccess
AppRoutes.faceIdScanningLogin          // /faceIdScanningLogin
AppRoutes.faceIdVerifiedSuccessLogin   // /faceIdVerifiedSuccessLogin
```

## Recent Bug Fixes

Based on recent commits:

**Commit 2e84a91:** Fixed double-biometric prompt
- Issue: Users were prompted twice for biometric verification
- Fix: Reset `AppLockService` state after login flow
- Impact: Smoother login experience

**Commit 7d057ec:** Session restore + biometric gating
- Added session restoration on app restart
- Improved splash routing logic
- Enhanced biometric gating behavior

**Commit 6cf4874:** Face ID and blur screen fixes
- Fixed Face ID recognition issues
- Corrected blur screen display bugs

## Testing

### Debug Screens

**BiometricTestScreen:** `lib/features/auth/presentation/debug/biometric_test_screen.dart`
- Test biometric authentication
- Check available biometric types
- Debug biometric flows

**BiometricDebugScreen:** `lib/features/auth/presentation/debug/biometric_debug_screen.dart`
- View biometric settings
- Check stored credentials (masked)
- Test biometric availability

**Routes:**
```dart
'/biometric-test'      // BiometricTestScreen
'/debug-biometrics'    // BiometricDebugScreen
```

## API Integration Guide

To integrate with a real backend API:

1. **Update AuthRepositoryImpl:**
   ```dart
   // Replace mock implementation
   Future<String> login(String email, String password) async {
     final response = await http.post(
       Uri.parse('$baseUrl/auth/login'),
       body: {'email': email, 'password': password},
     );

     if (response.statusCode == 200) {
       final data = json.decode(response.body);
       return data['token'];
     } else {
       throw Exception('Login failed');
     }
   }
   ```

2. **Add error handling** in UseCases
3. **Implement token refresh** logic
4. **Add network connectivity checks**
5. **Update error states** in Cubits

## Best Practices Followed

1. **Clean Architecture** - Separation of concerns across layers
2. **Repository Pattern** - Abstract data sources from business logic
3. **Use Cases** - Single responsibility principle for business logic
4. **State Management** - Predictable state using Cubit/Bloc pattern
5. **Secure Storage** - Encrypted storage for sensitive data
6. **Biometric Integration** - Native platform biometric authentication
7. **Session Management** - Automatic timeout and validation
8. **Error Handling** - Comprehensive error states and messages

## Common Issues & Solutions

### Issue: Double biometric prompt
**Solution:** Ensure `AppLockService.resetLock()` is called after login

### Issue: Session expires immediately
**Solution:** Check `SessionManager.startSession()` is called after successful login

### Issue: Biometric not available
**Solution:** Use `LocalAuthService.isBiometricAvailable()` to check before showing biometric options

### Issue: Stored credentials not found
**Solution:** Verify `SecureStorageService.saveBiometricCredentials()` was called during login/registration

## Future Enhancements

- Multi-factor authentication (MFA)
- Social login (Google, Apple)
- Password reset flow
- Email verification
- Account recovery options
- Biometric re-enrollment
- Security questions
