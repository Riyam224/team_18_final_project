import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/validation/phone_input.dart';

void main() {
  group('PhoneInput', () {
    group('pure', () {
      test('should create pure PhoneInput with empty string', () {
        const phoneInput = PhoneInput.pure();
        expect(phoneInput.value, '');
        expect(phoneInput.isPure, true);
      });
    });

    group('dirty', () {
      test('should create dirty PhoneInput with provided value', () {
        const phoneInput = PhoneInput.dirty('1234567890');
        expect(phoneInput.value, '1234567890');
        expect(phoneInput.isPure, false);
      });

      test('should create dirty PhoneInput with empty string if no value provided', () {
        const phoneInput = PhoneInput.dirty();
        expect(phoneInput.value, '');
        expect(phoneInput.isPure, false);
      });
    });

    group('validator', () {
      test('should return null for valid 10-digit phone number', () {
        const phoneInput = PhoneInput.dirty('1234567890');
        expect(phoneInput.isValid, true);
      });

      test('should return null for phone number with 11+ digits', () {
        const phoneInput = PhoneInput.dirty('12345678901');
        expect(phoneInput.isValid, true);
      });

      test('should return null for long phone number', () {
        const phoneInput = PhoneInput.dirty('123456789012');
        expect(phoneInput.isValid, true);
      });

      test('should return empty error for empty phone', () {
        const phoneInput = PhoneInput.dirty('');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.empty);
      });

      test('should return empty error for whitespace-only phone', () {
        const phoneInput = PhoneInput.dirty('   ');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.empty);
      });

      test('should return invalid error for phone with letters', () {
        const phoneInput = PhoneInput.dirty('123abc7890');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should return invalid error for phone too short', () {
        const phoneInput = PhoneInput.dirty('12345');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should validate after trimming whitespace', () {
        const phoneInput = PhoneInput.dirty('  1234567890  ');
        expect(phoneInput.isValid, true);
      });

      test('should return invalid error for special characters', () {
        const phoneInput = PhoneInput.dirty('!@#%^&*()');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should return invalid error for phone with dashes', () {
        const phoneInput = PhoneInput.dirty('123-456-7890');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should return invalid error for phone with spaces', () {
        const phoneInput = PhoneInput.dirty('123 456 7890');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should return invalid error for phone with parentheses', () {
        const phoneInput = PhoneInput.dirty('(123) 456-7890');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });

      test('should return invalid error for phone with plus sign', () {
        const phoneInput = PhoneInput.dirty('+11234567890');
        expect(phoneInput.isNotValid, true);
        expect(phoneInput.error, PhoneValidationError.invalid);
      });
    });
  });
}
