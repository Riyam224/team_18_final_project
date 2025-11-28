import '../repositories/auth_repository.dart';

class BiometricLoginUseCase {
  final AuthRepository repository;

  BiometricLoginUseCase(this.repository);

  Future<String> call() async {
    // Get stored email and password
    final email = await repository.getStoredEmail();
    final password = await repository.getStoredPassword();

    if (email == null || password == null) {
      throw Exception('No stored credentials found');
    }

    // Perform login with stored credentials
    return await repository.login(email, password);
  }
}
