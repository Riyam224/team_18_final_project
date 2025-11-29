import 'package:equatable/equatable.dart';

/// Represents the result of a validation operation
class ValidationResult extends Equatable {
  final bool isValid;
  final String? error;

  const ValidationResult._({
    required this.isValid,
    this.error,
  });

  /// Creates a successful validation result
  const ValidationResult.success()
      : isValid = true,
        error = null;

  /// Creates a failed validation result with an error message
  const ValidationResult.failure(String error)
      : isValid = false,
        error = error;

  @override
  List<Object?> get props => [isValid, error];

  @override
  bool get stringify => true;
}
