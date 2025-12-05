import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/custom_toggle_switch.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class ThemeSwitcherTile extends StatelessWidget {
  final Key? widgetKey;
  const ThemeSwitcherTile({Key? key}) : widgetKey = key, super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cubit = context.read<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final bool isDarkModeActive = state.themeMode == ThemeMode.dark;

        final Color iconColor =
            isDarkModeActive ? theme.primaryColor : theme.primaryColor;

        return SettingsListTile(
          key:  widgetKey, 
          title: AppLocalizations.of(context)!.darkModeTitle,
          titleTextStyle: AppTextStyles.titleLargesemiBold.copyWith(
            color: isDarkModeActive ? AppColors.textWhite : AppColors.primary,
          ),
          iconPath: AppAssets.settingsDarkMode,
          iconColor: iconColor,
          trailing: CustomToggleSwitch(
            key: const Key('themeToggleButton'),
            value: isDarkModeActive,
            onChanged: (bool isActive) {
              cubit.toggleTheme(isActive ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          hasChevron: false,
          showDivider: false,
          onTap: () {
            cubit.toggleTheme(
                isDarkModeActive ? ThemeMode.light : ThemeMode.dark);
          },
        );
      },
    );
  }
}
