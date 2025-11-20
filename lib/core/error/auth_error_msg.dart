class ErrorMessages {
  // Network Errors
  static const timeout = 'Connection timed out. Please try again.';
  static const noInternet = 'No Internet connection.';
  static const badRequest = 'Invalid request. Please check your input.';
  static const unauthorized = 'You are not authorized.';
  static const forbidden = 'Access denied.';
  static const notFound = 'Resource not found.';
  static const emailAlreadyExists = 'This email is already in use.';
  static const serverError = 'A server error occurred. Please try again later.';
  static const registrationFailed = 'Registration failed. Please try again.';
  static const unexpectedError = 'An unexpected error occurred.';

  // Success Messages
  static const registrationSuccess = 'Registration successful!';
  static const loginSuccess = 'Login successful!';

  // Validation Messages
  static const emptyFields = 'Please fill all fields';
  static const invalidEmail = 'Please enter a valid email address';
  static const weakPassword = 'Password is too weak';
  static const invalidUsername =
      'Please enter your full name (first and last name)';

  static String getErrorMessage(dynamic error) => error.toString();

  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return emptyFields;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return invalidEmail;
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return emptyFields;
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate username (should have at least first and last name)
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return emptyFields;
    }

    final nameParts = username
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.length < 2) {
      return invalidUsername;
    }

    return null;
  }
}
