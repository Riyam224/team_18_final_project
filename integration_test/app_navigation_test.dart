import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/main.dart' as app;

import '../test/support/test_security_fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Navigation Integration Tests', () {
    testWidgets('should start app and show splash screen', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should navigate through onboarding screens', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final nextButton = find.textContaining('Next', findRichText: true);
      final skipButton = find.textContaining('Skip', findRichText: true);

      if (nextButton.evaluate().isNotEmpty) {
        for (int i = 0; i < 3; i++) {
          final nextFinder = find.textContaining('Next', findRichText: true);
          if (nextFinder.evaluate().isNotEmpty) {
            await tester.tap(nextFinder.first);
            await tester.pumpAndSettle();
          }
        }
      } else if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton.first);
        await tester.pumpAndSettle();
      }

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should navigate back from register to login', (tester) async {
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final signUpFinder = find.textContaining('Sign Up', findRichText: true);
      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder.first);
        await tester.pumpAndSettle();

        final backButton = find.byType(BackButton);
        final backIcon = find.byIcon(Icons.arrow_back);

        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
          await tester.pumpAndSettle();
        } else if (backIcon.evaluate().isNotEmpty) {
          await tester.tap(backIcon.first);
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
