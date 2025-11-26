import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<String> call(UserModel user) {
    return repository.register(user);
  }
}
