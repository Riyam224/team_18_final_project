import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';

void main() {
  Widget _buildWrapper({
    required Brightness brightness,
    TextDirection direction = TextDirection.ltr,
    Widget? trailing,
    bool hasChevron = true,
    Color? dividerColor,
    VoidCallback? onTap,
    String title = 'Test Title',
    bool showDivider = true,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          brightness: brightness,
          scaffoldBackgroundColor:
              brightness == Brightness.dark ? AppColors.darkBackground : AppColors.lightBackground,
          iconTheme: IconThemeData(
            color: brightness == Brightness.dark ? AppColors.textWhite : AppColors.textGray,
          ),
        ),
        home: Directionality(
          textDirection: direction,
          child: Scaffold(
            body: SettingsListTile(
              title: title,
              iconPath: 'assets/icons/dummy_icon.svg',
              trailing: trailing,
              hasChevron: hasChevron,
              dividerColor: dividerColor,
              onTap: onTap,
              showDivider: showDivider,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('applies dark mode colors and shows divider', (tester) async {
    await tester.pumpWidget(_buildWrapper(
      brightness: Brightness.dark,
      showDivider: true,
    ));
    await tester.pumpAndSettle();

    final container = tester.widget<Container>(find.byType(Container).at(1));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, isNot(AppColors.primary));

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('chevron rotates in RTL layout', (tester) async {
    await tester.pumpWidget(_buildWrapper(
      brightness: Brightness.light,
      direction: TextDirection.rtl,
      hasChevron: true,
    ));
    await tester.pumpAndSettle();

    final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
    expect(rotatedBox.quarterTurns, 2);
  });

  testWidgets('omits chevron when trailing provided', (tester) async {
    await tester.pumpWidget(_buildWrapper(
      brightness: Brightness.light,
      trailing: const Switch(value: true, onChanged: null),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(RotatedBox), findsNothing);
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('invokes onTap callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_buildWrapper(
      brightness: Brightness.light,
      onTap: () => tapped = true,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Test Title'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
