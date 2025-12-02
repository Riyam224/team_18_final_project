import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';

Widget _wrapWithScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (_, __) => MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('SecondaryButton', () {
    testWidgets('should display button with text', (tester) async {
      // Arrange
      const buttonText = 'Click Me';

      // Act
      await tester.pumpWidget(_wrapWithScreenUtil(
        SecondaryButton(
          text: buttonText,
          onPressed: () {},
        ),
      ));

      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(_wrapWithScreenUtil(
        SecondaryButton(
          text: 'Button',
          onPressed: () {
            pressed = true;
          },
        ),
      ));

      await tester.tap(find.byType(SecondaryButton));
      await tester.pumpAndSettle();

      // Assert
      expect(pressed, true);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      // Act
      await tester.pumpWidget(_wrapWithScreenUtil(
        const SecondaryButton(
          text: 'Button',
          onPressed: null,
        ),
      ));

      // Assert
      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      expect(button.onPressed, null);
    });
  });
}
