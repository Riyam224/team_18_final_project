import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/auth/domain/validation/phone_validator.dart';

void main() {
  group('PhoneValidator', () {


    group('validate', () {
      test('should return valid result for 10-digit phone number', () {
        const phone = '1234567890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return valid result for phone with country code', () {
        const phone = '+11234567890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });

      test('should return valid result for phone with dashes', () {
        const phone = '123-456-7890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });

      test('should return valid result for phone with spaces', () {
        const phone = '123 456 7890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });

      test('should return valid result for phone with parentheses', () {
        const phone = '(123) 456-7890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });

      test('should return invalid result for empty phone', () {
        const phone = '';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, false);
        expect(result.error, isNotNull);
      });

      test('should return invalid result for phone with letters', () {
        const phone = '123abc7890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, false);
      });

      test('should return invalid result for phone too short', () {
        const phone = '12345';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, false);
      });

      test('should return invalid result for phone too long', () {
        const phone = '123456789012345678';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, false);
      });

      test('should trim whitespace before validation', () {
        const phone = '  1234567890  ';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });

      test('should return invalid result for special characters only', () {
        const phone = '!@#%^&*()';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, false);
      });

      test('should return valid result for international format', () {
        const phone = '+1 (123) 456-7890';
        final result = PhoneValidator.validate(phone);
        expect(result.isValid, true);
      });
    });
  });
}
