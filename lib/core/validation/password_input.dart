import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  static const int minLength = 6;

  @override
  PasswordValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PasswordValidationError.empty;
    if (trimmed.length < minLength) return PasswordValidationError.tooShort;
    return null;
  }
}
