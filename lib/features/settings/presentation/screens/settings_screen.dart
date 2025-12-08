import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/app_constants.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
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
  int _autoLockSeconds = AppConstants.defaultAutoLockTimeout;
  bool _loading = true;

  late final ISecureStorage _secureStorage;
  late final IBiometricService _biometricService;
  late final IAppLockService _appLockService;
  late final IAuditLogService _auditLogService;
  late final ISessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _secureStorage = sl<ISecureStorage>();
    _biometricService = sl<IBiometricService>();
    _appLockService = sl<IAppLockService>();
    _auditLogService = sl<IAuditLogService>();
    _sessionManager = sl<ISessionManager>();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load avatar path
    final avatarResult = await _secureStorage.read(key: StorageKeysConfig.avatarUrl);
    final avatar = avatarResult.fold((failure) => null, (value) => value);

    // Load biometric enabled
    final enabledResult = await _secureStorage.read(key: StorageKeysConfig.biometricEnabled);
    final enabled = enabledResult.fold((failure) => false, (value) => value == 'true');

    // Check biometric availability
    final availableResult = await _biometricService.isAvailable();
    final available = availableResult.fold((failure) => false, (value) => value);

    // Get auto-lock timeout
    final timeoutResult = await _appLockService.getAutoLockTimeout();
    final lockDuration = timeoutResult.fold(
      (failure) => Duration(seconds: AppConstants.defaultAutoLockTimeout),
      (duration) => duration,
    );
    final lock = lockDuration.inSeconds;

    if (!mounted) return;
    setState(() {
      _avatarPath = avatar;
      _biometricEnabled = enabled && available;
      _biometricAvailable = available;
      _autoLockSeconds = AppConstants.autoLockTimeoutOptions.contains(lock)
          ? lock
          : AppConstants.autoLockTimeoutOptions.first;
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
        const SnackBar(
            content: Text('Biometrics not available on this device')),
      );
      return;
    }

    await _secureStorage.write(
      key: StorageKeysConfig.biometricEnabled,
      value: value.toString(),
    );

    await _auditLogService.log(
      event: 'Biometric auth ${value ? 'enabled' : 'disabled'}',
      metadata: {'type': 'security'},
    );

    setState(() {
      _biometricEnabled = value;
    });
  }

  Future<void> _updateLockTimeout(int seconds) async {
    await _appLockService.setAutoLockTimeout(Duration(seconds: seconds));

    await _secureStorage.write(
      key: StorageKeysConfig.sessionTimeoutMinutes,
      value: ((seconds / 60).ceil()).toString(),
    );

    await _auditLogService.log(
      event: 'Auto-lock timeout set to ${seconds == 0 ? 'Never' : '${seconds}s'}',
      metadata: {'type': 'security'},
    );

    setState(() {
      _autoLockSeconds = seconds;
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.profile,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.profile),
                          child: const Text('View / edit profile'),
                        ),
                      ],
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
                  subtitle: Text(
                    _autoLockSeconds == 0
                        ? 'Never'
                        : _autoLockSeconds < 60
                            ? 'After ${_autoLockSeconds}s'
                            : 'After ${_autoLockSeconds ~/ 60} minutes',
                  ),
                  trailing: DropdownButton<int>(
                    value: _autoLockSeconds,
                    items: AppConstants.autoLockTimeoutOptions
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                m == 0
                                    ? 'Never'
                                    : m < 60
                                        ? '$m s'
                                        : '${m ~/ 60} min',
                              ),
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

                    await _sessionManager.endSession();

                    await _auditLogService.log(
                      event: 'User logged out from settings',
                      metadata: {'type': 'auth'},
                    );

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
