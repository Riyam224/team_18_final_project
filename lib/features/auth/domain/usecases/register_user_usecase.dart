import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:team_18_final_project/core/validation/input_cleaner.dart';
import '../entities/auth_session_entity.dart';
import '../entities/register_user_entity.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<AuthFailure, AuthSessionEntity>> call(RegisterUserEntity user) {
    final cleaned = RegisterUserEntity(
      firstName: user.firstName.trim(),
      lastName: user.lastName.trim(),
      email: cleanInput(user.email),
      phone: user.phone.trim(),
      password: cleanInput(user.password),
      biometricEnabled: user.biometricEnabled,
    );

    debugPrint('EMAIL RAW="${user.email}" CLEAN="${cleaned.email}"');
    return repository.register(cleaned);
  }
}
