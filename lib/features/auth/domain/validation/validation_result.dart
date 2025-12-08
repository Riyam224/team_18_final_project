import 'package:equatable/equatable.dart';

class ValidationResult extends Equatable {
  final bool isValid;
  final String? error;

  const ValidationResult.success()
      : isValid = true,
        error = null;

  const ValidationResult.failure(String error)
      : isValid = false,
        error = error;

  @override
  List<Object?> get props => [isValid, error];

  @override
  bool get stringify => true;
}
