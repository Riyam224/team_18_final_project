import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricDebugScreen extends StatelessWidget {
  BiometricDebugScreen({super.key});

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> testBiometrics() async {
    print("---- BIOMETRIC DEBUG START ----");

    // Check if biometrics can be checked
    bool canCheck = await auth.canCheckBiometrics;
    print("canCheckBiometrics: $canCheck");

    // Check if device supports biometrics
    bool supported = await auth.isDeviceSupported();
    print("isDeviceSupported: $supported");

    // List available biometric types
    List<BiometricType> types = await auth.getAvailableBiometrics();
    print("Available biometrics: $types");

    // Try authenticating
    try {
      bool success = await auth.authenticate(
        localizedReason: "Test biometric authentication",
      );
      print("Authentication success: $success");
    } catch (e) {
      print("ERROR during authentication: $e");
    }

    print("---- BIOMETRIC DEBUG END ----");
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
