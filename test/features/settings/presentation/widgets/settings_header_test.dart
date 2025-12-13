import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_header.dart';

void main() {
  const userName = 'Test User';

  Widget _buildWrapper(Brightness brightness) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          brightness: brightness,
        ),
        home: const Scaffold(
          body: SettingsHeader(userName: userName),
        ),
      ),
    );
  }

  testWidgets('renders username and avatar with light theme colors',
      (tester) async {
    await tester.pumpWidget(_buildWrapper(Brightness.light));
    await tester.pumpAndSettle();

    expect(find.text(userName), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(userName));
    expect(textWidget.style?.color, AppColors.primary);

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundColor, AppColors.backAvatar);
  });

  testWidgets('renders username and avatar with dark theme colors',
      (tester) async {
    await tester.pumpWidget(_buildWrapper(Brightness.dark));
    await tester.pumpAndSettle();

    final textWidget = tester.widget<Text>(find.text(userName));
    expect(textWidget.style?.color, AppColors.textWhite);

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundColor, AppColors.darkBackAvatar);
  });
}
