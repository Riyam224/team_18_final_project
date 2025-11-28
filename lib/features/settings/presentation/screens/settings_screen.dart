import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/security/audit_log_service.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/local_auth_service.dart';
import 'package:team_18_final_project/core/security/secure_storage_service.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _avatarPath;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  int _autoLockMinutes = AppLockService.defaultAutoLockMinutes;
  bool _loading = true;

  final List<int> _lockOptions = const [0, 2, 5, 10, 30];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final avatar = await SecureStorageService.getAvatarPath();
    final enabled = await SecureStorageService.isBiometricEnabled();
    final available = await LocalAuthService.isBiometricAvailable();
    final lock = await AppLockService.getAutoLockTimeout();
    if (!mounted) return;
    setState(() {
      _avatarPath = avatar;
      _biometricEnabled = enabled && available;
      _biometricAvailable = available;
      _autoLockMinutes = lock;
      _loading = false;
    });
  }

  ImageProvider _avatarProvider() {
    if (_avatarPath != null && _avatarPath!.isNotEmpty) {
      if (_avatarPath!.startsWith('http')) {
        return NetworkImage(_avatarPath!);
      }
      return FileImage(File(_avatarPath!));
    }
    return AssetImage(AppAssets.profile);
  }

  Future<void> _toggleBiometric(bool value) async {
    if (!_biometricAvailable && value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrics not available on this device')),
      );
      return;
    }
    await SecureStorageService.setBiometricEnabled(value);
    await AuditLogService.log(
      type: 'security',
      message: 'Biometric auth ${value ? 'enabled' : 'disabled'}',
    );
    setState(() {
      _biometricEnabled = value;
    });
  }

  Future<void> _updateLockTimeout(int minutes) async {
    await AppLockService.setAutoLockTimeout(minutes);
    await AuditLogService.log(
      type: 'security',
      message: 'Auto-lock timeout set to ${minutes == 0 ? 'Never' : '$minutes min'}',
    );
    setState(() {
      _autoLockMinutes = minutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textBlack;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AppSpacing.paddingAll16,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: AppSizing.w32,
                      backgroundImage: _avatarProvider(),
                    ),
                    AppSpacing.gapW12,
                    Text(
                      AppStrings.profile,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH24,
                Text(
                  AppStrings.avatarDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: textColor,
                  ),
                ),
                AppSpacing.gapH24,
                Text(
                  'Security',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SwitchListTile.adaptive(
                  title: const Text('Enable Biometrics'),
                  subtitle: Text(
                    _biometricAvailable
                        ? 'Use Face/Touch ID to unlock'
                        : 'Biometrics not available',
                  ),
                  value: _biometricEnabled,
                  onChanged: _toggleBiometric,
                ),
                ListTile(
                  title: const Text('Auto-lock timeout'),
                  subtitle: Text(_autoLockMinutes == 0
                      ? 'Never'
                      : 'After $_autoLockMinutes minutes'),
                  trailing: DropdownButton<int>(
                    value: _autoLockMinutes,
                    items: _lockOptions
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m == 0 ? 'Never' : '$m min'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _updateLockTimeout(value);
                    },
                  ),
                ),
                AppSpacing.gapH24,
                ElevatedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await SessionManager.logout();
                    await AuditLogService.log(type: 'auth', message: 'User logged out from settings');
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Session ended')),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
    );
  }
}
