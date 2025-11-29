import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/validation/input_cleaner.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_session_entity.dart';
import '../failures/auth_failure.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<AuthFailure, AuthSessionEntity>> call(UserModel user) {
    final cleaned = UserModel(
      firstName: user.firstName.trim(),
      lastName: user.lastName.trim(),
      email: cleanInput(user.email),
      phone: user.phone.trim(),
      password: cleanInput(user.password),
      biometricEnabled: user.biometricEnabled,
    );
    // Debug: log raw vs cleaned to diagnose hidden characters
    // ignore: avoid_print
    print('EMAIL RAW="${user.email}" CLEAN="${cleaned.email}"');
    return repository.register(cleaned);
  }
}
