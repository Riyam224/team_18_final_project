import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Password validation logic
class PasswordValidator {
  const PasswordValidator._();

  /// Validates a password with all requirements
  static ValidationResult validate(String password) {
    final trimmed = password.trim();

    if (trimmed.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordRequired,
      );
    }

    if (trimmed.length < ValidationConfig.minPasswordLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getPasswordMinLengthMessage(
          ValidationConfig.minPasswordLength,
        ),
      );
    }

    if (trimmed.length > ValidationConfig.maxPasswordLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getPasswordMaxLengthMessage(
          ValidationConfig.maxPasswordLength,
        ),
      );
    }

    // Complexity checks
    if (ValidationConfig.requireUppercase &&
        !ValidationConfig.uppercaseRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordMissingUppercase,
      );
    }

    if (ValidationConfig.requireLowercase &&
        !ValidationConfig.lowercaseRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordMissingLowercase,
      );
    }

    if (ValidationConfig.requireNumber &&
        !ValidationConfig.numberRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordMissingNumber,
      );
    }

    if (ValidationConfig.requireSpecialChar &&
        !ValidationConfig.specialCharRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordMissingSpecialChar,
      );
    }

    return const ValidationResult.success();
  }

  /// Validates a password with minimum requirements only (for login)
  static ValidationResult validateMinimum(String password) {
    final trimmed = password.trim();

    if (trimmed.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordRequired,
      );
    }

    if (trimmed.length < ValidationConfig.minPasswordLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getPasswordMinLengthMessage(
          ValidationConfig.minPasswordLength,
        ),
      );
    }

    return const ValidationResult.success();
  }

  /// Validates password confirmation match
  static ValidationResult validateConfirmation(
    String password,
    String confirmation,
  ) {
    if (confirmation.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.confirmPasswordRequired,
      );
    }

    if (password != confirmation) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.passwordsDoNotMatch,
      );
    }

    return const ValidationResult.success();
  }

  /// Checks if password is valid (returns boolean for quick checks)
  static bool isValid(String password) {
    return validate(password).isValid;
  }

  /// Gets password strength (0-4)
  /// 0 = very weak, 1 = weak, 2 = medium, 3 = strong, 4 = very strong
  static int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= ValidationConfig.minPasswordLength) strength++;
    if (password.length >= 12) strength++;

    // Character variety checks
    if (ValidationConfig.uppercaseRegex.hasMatch(password) &&
        ValidationConfig.lowercaseRegex.hasMatch(password)) strength++;
    if (ValidationConfig.numberRegex.hasMatch(password)) strength++;
    if (ValidationConfig.specialCharRegex.hasMatch(password)) strength++;

    return strength > 4 ? 4 : strength;
  }
}
