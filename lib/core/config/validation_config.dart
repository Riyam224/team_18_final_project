/// Validation configuration for the application
/// Contains all validation rules and regex patterns
class ValidationConfig {
  const ValidationConfig._();

  // Email Validation
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const bool requireUppercase = true;
  static const bool requireLowercase = true;
  static const bool requireNumber = true;
  static const bool requireSpecialChar = true;

  static final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp numberRegex = RegExp(r'[0-9]');
  static final RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // Phone Validation
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static final RegExp phoneRegex = RegExp(r'^[0-9+\-\s()]+$');

  // Name Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static final RegExp nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");

  // Display Name Validation
  static const int minDisplayNameLength = 3;
  static const int maxDisplayNameLength = 30;
}
