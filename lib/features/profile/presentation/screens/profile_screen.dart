import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';
import 'package:team_18_final_project/features/profile/presentation/cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()
        ..loadProfile()
        ..startWatching(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _fill(UserProfile? profile) {
    _firstName.text = profile?.firstName ?? '';
    _lastName.text = profile?.lastName ?? '';
    _email.text = profile?.email ?? '';
    _phone.text = profile?.phone ?? '';
  }

  UserProfile _buildProfileFromFields() {
    return UserProfile(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textBlack;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _fill(state.profile);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final loading = state is ProfileLoading || state is ProfileSaving;

          return SingleChildScrollView(
            padding: AppSpacing.symmetricPadding(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage your profile',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 18.sp,
                      color: textColor,
                    ),
                  ),
                  AppSpacing.gapH16,
                  _ProfileField(
                    controller: _firstName,
                    label: 'First name',
                    enabled: !loading,
                    validator: _required,
                  ),
                  AppSpacing.gapH12,
                  _ProfileField(
                    controller: _lastName,
                    label: 'Last name',
                    enabled: !loading,
                    validator: _required,
                  ),
                  AppSpacing.gapH12,
                  _ProfileField(
                    controller: _email,
                    label: 'Email',
                    enabled: false,
                  ),
                  AppSpacing.gapH12,
                  _ProfileField(
                    controller: _phone,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    enabled: !loading,
                  ),
                  AppSpacing.gapH20,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              context.read<ProfileCubit>().updateProfile(
                                    _buildProfileFromFields(),
                                  );
                            },
                      child: Text(loading ? 'Saving...' : 'Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark ? AppColors.gray5 : AppColors.gray1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
