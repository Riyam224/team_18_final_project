import 'package:formz/formz.dart';

enum PhoneValidationError { empty, invalid }

class PhoneInput extends FormzInput<String, PhoneValidationError> {
  const PhoneInput.pure() : super.pure('');
  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  static final _digits = RegExp(r'^[0-9]{10,}$');

  @override
  PhoneValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PhoneValidationError.empty;
    if (!_digits.hasMatch(trimmed)) return PhoneValidationError.invalid;
    return null;
  }
}
