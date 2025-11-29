import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/features/auth/domain/validation/email_validator.dart';

void main() {
  group('EmailValidator', () {
    group('validate', () {
      test('should return success for valid email', () {
        // arrange
        const email = 'test@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return success for valid email with subdomain', () {
        // arrange
        const email = 'user@mail.example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for valid email with plus sign', () {
        // arrange
        const email = 'user+tag@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for valid email with numbers', () {
        // arrange
        const email = 'user123@example456.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, true);
      });

      test('should return success for valid email with dots', () {
        // arrange
        const email = 'first.last@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, true);
      });

      test('should return failure for empty email', () {
        // arrange
        const email = '';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailRequired);
      });

      test('should return failure for email without @', () {
        // arrange
        const email = 'testexample.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email without domain', () {
        // arrange
        const email = 'test@';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email without local part', () {
        // arrange
        const email = '@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email without TLD', () {
        // arrange
        const email = 'test@example';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email with spaces', () {
        // arrange
        const email = 'test @example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email with multiple @', () {
        // arrange
        const email = 'test@@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email with invalid characters', () {
        // arrange
        const email = 'test#user@example.com';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });

      test('should return failure for email with short TLD', () {
        // arrange
        const email = 'test@example.c';

        // act
        final result = EmailValidator.validate(email);

        // assert
        expect(result.isValid, false);
        expect(result.error, ValidationMessagesConfig.emailInvalid);
      });
    });

    group('isValid', () {
      test('should return true for valid email', () {
        // arrange
        const email = 'test@example.com';

        // act
        final isValid = EmailValidator.isValid(email);

        // assert
        expect(isValid, true);
      });

      test('should return false for invalid email', () {
        // arrange
        const email = 'invalid-email';

        // act
        final isValid = EmailValidator.isValid(email);

        // assert
        expect(isValid, false);
      });

      test('should return false for empty email', () {
        // arrange
        const email = '';

        // act
        final isValid = EmailValidator.isValid(email);

        // assert
        expect(isValid, false);
      });
    });
  });
}
