import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';

import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_header.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/theme_switcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  

List<Map<String, String>> getAvailableLanguages(BuildContext context) {
  return [
    {
      'name': AppLocalizations.of(context)!.languageEnglish,  
      'code': 'en'
    },
    {
      'name': AppLocalizations.of(context)!.languageArabic,  
      'code': 'ar'
    },
  ];
}



  void _showLanguageSelectionDialog(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    final langCubit = context.read<LanguageCubit>();

    final currentLanguageCode =
        context.read<LanguageCubit>().state.languageCode;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.chooseLanguage,
            style: theme.textTheme.headlineLarge,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getAvailableLanguages(context).length,
              itemBuilder: (context, index) {
                final lang = getAvailableLanguages(context)[index];
                final isSelected = lang['code'] == currentLanguageCode;

                return ListTile(
                  title: Text(
                    lang['name']!,
                    style: theme.textTheme.headlineMedium,
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color:
                              isDark ? AppColors.textWhite : AppColors.primary)
                      : null,
                  onTap: () {
                    langCubit.changeLanguage(lang['code']!);

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Language set to ${lang['name']}')),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancelButton,
                style: theme.textTheme.titleLarge,
              ),
            )
          ],
        );
      },
    );
  }
// ...

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sectionTitleColor = isDark ? AppColors.textWhite : AppColors.primary;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle,
              style: theme.textTheme.headlineLarge),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsHeader(),
              Padding(
                padding: AppSpacing.paddingH18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.generalSection,
                        style: AppTextStyles.titleLargesemiBold
                            .copyWith(color: sectionTitleColor)),
                    SettingsListTile(
                      title: AppLocalizations.of(context)!.myAccountTitle,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsAccount,
                      onTap: () {
                        context.pushNamed(AppRoutes.home);
                      },
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    SettingsListTile(
                      title: AppLocalizations.of(context)!.billingPaymentTitle,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsBilling,
                      showDivider: true,
                      onTap: () {
                        context.pushNamed(AppRoutes.payment);
                      },
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    SettingsListTile(
                      title: AppLocalizations.of(context)!.faqSupportTitle,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsFAQ,
                      showDivider: false,
                      onTap: () {},
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    AppSpacing.gapH12,
                    Text(AppLocalizations.of(context)!.settingsTitle,
                        style: AppTextStyles.titleLargesemiBold.copyWith(
                          color:
                              isDark ? AppColors.textWhite : AppColors.primary,
                        )),
                    SettingsListTile(
                      title: AppLocalizations.of(context)!.languageTitle,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsLanguage,
                      showDivider: true,
                      onTap: () =>
                          _showLanguageSelectionDialog(context, isDark),
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    const ThemeSwitcherTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}