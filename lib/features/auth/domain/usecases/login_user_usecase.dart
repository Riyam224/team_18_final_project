import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:team_18_final_project/core/validation/input_cleaner.dart';
import '../entities/auth_session_entity.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<AuthFailure, AuthSessionEntity>> call(String email, String password) {
    final cleanedEmail = cleanInput(email);
    final cleanedPassword = cleanInput(password);

    debugPrint('EMAIL RAW="$email" CLEAN="$cleanedEmail"');
    return repository.login(cleanedEmail, cleanedPassword);
  }
}
