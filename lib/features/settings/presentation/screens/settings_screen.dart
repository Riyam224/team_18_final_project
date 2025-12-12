import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/utils/theme_controller.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _avatarPath;
  String _displayName = 'Sophia Isabella';
  bool _isLoading = true;
  bool _darkModeEnabled = false;
  late final ISecureStorage _secureStorage;

  @override
  void initState() {
    super.initState();
    _secureStorage = sl<ISecureStorage>();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ThemeController.of(context);
    final isDarkMode = controller.themeMode == ThemeMode.dark;
    if (_darkModeEnabled != isDarkMode) {
      setState(() {
        _darkModeEnabled = isDarkMode;
      });
    }
  }

  Future<void> _loadData() async {
    final avatarResult =
        await _secureStorage.read(key: StorageKeysConfig.avatarUrl);
    final displayNameResult =
        await _secureStorage.read(key: StorageKeysConfig.userDisplayName);
    final firstNameResult =
        await _secureStorage.read(key: StorageKeysConfig.userFirstName);
    final lastNameResult =
        await _secureStorage.read(key: StorageKeysConfig.userLastName);

    final avatar = avatarResult.fold((_) => null, (value) => value);
    final displayName = displayNameResult.fold((_) => null, (value) => value);
    final firstName = firstNameResult.fold((_) => null, (value) => value);
    final lastName = lastNameResult.fold((_) => null, (value) => value);

    final combinedName = [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].where((e) => e.isNotEmpty).join(' ');

    if (!mounted) return;
    setState(() {
      _avatarPath = avatar;
      _displayName = (displayName?.isNotEmpty ?? false)
          ? displayName!
          : (combinedName.isNotEmpty ? combinedName : _displayName);
      _isLoading = false;
    });
  }

  ImageProvider _avatarProvider() {
    if (_avatarPath != null && _avatarPath!.isNotEmpty) {
      if (_avatarPath!.startsWith('assets/')) {
        return AssetImage(_avatarPath!);
      }
      if (_avatarPath!.startsWith('http')) {
        return NetworkImage(_avatarPath!);
      }
      return FileImage(File(_avatarPath!));
    }
    return const AssetImage(AppAssets.profileGirl);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final controller = ThemeController.of(context);
    await controller.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    if (!mounted) return;
    setState(() {
      _darkModeEnabled = value;
    });
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This option will be available soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.primary;
    final subtitleColor = isDark ? AppColors.textGrayLight : AppColors.textGray;
    final dividerColor = isDark ? AppColors.darkCard : AppColors.gray5;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: AppSpacing.paddingHV(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.settings,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.vertical(32),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 52.r,
                            backgroundColor:
                                isDark ? AppColors.darkCard : AppColors.white,
                            backgroundImage: _avatarProvider(),
                          ),
                          AppSpacing.gapH16,
                          Text(
                            _displayName,
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vertical(36),
                    _SectionTitle(
                      title: 'General',
                      color: subtitleColor,
                    ),
                    AppSpacing.gapH12,
                    _SettingsTile(
                      icon: Icons.person,
                      label: AppStrings.myAccount,
                      textColor: textColor,
                      isDark: isDark,
                      onTap: () => context.push(AppRoutes.myAccount),
                    ),
                    Divider(color: dividerColor),
                    _SettingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      label: AppStrings.billingPayment,
                      textColor: textColor,
                      isDark: isDark,
                      onTap: () =>
                          context.push(AppRoutes.billingPaymentSettings),
                    ),
                    Divider(color: dividerColor),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      label: AppStrings.faqSupport,
                      textColor: textColor,
                      isDark: isDark,
                      onTap: () => context.push(AppRoutes.faqSupport),
                    ),
                    AppSpacing.vertical(28),
                    _SectionTitle(
                      title: AppStrings.settings,
                      color: subtitleColor,
                    ),
                    AppSpacing.gapH12,
                    _SettingsTile(
                      icon: Icons.language,
                      label: AppStrings.language,
                      textColor: textColor,
                      isDark: isDark,
                      onTap: _showComingSoon,
                    ),
                    Divider(color: dividerColor),
                    _SettingsTile(
                      icon: Icons.nightlight_round,
                      label: AppStrings.darkMode,
                      textColor: textColor,
                      isDark: isDark,
                      trailing: Switch.adaptive(
                        value: _darkModeEnabled,
                        activeColor: AppColors.primary,
                        onChanged: _toggleDarkMode,
                      ),
                      onTap: () => _toggleDarkMode(!_darkModeEnabled),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.isDark,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14).r,
        child: Row(
          children: [
            Container(
              height: 48.r,
              width: 48.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                icon,
                size: 24.r,
                color: AppColors.textWhite,
              ),
            ),
            AppSpacing.horizontal(16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18.r,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
