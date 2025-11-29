import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/validation/input_cleaner.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_session_entity.dart';
import '../failures/auth_failure.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<AuthFailure, AuthSessionEntity>> call(String email, String password) {
    final cleanedEmail = cleanInput(email);
    final cleanedPassword = cleanInput(password);
    // Debug: log raw vs cleaned to diagnose hidden characters
    // ignore: avoid_print
    print('EMAIL RAW="$email" CLEAN="$cleanedEmail"');
    return repository.login(cleanedEmail, cleanedPassword);
  }
}
