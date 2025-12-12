import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/custom_toggle_switch.dart';

class MockToggleCallback extends Mock {
  void call(bool value);
}

void main() {
  late MockToggleCallback mockCallback;

  setUp(() {
    mockCallback = MockToggleCallback();
  });
  
  Widget createWidgetWrapper({required bool initialValue}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            body: CustomToggleSwitch(
              value: initialValue,
              onChanged: mockCallback,
            ),
          ),
        );
      },
    );
  }

  
  testWidgets('Toggle switch displays OFF state when value is false', (tester) async {
    await tester.pumpWidget(createWidgetWrapper(initialValue: false));

    final animatedContainerFinder = find.byType(AnimatedContainer);
    final animatedContainer = tester.widget<AnimatedContainer>(animatedContainerFinder);
    
    expect(animatedContainer.alignment, Alignment.centerLeft);
  });

  
  testWidgets('Toggle switch displays ON state when value is true', (tester) async {
    await tester.pumpWidget(createWidgetWrapper(initialValue: true));

    final animatedContainerFinder = find.byType(AnimatedContainer);
    final animatedContainer = tester.widget<AnimatedContainer>(animatedContainerFinder);
    
    expect(animatedContainer.alignment, Alignment.centerRight);
  });

    testWidgets('Tapping the switch calls onChanged with the opposite value', (tester) async {
    await tester.pumpWidget(createWidgetWrapper(initialValue: false));
    
    await tester.tap(find.byType(CustomToggleSwitch));
    
    verify(() => mockCallback(true)).called(1);
    
    await tester.pumpWidget(createWidgetWrapper(initialValue: true));
    await tester.tap(find.byType(CustomToggleSwitch));
    
    verify(() => mockCallback(false)).called(1);
  });
}