import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/name_validator.dart';

void main() {
  group('NameValidator', () {
    group('validate', () {
      test('should return success for valid name', () {
        // arrange
        const name = 'John';

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return success for name with spaces', () {
        // arrange
        const name = 'Mary Jane';

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for name at minimum length', () {
        // arrange
        const name = 'AB'; // Min length is 2

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for name at maximum length', () {
        // arrange
        final name = 'A' * 50; // Max length is 50

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty name', () {
        // arrange
        const name = '';

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.nameRequired);
      });

      test('should return failure for name shorter than minimum', () {
        // arrange
        const name = 'A'; // Less than minimum of 2

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getNameMinLengthMessage(
            ValidationConfig.minNameLength,
          ),
        );
      });

      test('should return failure for name longer than maximum', () {
        // arrange
        final name = 'A' * 51; // More than maximum of 50

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getNameMaxLengthMessage(
            ValidationConfig.maxNameLength,
          ),
        );
      });

      test('should return failure for name with numbers', () {
        // arrange
        const name = 'John123';

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.nameOnlyLettersAndSpaces,
        );
      });

      test('should return failure for name with special characters', () {
        // arrange
        const name = 'John@Doe';

        // act
        final result = NameValidator.validate(name);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.nameOnlyLettersAndSpaces,
        );
      });
    });

    group('validateDisplayName', () {
      test('should return success for valid display name', () {
        // arrange
        const displayName = 'JohnDoe123';

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for display name at minimum length', () {
        // arrange
        const displayName = 'ABC'; // Min length is 3

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for display name at maximum length', () {
        // arrange
        final displayName = 'A' * 30; // Max length is 30

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty display name', () {
        // arrange
        const displayName = '';

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.displayNameRequired);
      });

      test('should return failure for display name shorter than minimum', () {
        // arrange
        const displayName = 'AB'; // Less than minimum of 3

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getDisplayNameMinLengthMessage(
            ValidationConfig.minDisplayNameLength,
          ),
        );
      });

      test('should return failure for display name longer than maximum', () {
        // arrange
        final displayName = 'A' * 31; // More than maximum of 30

        // act
        final result = NameValidator.validateDisplayName(displayName);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getDisplayNameMaxLengthMessage(
            ValidationConfig.maxDisplayNameLength,
          ),
        );
      });
    });

    group('isValid', () {
      test('should return true for valid name', () {
        // arrange
        const name = 'John';

        // act
        final isValid = NameValidator.isValid(name);

        // assert
        expect(isValid, true);
      });

      test('should return false for invalid name', () {
        // arrange
        const name = 'John123';

        // act
        final isValid = NameValidator.isValid(name);

        // assert
        expect(isValid, false);
      });
    });

    group('isDisplayNameValid', () {
      test('should return true for valid display name', () {
        // arrange
        const displayName = 'JohnDoe';

        // act
        final isValid = NameValidator.isDisplayNameValid(displayName);

        // assert
        expect(isValid, true);
      });

      test('should return false for invalid display name', () {
        // arrange
        const displayName = 'AB'; // Too short

        // act
        final isValid = NameValidator.isDisplayNameValid(displayName);

        // assert
        expect(isValid, false);
      });
    });
  });
}
