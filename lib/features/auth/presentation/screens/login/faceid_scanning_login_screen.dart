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
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_state.dart';

class FaceIDScanningLoginScreen extends StatelessWidget {
  const FaceIDScanningLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BiometricVerifyCubit>(),
      child: const _FaceIDScanningLoginContent(),
    );
  }
}

class _FaceIDScanningLoginContent extends StatefulWidget {
  const _FaceIDScanningLoginContent();

  @override
  State<_FaceIDScanningLoginContent> createState() =>
      _FaceIDScanningLoginContentState();
}

class _FaceIDScanningLoginContentState
    extends State<_FaceIDScanningLoginContent> {
  bool _startedAuth = false;

  @override
  void initState() {
    super.initState();
    _startAuthOnce();
  }

  void _startAuthOnce() {
    if (_startedAuth) return;
    _startedAuth = true;
    // Trigger Face ID exactly once when the screen loads
    Future.microtask(() {
      if (!mounted) return;
      context.read<BiometricVerifyCubit>().verify();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BiometricVerifyCubit, BiometricVerifyState>(
      listener: (context, state) {
        if (state is BiometricVerifySuccess) {
          context.pushReplacement(AppRoutes.faceIdVerifiedSuccessLogin);
        } else if (state is BiometricVerifyFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          // Navigate back to login after failure
          final navigator = Navigator.of(context);
          Future.delayed(TimingConfig.biometricFailureDelay, () {
            if (mounted) {
              navigator.pop();
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is BiometricVerifyLoading;

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
                /// ---------------- FACE ID BOX ----------------
                Positioned(
                  left: AppSizing.faceIDBoxLeft,
                  top: AppSizing.faceIDBoxTopAlt,
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
                        /// ICON
                        SvgPicture.asset(
                          isDark
                              ? AppAssets.faceIDwhitebig
                              : AppAssets.faceIDdarkbig,
                          width: AppSizing.biometricIconLarge,
                          height: AppSizing.biometricIconLarge,
                        ),

                        AppSpacing.vSpace20,

                        /// LABEL
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
                  left: 0,
                  right: 0,
                  bottom: AppSizing.footerTextBottom,
                  child: Padding(
                    padding: AppSpacing.paddingH24,
                    child: Text(
                      isLoading
                          ? AppStrings.faceIDPleaseWaitScanning
                          : AppStrings.authenticationComplete,
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.authBiometricScanInstruction.copyWith(
                        fontSize: 18.sp,
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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
