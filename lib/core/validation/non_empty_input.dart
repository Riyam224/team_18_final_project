import 'package:formz/formz.dart';

enum NonEmptyValidationError { empty }

class NonEmptyInput extends FormzInput<String, NonEmptyValidationError> {
  const NonEmptyInput.pure() : super.pure('');
  const NonEmptyInput.dirty([super.value = '']) : super.dirty();

  @override
  NonEmptyValidationError? validator(String value) {
    if (value.trim().isEmpty) return NonEmptyValidationError.empty;
    return null;
  }
}
