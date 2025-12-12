import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';

void main() {
  Widget wrap(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  group('PrimaryButton', () {
    testWidgets('should display button with text', (tester) async {
      // Arrange
      const buttonText = 'Click Me';

      // Act
      await tester.pumpWidget(wrap(PrimaryButton(
        text: buttonText,
        onPressed: () {},
      )));

      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(wrap(PrimaryButton(
        text: 'Button',
        onPressed: () {
          pressed = true;
        },
      )));

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      // Assert
      expect(pressed, true);
    });

    testWidgets('should display with custom color', (tester) async {
      // Act
      await tester.pumpWidget(wrap(PrimaryButton(
        text: 'Button',
        onPressed: () {},
        color: Colors.red,
      )));

      // Assert
      expect(find.text('Button'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), Colors.red);
    });

    testWidgets('should apply custom text color', (tester) async {
      // Act
      await tester.pumpWidget(wrap(PrimaryButton(
        text: 'Button',
        onPressed: () {},
        textColor: Colors.black,
      )));

      // Assert
      expect(find.text('Button'), findsOneWidget);
    });
  });
}
