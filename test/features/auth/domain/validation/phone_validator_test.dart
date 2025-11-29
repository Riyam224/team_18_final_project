import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/phone_validator.dart';

void main() {
  group('PhoneValidator', () {
    group('validate', () {
      test('should return success for valid phone number', () {
        // arrange
        const phone = '+1234567890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return success for phone with spaces', () {
        // arrange
        const phone = '+1 234 567 890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for phone with dashes', () {
        // arrange
        const phone = '+1-234-567-890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for phone with parentheses', () {
        // arrange
        const phone = '+1 (234) 567-890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for empty phone (optional field)', () {
        // arrange
        const phone = '';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for phone at minimum length', () {
        // arrange
        const phone = '1234567890'; // 10 digits, min length

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for phone at maximum length', () {
        // arrange
        const phone = '123456789012345'; // 15 digits, max length

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for phone shorter than minimum', () {
        // arrange
        const phone = '123456789'; // 9 digits, less than minimum of 10

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getPhoneMinLengthMessage(
            ValidationConfig.minPhoneLength,
          ),
        );
      });

      test('should return failure for phone longer than maximum', () {
        // arrange
        const phone = '1234567890123456'; // 16 digits, more than maximum of 15

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, false);
        expect(
          result.error,
          ValidationMessagesConfig.getPhoneMaxLengthMessage(
            ValidationConfig.maxPhoneLength,
          ),
        );
      });

      test('should return failure for phone with letters', () {
        // arrange
        const phone = 'abc1234567890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.phoneInvalid);
      });

      test('should return failure for phone with invalid special characters',
          () {
        // arrange
        const phone = '+123@456#7890';

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.phoneInvalid);
      });

      test('should ignore formatting when checking length', () {
        // arrange
        const phone = '+1 (234) 567-890'; // 10 digits after cleaning

        // act
        final result = PhoneValidator.validate(phone);

        // assert
        expect(result.isValid, true);
      });
    });

    group('validateRequired', () {
      test('should return success for valid phone number', () {
        // arrange
        const phone = '+1234567890';

        // act
        final result = PhoneValidator.validateRequired(phone);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty phone', () {
        // arrange
        const phone = '';

        // act
        final result = PhoneValidator.validateRequired(phone);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.phoneRequired);
      });

      test('should return failure for invalid phone', () {
        // arrange
        const phone = '123'; // Too short

        // act
        final result = PhoneValidator.validateRequired(phone);

        // assert
        expect(result.isValid, false);
      });
    });

    group('isValid', () {
      test('should return true for valid phone', () {
        // arrange
        const phone = '+1234567890';

        // act
        final isValid = PhoneValidator.isValid(phone);

        // assert
        expect(isValid, true);
      });

      test('should return false for invalid phone', () {
        // arrange
        const phone = 'invalid';

        // act
        final isValid = PhoneValidator.isValid(phone);

        // assert
        expect(isValid, false);
      });

      test('should return true for empty phone (optional)', () {
        // arrange
        const phone = '';

        // act
        final isValid = PhoneValidator.isValid(phone);

        // assert
        expect(isValid, true);
      });
    });

    group('clean', () {
      test('should remove spaces from phone number', () {
        // arrange
        const phone = '+1 234 567 890';

        // act
        final cleaned = PhoneValidator.clean(phone);

        // assert
        expect(cleaned, '+1234567890');
      });

      test('should remove dashes from phone number', () {
        // arrange
        const phone = '+1-234-567-890';

        // act
        final cleaned = PhoneValidator.clean(phone);

        // assert
        expect(cleaned, '+1234567890');
      });

      test('should remove parentheses from phone number', () {
        // arrange
        const phone = '+1 (234) 567-890';

        // act
        final cleaned = PhoneValidator.clean(phone);

        // assert
        expect(cleaned, '+1234567890');
      });

      test('should return unchanged if no formatting', () {
        // arrange
        const phone = '+1234567890';

        // act
        final cleaned = PhoneValidator.clean(phone);

        // assert
        expect(cleaned, '+1234567890');
      });

      test('should handle empty string', () {
        // arrange
        const phone = '';

        // act
        final cleaned = PhoneValidator.clean(phone);

        // assert
        expect(cleaned, '');
      });
    });
  });
}
