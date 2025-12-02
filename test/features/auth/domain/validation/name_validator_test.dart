import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/auth/domain/validation/name_validator.dart';

void main() {
  group('NameValidator', () {


    group('validate', () {
      test('should return valid result for simple name', () {
        const name = 'John';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should return valid result for name with multiple words', () {
        const name = 'John Doe';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });

      test('should return valid result for name with hyphen', () {
        const name = 'Mary-Jane';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });

      test('should return valid result for name with apostrophe', () {
        const name = "O'Connor";
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });

      test('should return invalid result for empty name', () {
        const name = '';
        final result = NameValidator.validate(name);
        expect(result.isValid, false);
        expect(result.error, isNotNull);
      });

      test('should return invalid result for name with numbers', () {
        const name = 'John123';
        final result = NameValidator.validate(name);
        expect(result.isValid, false);
      });

      test('should return invalid result for name with special characters', () {
        const name = 'John@Doe';
        final result = NameValidator.validate(name);
        expect(result.isValid, false);
      });

      test('should return invalid result for name that is too short', () {
        const name = 'J';
        final result = NameValidator.validate(name);
        expect(result.isValid, false);
      });

      test('should trim whitespace before validation', () {
        const name = '  John Doe  ';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });

      test('should return invalid result for whitespace-only name', () {
        const name = '   ';
        final result = NameValidator.validate(name);
        expect(result.isValid, false);
      });

      test('should return valid result for long name', () {
        const name = 'Christopher Alexander Montgomery';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });

      test('should return valid result for two-letter name', () {
        const name = 'Jo';
        final result = NameValidator.validate(name);
        expect(result.isValid, true);
      });
    });
  });
}
