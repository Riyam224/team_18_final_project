import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_state.dart';

class FaceIDScanningRegisterScreen extends StatelessWidget {
  const FaceIDScanningRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BiometricSetupCubit>(),
      child: const _FaceIDScanningRegisterContent(),
    );
  }
}

class _FaceIDScanningRegisterContent extends StatefulWidget {
  const _FaceIDScanningRegisterContent();

  @override
  State<_FaceIDScanningRegisterContent> createState() =>
      _FaceIDScanningRegisterContentState();
}

class _FaceIDScanningRegisterContentState
    extends State<_FaceIDScanningRegisterContent> {
  late final IAppLockService _appLockService;
  late final IBiometricService _biometricService;

  @override
  void initState() {
    super.initState();
    _appLockService = sl<IAppLockService>();
    _biometricService = sl<IBiometricService>();

    // Automatically trigger Face ID setup when screen loads
    Future.delayed(TimingConfig.biometricScanDelay, () {
      if (mounted) {
        _setupFaceID();
      }
    });
  }

  Future<void> _setupFaceID() async {
    try {
      // Update activity timestamp BEFORE authentication to prevent app lock during Face ID
      await _appLockService.updateActivity();

      // Authenticate with Face ID
      final result = await _biometricService.authenticate(
        localizedReason: AppStrings.authenticateSetupFaceID,
      );

      final authenticated = result.fold(
        (failure) => false,
        (success) => success,
      );

      if (authenticated && mounted) {
        // Save biometric settings
                context.read<BiometricSetupCubit>().saveBiometric(type: 'face');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.faceIDAuthFailed),
            backgroundColor: Colors.red,
          ),
        );
        // Navigate back after failure
        Future.delayed(TimingConfig.biometricFailureDelay, () {
          if (mounted) {
            context.pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.errorTemplate(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(TimingConfig.biometricFailureDelay, () {
          if (mounted) {
            context.pop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BiometricSetupCubit, BiometricSetupState>(
      listener: (context, state) {
        if (state is BiometricSetupSuccess) {
          context.pushReplacement(AppRoutes.faceIdSuccessRegister);
        } else if (state is BiometricSetupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BiometricSetupSaving;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0A1128) : const Color(0xFFF5F5F5),
          body: Container(
            width: AppSizing.screenWidth,
            height: AppSizing.screenHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.faceIDbg),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                /// ---------------- TOP TEXT ----------------
                Positioned(
                  left: AppSizing.scanTextLeft,
                  top: AppSizing.scanTextTop,
                  child: SizedBox(
                    width: AppSizing.w283,
                    height: AppSizing.h44,
                    child: Text(
                      AppStrings.placeFaceIDInstruction,
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.authBiometricScanInstruction.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                /// ---------------- FACE ID BOX WITH TEXT INSIDE ----------------
                Positioned(
                  left: AppSizing.faceIDBoxLeft,
                  top: AppSizing.faceIDBoxTop,
                  child: Container(
                    width: AppSizing.faceIDContainerWidth,
                    height: AppSizing.faceIDContainerHeight,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppSizing.radiusMedium),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          isDark
                              ? AppAssets.faceIDwhitebig
                              : AppAssets.faceIDdarkbig,
                          width: AppSizing.biometricIconLarge,
                          height: AppSizing.biometricIconLarge,
                        ),
                        AppSpacing.vSpace20,

                        /// TEXT INSIDE THE BOX
                        Text(
                          AppStrings.faceID,
                          style: AppTextStyles.authBiometricIconLabel.copyWith(
                            fontSize: 20.sp,
                            color:
                                isDark ? Colors.white : const Color(0xFF1D3A70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// ---------------- LOADING INDICATOR ----------------
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),

                /// ---------------- FOOTER TEXT ----------------
                Positioned(
                  left: AppSizing.w20,
                  top: AppSizing.footerTextTop,
                  child: SizedBox(
                    width: AppSizing.w333,
                    height: AppSizing.h46,
                    child: Text(
                      isLoading
                          ? AppStrings.processing
                          : AppStrings.faceIDScanComplete,
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.authBiometricScanInstruction.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
