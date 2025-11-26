import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if biometric authentication is available on device
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (e) {
      return false;
    }
  }

  /// Get list of available biometric types (fingerprint, face, iris, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Check if device has fingerprint capability
  static Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Check if device has Face ID capability
  static Future<bool> hasFaceID() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Authenticate user with biometrics
  /// Returns true if authentication successful, false otherwise
  static Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    bool biometricOnly = true,
  }) async {
    try {
      // Check if biometrics available
      final bool available = await isBiometricAvailable();
      if (!available) {
        return false;
      }

      // Check if any biometrics are enrolled
      final List<BiometricType> availableBiometrics =
          await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return false;
      }

      // Perform authentication
      // Note: local_auth 3.0.0 only supports localizedReason parameter
      final bool success = await _auth.authenticate(
        localizedReason: reason,
      );

      return success;
    } on PlatformException catch (e) {
      // Handle specific errors
      if (e.code == 'NotAvailable') {
        // Biometrics not available
        return false;
      } else if (e.code == 'NotEnrolled') {
        // No biometrics enrolled
        return false;
      } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        // Too many failed attempts
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Stop ongoing authentication
  static Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      // Ignore errors
    }
  }
}
