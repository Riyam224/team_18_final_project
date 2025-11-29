import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    group('validate', () {
      test('should return success for valid password', () {
        // arrange
        const password = 'password123';

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return success for password at minimum length', () {
        // arrange
        const password = '123456'; // Minimum length is 6

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for password with special characters', () {
        // arrange
        const password = 'P@ssw0rd!';

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for long password within max length', () {
        // arrange
        final password = 'a' * 128; // Max length is 128

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty password', () {
        // arrange
        const password = '';

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.passwordRequired);
      });

      test('should return failure for password shorter than minimum', () {
        // arrange
        const password = '12345'; // Less than minimum of 6

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getPasswordMinLengthMessage(
            ValidationConfig.minPasswordLength,
          ),
        );
      });

      test('should return failure for password longer than maximum', () {
        // arrange
        final password = 'a' * 129; // More than maximum of 128

        // act
        final result = PasswordValidator.validate(password);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getPasswordMaxLengthMessage(
            ValidationConfig.maxPasswordLength,
          ),
        );
      });
    });

    group('validateMinimum', () {
      test('should return success for valid password', () {
        // arrange
        const password = 'password123';

        // act
        final result = PasswordValidator.validateMinimum(password);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for password at minimum length', () {
        // arrange
        const password = '123456';

        // act
        final result = PasswordValidator.validateMinimum(password);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty password', () {
        // arrange
        const password = '';

        // act
        final result = PasswordValidator.validateMinimum(password);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.passwordRequired);
      });

      test('should return failure for password shorter than minimum', () {
        // arrange
        const password = '12345';

        // act
        final result = PasswordValidator.validateMinimum(password);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getPasswordMinLengthMessage(
            ValidationConfig.minPasswordLength,
          ),
        );
      });

      test('should allow password longer than maximum (only checks minimum)',
          () {
        // arrange
        final password = 'a' * 200; // Exceeds max length

        // act
        final result = PasswordValidator.validateMinimum(password);

        // assert
        expect(result.isValid, true);
      });
    });

    group('validateConfirmation', () {
      test('should return success when passwords match', () {
        // arrange
        const password = 'password123';
        const confirmation = 'password123';

        // act
        final result = PasswordValidator.validateConfirmation(
          password,
          confirmation,
        );

        // assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return failure when confirmation is empty', () {
        // arrange
        const password = 'password123';
        const confirmation = '';

        // act
        final result = PasswordValidator.validateConfirmation(
          password,
          confirmation,
        );

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.confirmPasswordRequired,
        );
      });

      test('should return failure when passwords do not match', () {
        // arrange
        const password = 'password123';
        const confirmation = 'different456';

        // act
        final result = PasswordValidator.validateConfirmation(
          password,
          confirmation,
        );

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.passwordsDoNotMatch);
      });

      test('should return failure for case-sensitive mismatch', () {
        // arrange
        const password = 'Password123';
        const confirmation = 'password123';

        // act
        final result = PasswordValidator.validateConfirmation(
          password,
          confirmation,
        );

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.passwordsDoNotMatch);
      });
    });

    group('isValid', () {
      test('should return true for valid password', () {
        // arrange
        const password = 'password123';

        // act
        final isValid = PasswordValidator.isValid(password);

        // assert
        expect(isValid, true);
      });

      test('should return false for invalid password', () {
        // arrange
        const password = '12345';

        // act
        final isValid = PasswordValidator.isValid(password);

        // assert
        expect(isValid, false);
      });

      test('should return false for empty password', () {
        // arrange
        const password = '';

        // act
        final isValid = PasswordValidator.isValid(password);

        // assert
        expect(isValid, false);
      });
    });

    group('getPasswordStrength', () {
      test('should return 0 for empty password', () {
        // arrange
        const password = '';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 0);
      });

      test('should return 1 for short password with only letters', () {
        // arrange
        const password = 'abcdef'; // Meets min length only

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 1);
      });

      test('should return higher strength for password with mixed case', () {
        // arrange
        const password = 'AbCdEf';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 2); // Min length + mixed case
      });

      test('should return higher strength for password with numbers', () {
        // arrange
        const password = 'AbCdEf123';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 3); // Min length + mixed case + numbers
      });

      test('should return highest strength for complex password', () {
        // arrange
        const password = 'AbCdEf123!@#';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 4); // Min length + 12+ chars + mixed + numbers + special
      });

      test('should cap strength at 4', () {
        // arrange
        const password = 'VeryComplexP@ssw0rd123WithManyCharacters!';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 4); // Max strength
      });

      test('should return 2 for password with 12+ characters', () {
        // arrange
        const password = 'abcdefghijkl'; // 12 chars, lowercase only

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength, 2); // Min length + 12+ chars
      });

      test('should award strength for special characters', () {
        // arrange
        const password = 'abc123!@#';

        // act
        final strength = PasswordValidator.getPasswordStrength(password);

        // assert
        expect(strength >= 2, true); // Should have some strength
      });
    });
  });
}
