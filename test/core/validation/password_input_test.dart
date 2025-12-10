import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/validation/password_input.dart';

void main() {
  group('PasswordInput', () {
    group('pure', () {
      test('should create pure PasswordInput with empty string', () {
        const passwordInput = PasswordInput.pure();
        expect(passwordInput.value, '');
        expect(passwordInput.isPure, true);
      });
    });

    group('dirty', () {
      test('should create dirty PasswordInput with provided value', () {
        const passwordInput = PasswordInput.dirty('Password123!');
        expect(passwordInput.value, 'Password123!');
        expect(passwordInput.isPure, false);
      });

      test(
          'should create dirty PasswordInput with empty string if no value provided',
          () {
        const passwordInput = PasswordInput.dirty();
        expect(passwordInput.value, '');
        expect(passwordInput.isPure, false);
      });
    });

    group('validator', () {
      test('should return null for valid password', () {
        const passwordInput = PasswordInput.dirty('Password123!');
        expect(passwordInput.isValid, true);
      });

      test('should return null for password with all character types', () {
        const passwordInput = PasswordInput.dirty('Abc123!@#');
        expect(passwordInput.isValid, true);
      });

      test('should return empty error for empty password', () {
        const passwordInput = PasswordInput.dirty('');
        expect(passwordInput.isNotValid, true);
        expect(passwordInput.error, PasswordValidationError.empty);
      });

      test('should return empty error for whitespace-only password', () {
        const passwordInput = PasswordInput.dirty('   ');
        expect(passwordInput.isNotValid, true);
        expect(passwordInput.error, PasswordValidationError.empty);
      });

      test('should return tooShort error for password less than minimum length',
          () {
        const passwordInput = PasswordInput.dirty('Abc1!');
        expect(passwordInput.isNotValid, true);
        expect(passwordInput.error, PasswordValidationError.tooShort);
      });

      test('should be valid for password without uppercase', () {
        const passwordInput = PasswordInput.dirty('password123!');
        expect(passwordInput.isValid, true);
      });

      test('should be valid for password without lowercase', () {
        const passwordInput = PasswordInput.dirty('PASSWORD123!');
        expect(passwordInput.isValid, true);
      });

      test('should be valid for password without number', () {
        const passwordInput = PasswordInput.dirty('PasswordTest!');
        expect(passwordInput.isValid, true);
      });

      test('should be valid for password without special character', () {
        const passwordInput = PasswordInput.dirty('Password123');
        expect(passwordInput.isValid, true);
      });

      test('should validate after trimming whitespace', () {
        const passwordInput = PasswordInput.dirty('  Password123!  ');
        expect(passwordInput.isValid, true);
      });

      test('should return null for password with multiple special characters',
          () {
        const passwordInput = PasswordInput.dirty('P@ssw0rd!#%');
        expect(passwordInput.isValid, true);
      });

      test('should return null for long password', () {
        const passwordInput =
            PasswordInput.dirty('VeryLongP@ssw0rdWithManyCharacters123!');
        expect(passwordInput.isValid, true);
      });
    });
  });
}
