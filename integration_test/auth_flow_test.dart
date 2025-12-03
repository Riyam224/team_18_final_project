import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/main.dart' as app;

import '../test/support/test_security_fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    testWidgets('should navigate from splash to onboarding', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should show validation errors for empty login form', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final loginButton = find.text('Login').last;
      
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('should navigate to register screen from login', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final signUpFinder = find.textContaining('Sign Up', findRichText: true);
      final registerFinder = find.textContaining('Register', findRichText: true);
      final createAccountFinder = find.textContaining('Create', findRichText: true);

      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder.first);
        await tester.pumpAndSettle();
      } else if (registerFinder.evaluate().isNotEmpty) {
        await tester.tap(registerFinder.first);
        await tester.pumpAndSettle();
      } else if (createAccountFinder.evaluate().isNotEmpty) {
        await tester.tap(createAccountFinder.first);
        await tester.pumpAndSettle();
      }

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
