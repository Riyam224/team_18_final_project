import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Phone number validation logic
class PhoneValidator {
  const PhoneValidator._();

  /// Validates a phone number
  static ValidationResult validate(String phone) {
    // Phone is optional, so empty is valid
    if (phone.isEmpty) {
      return const ValidationResult.success();
    }

    // Remove common formatting characters for validation
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleanPhone.length < ValidationConfig.minPhoneLength) {
      return ValidationResult.failure(
        'Phone number must be at least ${ValidationConfig.minPhoneLength} digits',
      );
    }

    if (cleanPhone.length > ValidationConfig.maxPhoneLength) {
      return ValidationResult.failure(
        'Phone number must not exceed ${ValidationConfig.maxPhoneLength} digits',
      );
    }

    if (!ValidationConfig.phoneRegex.hasMatch(phone)) {
      return const ValidationResult.failure(
        'Please enter a valid phone number',
      );
    }

    return const ValidationResult.success();
  }

  /// Validates a required phone number
  static ValidationResult validateRequired(String phone) {
    if (phone.isEmpty) {
      return const ValidationResult.failure('Phone number is required');
    }

    return validate(phone);
  }

  /// Checks if phone is valid (returns boolean for quick checks)
  static bool isValid(String phone) {
    return validate(phone).isValid;
  }

  /// Cleans a phone number (removes formatting)
  static String clean(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }
}
