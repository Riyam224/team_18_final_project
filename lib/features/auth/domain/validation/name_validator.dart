import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Name validation logic
class NameValidator {
  const NameValidator._();

  /// Validates a name (first name or last name)
  static ValidationResult validate(String name) {
    if (name.isEmpty) {
      return const ValidationResult.failure('Name is required');
    }

    if (name.length < ValidationConfig.minNameLength) {
      return ValidationResult.failure(
        'Name must be at least ${ValidationConfig.minNameLength} characters',
      );
    }

    if (name.length > ValidationConfig.maxNameLength) {
      return ValidationResult.failure(
        'Name must not exceed ${ValidationConfig.maxNameLength} characters',
      );
    }

    if (!ValidationConfig.nameRegex.hasMatch(name)) {
      return const ValidationResult.failure(
        'Name can only contain letters and spaces',
      );
    }

    return const ValidationResult.success();
  }

  /// Validates a display name
  static ValidationResult validateDisplayName(String displayName) {
    if (displayName.isEmpty) {
      return const ValidationResult.failure('Display name is required');
    }

    if (displayName.length < ValidationConfig.minDisplayNameLength) {
      return ValidationResult.failure(
        'Display name must be at least ${ValidationConfig.minDisplayNameLength} characters',
      );
    }

    if (displayName.length > ValidationConfig.maxDisplayNameLength) {
      return ValidationResult.failure(
        'Display name must not exceed ${ValidationConfig.maxDisplayNameLength} characters',
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
