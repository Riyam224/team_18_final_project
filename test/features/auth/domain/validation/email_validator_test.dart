import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/auth/domain/validation/email_validator.dart';

void main() {
  group('EmailValidator', () {
    group('validate', () {
      test('should return valid result for correct email format', () {
        // Arrange
        const email = 'test@example.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return valid result for email with subdomain', () {
        // Arrange
        const email = 'user@mail.company.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, true);
      });

      test('should return valid result for email with numbers', () {
        // Arrange
        const email = 'user123@test456.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, true);
      });

      test('should return valid result for email with dots and underscores', () {
        // Arrange
        const email = 'user.name_test@example.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, true);
      });

      test('should return invalid result for empty email', () {
        // Arrange
        const email = '';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
        expect(result.error, isNotNull);
      });

      test('should return invalid result for email without @', () {
        // Arrange
        const email = 'testexample.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should return invalid result for email without domain', () {
        // Arrange
        const email = 'test@';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should return invalid result for email without username', () {
        // Arrange
        const email = '@example.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should return invalid result for email without TLD', () {
        // Arrange
        const email = 'test@example';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should return invalid result for email with spaces', () {
        // Arrange
        const email = 'test @example.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should trim whitespace before validation', () {
        // Arrange
        const email = '  test@example.com  ';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, true);
      });

      test('should return invalid result for multiple @ symbols', () {
        // Arrange
        const email = 'test@@example.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });

      test('should return invalid result for special characters in domain', () {
        // Arrange
        const email = 'test@exam!ple.com';

        // Act
        final result = EmailValidator.validate(email);

        // Assert
        expect(result.isValid, false);
      });
    });
  });
}
