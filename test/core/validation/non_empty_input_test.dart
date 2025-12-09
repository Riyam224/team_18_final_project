import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/validation/non_empty_input.dart';

void main() {
  group('NonEmptyInput', () {
    group('pure', () {
      test('should create pure NonEmptyInput with empty string', () {
        const input = NonEmptyInput.pure();
        expect(input.value, '');
        expect(input.isPure, true);
      });
    });

    group('dirty', () {
      test('should create dirty NonEmptyInput with provided value', () {
        const input = NonEmptyInput.dirty('test value');
        expect(input.value, 'test value');
        expect(input.isPure, false);
      });

      test(
          'should create dirty NonEmptyInput with empty string if no value provided',
          () {
        const input = NonEmptyInput.dirty();
        expect(input.value, '');
        expect(input.isPure, false);
      });
    });

    group('validator', () {
      test('should return null for non-empty value', () {
        const input = NonEmptyInput.dirty('test');
        expect(input.isValid, true);
      });

      test('should return null for value with spaces', () {
        const input = NonEmptyInput.dirty('test value with spaces');
        expect(input.isValid, true);
      });

      test('should return empty error for empty string', () {
        const input = NonEmptyInput.dirty('');
        expect(input.isNotValid, true);
        expect(input.error, NonEmptyValidationError.empty);
      });

      test('should return empty error for whitespace-only string', () {
        const input = NonEmptyInput.dirty('   ');
        expect(input.isNotValid, true);
        expect(input.error, NonEmptyValidationError.empty);
      });

      test('should validate after trimming whitespace', () {
        const input = NonEmptyInput.dirty('  test  ');
        expect(input.isValid, true);
      });

      test('should return null for single character', () {
        const input = NonEmptyInput.dirty('a');
        expect(input.isValid, true);
      });

      test('should return null for numbers', () {
        const input = NonEmptyInput.dirty('123');
        expect(input.isValid, true);
      });

      test('should return null for special characters', () {
        const input = NonEmptyInput.dirty('!@#');
        expect(input.isValid, true);
      });
    });
  });
}
