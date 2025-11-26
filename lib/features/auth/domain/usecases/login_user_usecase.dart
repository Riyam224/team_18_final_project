import '../repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<String> call(String email, String password) {
    return repository.login(email, password);
  }
}
