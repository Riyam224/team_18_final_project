import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheck() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      // local_auth 3.0.0 uses only localizedReason parameter
      // The package handles biometric-only authentication by default
      return await _auth.authenticate(
        localizedReason: 'Verify your identity',
      );
    } on PlatformException catch (_) {
      // Handle platform exceptions gracefully (user cancelled, not available, etc.)
      return false;
    } catch (_) {
      return false;
    }
  }
}
