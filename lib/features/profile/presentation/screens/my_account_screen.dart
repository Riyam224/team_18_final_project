import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/auth/data/models/user_profile.dart';
import 'package:team_18_final_project/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:team_18_final_project/features/profile/presentation/widgets/avatar_section.dart';
import 'package:team_18_final_project/features/profile/presentation/widgets/profile_form.dart';
import 'package:team_18_final_project/features/profile/presentation/widgets/security_section.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()
        ..loadUserProfile()
        ..startWatching(),
      child: const _MyAccountView(),
    );
  }
}

class _MyAccountView extends StatefulWidget {
  const _MyAccountView();

  @override
  State<_MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<_MyAccountView> {
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

  void _fill(UserProfile profile) {
    _firstName.text = profile.firstName;
    _lastName.text = profile.lastName;
    _email.text = profile.email;
    _phone.text = profile.phone;
  }

  Future<void> _showAvatarPicker(
      BuildContext context, ProfileCubit cubit) async {
    final options = [
      AppAssets.profileMan,
      AppAssets.profileGirl,
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr.chooseAvatar,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppSpacing.gapH16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options
                  .map(
                    (asset) => GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(asset),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(asset),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  )
                  .toList(),
            ),
            AppSpacing.gapH16,
          ],
        ),
      ),
    );

    if (selected != null && context.mounted) {
      await cubit.updateAvatarAsset(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.myAccount),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.settings),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          _fill(state.profile);
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final loading = state.isLoading;
          final saving = state.isSaving;

          return SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: AppSpacing.symmetricPadding(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: AppSpacing.paddingAll16,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AvatarSection(
                            avatarUrl: state.profile.avatarUrl,
                            displayName: state.profile.displayName,
                            email: state.profile.email,
                            onUpload: () async =>
                                _showAvatarPicker(context, cubit),
                          ),
                        ),
                        AppSpacing.gapH24,
                        Container(
                          padding: AppSpacing.paddingAll16,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SecuritySection(
                            biometricEnabled: state.settings.biometricEnabled,
                            autoLockMinutes:
                                state.settings.autoLockTimeoutMinutes,
                            saving: saving,
                            onBiometricChanged: cubit.updateBiometricSetting,
                            onAutoLockChanged: cubit.updateAutoLock,
                          ),
                        ),
                        AppSpacing.gapH24,
                        Container(
                          padding: AppSpacing.paddingAll16,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ProfileForm(
                            formKey: _formKey,
                            firstName: _firstName,
                            lastName: _lastName,
                            email: _email,
                            phone: _phone,
                            saving: saving,
                            isDark: isDark,
                            onSave: () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              final updated = state.profile.copyWith(
                                firstName: _firstName.text.trim(),
                                lastName: _lastName.text.trim(),
                                phone: _phone.text.trim(),
                              );
                              cubit.saveProfileUpdates(updated);
                            },
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
}
