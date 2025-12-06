import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/auth/domain/validation/password_validator.dart';

void main() {
  group('PasswordValidator', () {


    group('validate', () {
      test('should return valid result for strong password', () {
        const password = 'StrongP@ss123';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return valid result for password with all character types', () {
        const password = 'Abc123!@#';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, true);
      });

      test('should return invalid result for empty password', () {
        const password = '';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
        expect(result.error, isNotNull);
      });

      test('should return invalid result for password less than minimum length', () {
        const password = 'Abc1!';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
      });

      test('should return invalid result for password without uppercase', () {
        const password = 'password123!';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
      });

      test('should return invalid result for password without lowercase', () {
        const password = 'PASSWORD123!';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
      });

      test('should return invalid result for password without number', () {
        const password = 'PasswordTest!';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
      });

      test('should return invalid result for password without special character', () {
        const password = 'Password123';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, false);
      });

      test('should trim whitespace before validation', () {
        const password = '  StrongP@ss123  ';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, true);
      });

      test('should return valid result for password with multiple special characters', () {
        const password = 'P@ssw0rd!#%';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, true);
      });

      test('should return valid result for long password', () {
        const password = 'VeryLongP@ssw0rdWithManyCharacters123!';
        final result = PasswordValidator.validate(password);
        expect(result.isValid, true);
      });
    });
  });
}
