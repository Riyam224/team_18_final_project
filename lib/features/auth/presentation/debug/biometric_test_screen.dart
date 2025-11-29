import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';

class BiometricTestScreen extends StatefulWidget {
  const BiometricTestScreen({super.key});

  @override
  State<BiometricTestScreen> createState() => _BiometricTestScreenState();
}

class _BiometricTestScreenState extends State<BiometricTestScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  String debugText = "👉 Press a button below to test Face ID / Fingerprint.";

  /// =========================================================
  /// 🔍 FULL BIOMETRIC DEBUG (Capability + Supported Types)
  /// =========================================================
  Future<void> runFullDebug() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;
      bool supported = await _auth.isDeviceSupported();
      List<BiometricType> types = await _auth.getAvailableBiometrics();

      setState(() {
        debugText = """
📌 **Biometric Debug Info**
────────────────────────────
• canCheckBiometrics: $canCheck
• isDeviceSupported: $supported
• availableBiometrics: $types

🔍 If 'availableBiometrics' is empty → No fingerprint/face enrolled.
""";
      });
    } catch (e) {
      setState(() {
        debugText = "⚠️ Error while checking biometrics:\n$e";
      });
    }
  }

  /// =========================================================
  /// 🔐 TEST ACTUAL AUTHENTICATION
  /// =========================================================
  Future<void> testBiometric() async {
    final biometricService = sl<IBiometricService>();
    final result = await biometricService.authenticate(
      localizedReason: 'Test biometric authentication',
    );

    final success = result.fold(
      (failure) => false,
      (authenticated) => authenticated,
    );

    if (!mounted) return;

    setState(() {
      debugText = success
          ? "✅ Authentication Success!"
          : "❌ Authentication Failed (Canceled / Not Enrolled)";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "✅ Authenticated Successfully"
              : "❌ Authentication Failed or Canceled",
        ),
      ),
    );
  }

  /// =========================================================
  /// 🔧 UI
  /// =========================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Biometric Debug Tools")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 📝 OUTPUT BOX
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  debugText,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔐 AUTH TEST BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: testBiometric,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Test Face ID / Fingerprint"),
              ),
            ),

            const SizedBox(height: 16),

            /// 🧪 FULL DEBUG BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: runFullDebug,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Run Full Biometric Debug"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
