import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Phone number validation logic
class PhoneValidator {
  const PhoneValidator._();

  /// Validates a phone number
  static ValidationResult validate(String phone) {
    final trimmed = phone.trim();

    if (trimmed.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.phoneRequired,
      );
    }

    // Remove common formatting characters for validation
    final cleanPhone = trimmed.replaceAll(RegExp(r'[\s\-()]'), '');

    if (cleanPhone.length < ValidationConfig.minPhoneLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getPhoneMinLengthMessage(
          ValidationConfig.minPhoneLength,
        ),
      );
    }

    if (cleanPhone.length > ValidationConfig.maxPhoneLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getPhoneMaxLengthMessage(
          ValidationConfig.maxPhoneLength,
        ),
      );
    }

    if (!ValidationConfig.phoneRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.phoneInvalid,
      );
    }

    return const ValidationResult.success();
  }

  /// Validates a required phone number
  static ValidationResult validateRequired(String phone) {
    if (phone.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.phoneRequired,
      );
    }

    return validate(phone);
  }

  /// Checks if phone is valid (returns boolean for quick checks)
  static bool isValid(String phone) {
    return validate(phone).isValid;
  }

  /// Cleans a phone number (removes formatting)
  static String clean(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-()]'), '');
  }
}
