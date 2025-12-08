/// Validation messages configuration
/// Contains all validation error and success messages
class ValidationMessagesConfig {
  const ValidationMessagesConfig._();

  // Email Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';

  // Password Validation Messages
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String passwordTooWeak = 'Password is too weak';
  static const String passwordMissingUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordMissingLowercase =
      'Password must contain at least one lowercase letter';
  static const String passwordMissingNumber =
      'Password must contain at least one number';
  static const String passwordMissingSpecialChar =
      'Password must contain at least one special character';

  // Password Confirmation Messages
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Phone Validation Messages
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Please enter a valid phone number';

  static String getPhoneMinLengthMessage(int minLength) =>
      'Phone number must be at least $minLength digits';

  static String getPhoneMaxLengthMessage(int maxLength) =>
      'Phone number must not exceed $maxLength digits';

  // Name Validation Messages
  static const String nameRequired = 'Name is required';
  static const String fullNameRequired =
      'Please enter your full name (first and last name)';
  static const String nameInvalid = 'Please enter a valid name';
  static const String nameOnlyLettersAndSpaces =
      'Name can only contain letters and spaces';
  static const String displayNameRequired = 'Display name is required';

  static String getNameMinLengthMessage(int minLength) =>
      'Name must be at least $minLength characters';

  static String getNameMaxLengthMessage(int maxLength) =>
      'Name must not exceed $maxLength characters';

  static String getDisplayNameMinLengthMessage(int minLength) =>
      'Display name must be at least $minLength characters';

  static String getDisplayNameMaxLengthMessage(int maxLength) =>
      'Display name must not exceed $maxLength characters';

  // General Form Messages
  static const String allFieldsRequired = 'Please fill all fields';

  // Success Messages
  static const String registrationSuccess = 'Registration successful!';
  static const String loginSuccess = 'Login successful!';

  // Error Messages - Network
  static const String connectionTimedOut =
      'Connection timed out. Please try again.';
  static const String noInternet = 'No Internet connection.';
  static const String invalidRequest =
      'Invalid request. Please check your input.';
  static const String serverError =
      'A server error occurred. Please try again later.';
  static const String unexpectedError = 'An unexpected error occurred.';

  // Error Messages - Authorization
  static const String notAuthorized = 'You are not authorized.';
  static const String accessDenied = 'Access denied.';
  static const String resourceNotFound = 'Resource not found.';

  // Error Messages - Registration/Login
  static const String emailAlreadyInUse = 'This email is already in use.';
  static const String registrationFailed =
      'Registration failed. Please try again.';

  // Password Strength Messages
  static String getPasswordMinLengthMessage(int minLength) =>
      'Password must be at least $minLength characters';

  static String getPasswordMaxLengthMessage(int maxLength) =>
      'Password must not exceed $maxLength characters';
}
