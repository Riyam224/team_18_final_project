import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Name validation logic
class NameValidator {
  const NameValidator._();

  /// Validates a name (first name or last name)
  static ValidationResult validate(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.nameRequired,
      );
    }

    if (trimmed.length < ValidationConfig.minNameLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getNameMinLengthMessage(
          ValidationConfig.minNameLength,
        ),
      );
    }

    if (trimmed.length > ValidationConfig.maxNameLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getNameMaxLengthMessage(
          ValidationConfig.maxNameLength,
        ),
      );
    }

    if (!ValidationConfig.nameRegex.hasMatch(trimmed)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.nameOnlyLettersAndSpaces,
      );
    }

    return const ValidationResult.success();
  }

  /// Validates a display name
  static ValidationResult validateDisplayName(String displayName) {
    if (displayName.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.displayNameRequired,
      );
    }

    if (displayName.length < ValidationConfig.minDisplayNameLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getDisplayNameMinLengthMessage(
          ValidationConfig.minDisplayNameLength,
        ),
      );
    }

    if (displayName.length > ValidationConfig.maxDisplayNameLength) {
      return ValidationResult.failure(
        ValidationMessagesConfig.getDisplayNameMaxLengthMessage(
          ValidationConfig.maxDisplayNameLength,
        ),
      );
    }

    return const ValidationResult.success();
  }

  /// Checks if name is valid (returns boolean for quick checks)
  static bool isValid(String name) {
    return validate(name).isValid;
  }

  /// Checks if display name is valid (returns boolean for quick checks)
  static bool isDisplayNameValid(String displayName) {
    return validateDisplayName(displayName).isValid;
  }
}
