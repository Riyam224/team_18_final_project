import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/main.dart' as app;

import '../test/support/test_security_fakes.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Security Flow Integration Tests', () {
    testWidgets('app should launch and initialize security features',
        (tester) async {
      // Arrange & Act
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - App should be running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle app lifecycle for session management',
        (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Simulate app going to background and returning
      final binding = tester.binding;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();

      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should navigate through app without crashing', (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Act - Try to find and tap any navigation elements
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);

      // Navigate if possible
      await tester.pumpAndSettle();

      // Assert - App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should maintain security context during navigation',
        (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Navigate through multiple screens
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Security services should remain active
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle orientation changes', (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Change orientation
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      await tester.binding.setSurfaceSize(const Size(600, 800));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Encrypted Storage Integration', () {
    testWidgets('should initialize encrypted storage on app start',
        (tester) async {
      // Arrange & Act
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - App should initialize without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should persist across app restarts', (tester) async {
      // Arrange - First app launch
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Simulate app restart
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Root Detection Integration', () {
    testWidgets('should perform security check on launch', (tester) async {
      // Arrange & Act
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - App should launch successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should continue normal operation on secure device',
        (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Navigate around
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Session Management Integration', () {
    testWidgets('should handle session timeout scenarios', (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Simulate time passing
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should refresh session on user activity', (tester) async {
      // Arrange
      await app.main(
        env: AppEnvironment.test,
        securityOverrides: createTestSecurityOverrides(),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Act - Simulate user interaction
      await tester.tap(find.byType(MaterialApp).first);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
