import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricDebugScreen extends StatelessWidget {
  BiometricDebugScreen({super.key});

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> testBiometrics() async {
    debugPrint("---- BIOMETRIC DEBUG START ----");

    // Check if biometrics can be checked
    bool canCheck = await auth.canCheckBiometrics;
    debugPrint("canCheckBiometrics: $canCheck");

    // Check if device supports biometrics
    bool supported = await auth.isDeviceSupported();
    debugPrint("isDeviceSupported: $supported");

    // List available biometric types
    List<BiometricType> types = await auth.getAvailableBiometrics();
    debugPrint("Available biometrics: $types");

    // Try authenticating
    try {
      bool success = await auth.authenticate(
        localizedReason: "Test biometric authentication",
      );
      debugPrint("Authentication success: $success");
    } catch (e) {
      debugPrint("ERROR during authentication: $e");
    }

    debugPrint("---- BIOMETRIC DEBUG END ----");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biometric Debug")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await testBiometrics();
          },
          child: const Text("RUN BIOMETRIC TEST"),
        ),
      ),
    );
  }
}
