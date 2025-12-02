import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/validation/email_input.dart';

void main() {
  group('EmailInput', () {
    group('pure', () {
      test('should create pure EmailInput with empty string', () {
        const emailInput = EmailInput.pure();
        expect(emailInput.value, '');
        expect(emailInput.isPure, true);
      });
    });

    group('dirty', () {
      test('should create dirty EmailInput with provided value', () {
        const emailInput = EmailInput.dirty('test@example.com');
        expect(emailInput.value, 'test@example.com');
        expect(emailInput.isPure, false);
      });

      test('should create dirty EmailInput with empty string if no value provided', () {
        const emailInput = EmailInput.dirty();
        expect(emailInput.value, '');
        expect(emailInput.isPure, false);
      });
    });

    group('validator', () {
      test('should return null for valid email', () {
        const emailInput = EmailInput.dirty('test@example.com');
        expect(emailInput.isValid, true);
      });

      test('should return null for valid email with subdomain', () {
        const emailInput = EmailInput.dirty('user@mail.company.com');
        expect(emailInput.isValid, true);
      });

      test('should return null for valid email with numbers', () {
        const emailInput = EmailInput.dirty('user123@test456.com');
        expect(emailInput.isValid, true);
      });

      test('should return null for valid email with dots and underscores', () {
        const emailInput = EmailInput.dirty('user.name_test@example.com');
        expect(emailInput.isValid, true);
      });

      test('should return empty error for empty email', () {
        const emailInput = EmailInput.dirty('');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.empty);
      });

      test('should return empty error for whitespace-only email', () {
        const emailInput = EmailInput.dirty('   ');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.empty);
      });

      test('should return invalid error for email without @', () {
        const emailInput = EmailInput.dirty('testexample.com');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should return invalid error for email without domain', () {
        const emailInput = EmailInput.dirty('test@');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should return invalid error for email without username', () {
        const emailInput = EmailInput.dirty('@example.com');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should return invalid error for email without TLD', () {
        const emailInput = EmailInput.dirty('test@example');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should return invalid error for email with spaces', () {
        const emailInput = EmailInput.dirty('test @example.com');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should validate after trimming whitespace', () {
        const emailInput = EmailInput.dirty('  test@example.com  ');
        expect(emailInput.isValid, true);
      });

      test('should return invalid error for multiple @ symbols', () {
        const emailInput = EmailInput.dirty('test@@example.com');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });

      test('should return invalid error for special characters in domain', () {
        const emailInput = EmailInput.dirty('test@exam!ple.com');
        expect(emailInput.isNotValid, true);
        expect(emailInput.error, EmailValidationError.invalid);
      });
    });
  });
}
