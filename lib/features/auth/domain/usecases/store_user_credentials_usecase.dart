import '../repositories/auth_repository.dart';

class StoreUserCredentialsUseCase {
  final AuthRepository repository;

  StoreUserCredentialsUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String token,
  }) {
    return repository.storeUserCredentials(
      userId: userId,
      token: token,
    );
  }
}
