import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
    required this.formKey,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.saving,
    required this.isDark,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;
  final bool saving;
  final bool isDark;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final buttonBackground = isDark ? AppColors.white : AppColors.primary;
    final buttonForeground = isDark ? AppColors.primary : AppColors.white;
    final fieldFill =
        isDark ? AppColors.darkSurface : AppColors.lightInputBackground;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? AppColors.darkCard : AppColors.gray5,
        width: 1,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.manageYourProfile,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.gapH12,
        Form(
          key: formKey,
          child: Column(
            children: [
              _ProfileField(
                controller: firstName,
                label: AppStrings.firstName,
                enabled: !saving,
                validator: _required,
                fillColor: fieldFill,
                border: border,
              ),
              AppSpacing.gapH12,
              _ProfileField(
                controller: lastName,
                label: AppStrings.lastName,
                enabled: !saving,
                validator: _required,
                fillColor: fieldFill,
                border: border,
              ),
              AppSpacing.gapH12,
              _ProfileField(
                controller: email,
                label: AppStrings.emailId,
                enabled: false,
                fillColor: fieldFill,
                border: border,
              ),
              AppSpacing.gapH12,
              _ProfileField(
                controller: phone,
                label: AppStrings.phoneNumberPlaceholder,
                enabled: !saving,
                keyboardType: TextInputType.phone,
                fillColor: fieldFill,
                border: border,
              ),
              AppSpacing.gapH20,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground,
                    disabledBackgroundColor:
                        buttonBackground.withValues(alpha: 0.6),
                    disabledForegroundColor:
                        buttonForeground.withValues(alpha: 0.7),
                  ),
                  child: Text(
                      saving ? AppStrings.processing : AppStrings.saveChanges),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.requiredField;
    return null;
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.fillColor,
    required this.border,
    this.keyboardType,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;
  final Color fillColor;
  final InputBorder border;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: border.borderSide.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
