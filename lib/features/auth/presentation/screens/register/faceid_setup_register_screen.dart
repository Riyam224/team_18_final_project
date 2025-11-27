import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/local_auth_service.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_state.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';

class FaceIDSetupRegisterScreen extends StatelessWidget {
  const FaceIDSetupRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BiometricSetupCubit>(),
      child: const _FaceIDSetupContent(),
    );
  }
}

class _FaceIDSetupContent extends StatefulWidget {
  const _FaceIDSetupContent();

  @override
  State<_FaceIDSetupContent> createState() => _FaceIDSetupContentState();
}

class _FaceIDSetupContentState extends State<_FaceIDSetupContent> {
  Future<void> _setupFaceId() async {
    try {
      // Update activity timestamp BEFORE authentication to prevent app lock during Face ID
      await AppLockService.updateActivity();

      final authenticated = await LocalAuthService.authenticate();

      if (authenticated && mounted) {
        context.read<BiometricSetupCubit>().saveBiometric('faceid');
      } else if (mounted) {
        _showErrorSnackBar('Face ID authentication failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: BlocConsumer<BiometricSetupCubit, BiometricSetupState>(
            listener: (context, state) {
              if (state is BiometricSetupSuccess) {
                // Navigate to success screen instead of home
                context.pushReplacement(AppRoutes.faceIdSuccessRegister);
              } else if (state is BiometricSetupError) {
                _showErrorSnackBar(state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is BiometricSetupSaving;

              return Column(
                children: [
                  AppSpacing.vertical(88),

                  /// ---------- HEADER ----------
                  Text(
                    AppStrings.setYourFaceID,
                    style: AppTextStyles.authBiometricTitle.copyWith(
                      fontSize: 26.sp,
                      color: isDark ? AppColors.textWhite : AppColors.primary,
                    ),
                  ),

                  AppSpacing.vertical(33),

                  SizedBox(
                    width: AppSizing.w300,
                    child: Text(
                      AppStrings.addFaceIDSecure,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.authBiometricDescription.copyWith(
                        fontSize: 18.sp,
                        color: isDark ? AppColors.textWhiteSoft2 : AppColors.textGray,
                      ),
                    ),
                  ),

                  AppSpacing.vSpace50,

                  /// ---------- FACE ID ICON BOX ----------
                  Container(
                    width: AppSizing.faceIDIconContainerSize,
                    height: AppSizing.faceIDIconContainerSize,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.textDark : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      isDark ? AppAssets.faceIDwhitebig : AppAssets.faceIDdarkbig,
                      width: AppSizing.biometricIconMedium,
                    ),
                  ),

                  AppSpacing.vSpace20,

                  Text(
                    AppStrings.faceID,
                    style: AppTextStyles.authBiometricLabel.copyWith(
                      fontSize: 18.sp,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),

                  if (isLoading) ...[
                    AppSpacing.vSpace20,
                    const CircularProgressIndicator(),
                  ],

                  AppSpacing.vertical(145),

                  /// ---------- BUTTONS ----------
                  Padding(
                    padding: AppSpacing.paddingH16,
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: AppStrings.skipFingerprint,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // Update activity timestamp to prevent app lock
                                    await AppLockService.updateActivity();
                                    if (context.mounted) {
                                      context.go(AppRoutes.home);
                                    }
                                  },
                            borderColor: isDark ? Colors.white : AppColors.primary,
                            textColor: isDark ? Colors.white : AppColors.primary,
                          ),
                        ),
                        AppSpacing.hSpace20,
                        Expanded(
                          child: AuthSubmitButton(
                            text: AppStrings.continueButton,
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (state is BiometricSetupSuccess) {
                                      // Navigate to success screen
                                      context.pushReplacement(AppRoutes.faceIdSuccessRegister);
                                    } else {
                                      _setupFaceId();
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vSpace40,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
