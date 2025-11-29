import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/validation_result.dart';

/// Email validation logic
class EmailValidator {
  const EmailValidator._();

  /// Validates an email address
  static ValidationResult validate(String email) {
    if (email.isEmpty) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.emailRequired,
      );
    }

    if (!ValidationConfig.emailRegex.hasMatch(email)) {
      return const ValidationResult.failure(
        ValidationMessagesConfig.emailInvalid,
      );
    }

    return const ValidationResult.success();
  }

  /// Checks if email is valid (returns boolean for quick checks)
  static bool isValid(String email) {
    return validate(email).isValid;
  }
}
