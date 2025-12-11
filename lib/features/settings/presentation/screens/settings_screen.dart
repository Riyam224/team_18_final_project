import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';

import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_header.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/theme_switcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  String _userName = ''; 
  String? _avatarPath;

  late final ISecureStorage _secureStorage;

  @override
  void initState() {
    super.initState();
    _secureStorage = sl<ISecureStorage>();  
    WidgetsBinding.instance.addPostFrameCallback((_) { 
        if (mounted && _userName.isEmpty) {
            setState(() {
                _userName = AppLocalizations.of(context)?.defaultGuestName ?? AppStrings.fallbackGuestName;
            });
        }
    });
    _loadUserProfile(); 
  }


  Future<void> _loadUserProfile() async {
    try {
      // Load user first name
      final firstNameResult = await _secureStorage.read(
        key: StorageKeysConfig.userDisplayName,
      );
      final firstName = firstNameResult.fold(
        (failure) => null,
        (value) => value,
      );

      // Fallback to email username if no stored display name
      final emailResult = await _secureStorage.read(
        key: StorageKeysConfig.userEmail,
      );
      final email = emailResult.fold(
        (failure) => null,
        (value) => value,
      );

      // Load avatar path
      final avatarResult = await _secureStorage.read(
        key: StorageKeysConfig.avatarUrl,
      );
      final avatarPath = avatarResult.fold(
        (failure) => null,
        (value) => value,
      );

      if (!mounted) return;

      setState(() {
        _userName = _extractFirstName(firstName) ??
            _extractFirstName(email) ??
            _userName;
        _avatarPath = avatarPath;
      });
    } catch (e) {
      // Silently handle any errors and keep default values
      debugPrint('${AppStrings.debugErrorLoadingProfile} $e');
    }
  }


  String? _extractFirstName(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    // If value looks like an email, use the part before @
    final emailSplit = trimmed.split('@');
    final base = emailSplit.first;

    final parts = base.split(RegExp(r'\s+'));
    final first = parts.first;
    if (first.isEmpty) return null;
    return first;
  }





List<Map<String, String>> getAvailableLanguages(BuildContext context) {
  return [
    {
      'name': AppLocalizations.of(context)?.languageEnglish ?? AppStrings.fallbackLocalization, 
      'code': 'en'
    },
    {
      'name': AppLocalizations.of(context)?.languageArabic ?? AppStrings.fallbackLocalization,  
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
            AppLocalizations.of(context)?.chooseLanguage ?? AppStrings.fallbackLocalization,
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
                    lang['name'] ?? AppStrings.fallbackLanguageName,
                    style: theme.textTheme.headlineMedium,
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color:
                              isDark ? AppColors.textWhite : AppColors.primary)
                      : null,
                  onTap: () {
                    langCubit.changeLanguage(lang['code'] ?? 'en',);

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              AppLocalizations.of(context)?.languageSetSuccess(
                                  lang['name'] ?? AppStrings.fallbackLanguageName
                              ) ?? AppStrings.fallbackLocalization, 
                          ),
                          ),
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
                AppLocalizations.of(context)?.cancelButton ?? AppStrings.fallbackLocalization,
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
          title: Text(AppLocalizations.of(context)?.settingsTitle ?? AppStrings.fallbackLocalization,
              style: theme.textTheme.headlineLarge),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SettingsHeader(
                userName: _userName, 
                avatarPath: _avatarPath,
              ),
              Padding(
                padding: AppSpacing.paddingH18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)?.generalSection ?? AppStrings.fallbackLocalization,
                        style: AppTextStyles.titleLargesemiBold
                            .copyWith(color: sectionTitleColor)),
                    SettingsListTile(
                      title: AppLocalizations.of(context)?.myAccountTitle ?? AppStrings.fallbackLocalization,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsAccount,
                      onTap: () {
                        context.pushNamed(AppRoutes.home);
                      },
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    SettingsListTile(
                      title: AppLocalizations.of(context)?.billingPaymentTitle ?? AppStrings.fallbackLocalization,
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
                      title: AppLocalizations.of(context)?.faqSupportTitle ?? AppStrings.fallbackLocalization,
                      titleTextStyle: AppTextStyles.titleLargesemiBold
                          .copyWith(color: sectionTitleColor),
                      iconPath: AppAssets.settingsFAQ,
                      showDivider: false,
                      onTap: () {},
                      chevronPath: AppAssets.settingsArrow,
                    ),
                    AppSpacing.gapH12,
                    Text(AppLocalizations.of(context)?.settingsTitle ?? AppStrings.fallbackLocalization,
                        style: AppTextStyles.titleLargesemiBold.copyWith(
                          color:
                              isDark ? AppColors.textWhite : AppColors.primary,
                        )),
                    SettingsListTile(
                      title: AppLocalizations.of(context)?.languageTitle ?? AppStrings.fallbackLocalization,
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