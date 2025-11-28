import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/local_auth_service.dart';
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
  State<_FaceIDScanningRegisterContent> createState() => _FaceIDScanningRegisterContentState();
}

class _FaceIDScanningRegisterContentState extends State<_FaceIDScanningRegisterContent> {
  @override
  void initState() {
    super.initState();
    // Automatically trigger Face ID setup when screen loads
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _setupFaceID();
      }
    });
  }

  Future<void> _setupFaceID() async {
    try {
      // Update activity timestamp BEFORE authentication to prevent app lock during Face ID
      await AppLockService.updateActivity();

      // Authenticate with Face ID
      final authenticated = await LocalAuthService.authenticate();

      if (authenticated && mounted) {
        // Save biometric settings
        context.read<BiometricSetupCubit>().saveBiometric('face');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face ID authentication failed'),
            backgroundColor: Colors.red,
          ),
        );
        // Navigate back after failure
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
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
                      style: AppTextStyles.authBiometricScanInstruction.copyWith(
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
                      borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
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
                            color: isDark ? Colors.white : const Color(0xFF1D3A70),
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
                      style: AppTextStyles.authBiometricScanInstruction.copyWith(
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
