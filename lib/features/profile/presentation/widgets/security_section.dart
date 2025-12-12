import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({
    super.key,
    required this.biometricEnabled,
    required this.autoLockMinutes,
    required this.saving,
    required this.onBiometricChanged,
    required this.onAutoLockChanged,
  });

  final bool biometricEnabled;
  final int autoLockMinutes;
  final bool saving;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<int> onAutoLockChanged;

  static const _autoLockOptions = [5, 10, 15, 30];

  @override
  Widget build(BuildContext context) {
    final selectedAutoLock = _autoLockOptions.contains(autoLockMinutes)
        ? autoLockMinutes
        : _autoLockOptions.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.security,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.gapH12,
        _SettingTile(
          title: AppStrings.enableBiometrics,
          subtitle: AppStrings.enableBiometricsHint,
          trailing: Switch(
            value: biometricEnabled,
            onChanged: saving ? null : onBiometricChanged,
          ),
        ),
        AppSpacing.gapH12,
        _SettingTile(
          title: AppStrings.autoLockTimeout,
          subtitle: AppStrings.autoLockSubtitle(autoLockMinutes),
          trailing: DropdownButton<int>(
            value: selectedAutoLock,
            items: _autoLockOptions
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text('$value ${AppStrings.minutesShort}'),
                  ),
                )
                .toList(),
            onChanged: saving
                ? null
                : (value) => onAutoLockChanged(value ?? selectedAutoLock),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              AppSpacing.gapH4,
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textGray),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
