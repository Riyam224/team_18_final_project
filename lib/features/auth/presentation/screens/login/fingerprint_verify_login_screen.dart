import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_state.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class VerifyFingerprintLoginScreen extends StatelessWidget {
  const VerifyFingerprintLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BiometricVerifyCubit>(),
      child: const _VerifyFingerprintLoginContent(),
    );
  }
}

class _VerifyFingerprintLoginContent extends StatefulWidget {
  const _VerifyFingerprintLoginContent();

  @override
  State<_VerifyFingerprintLoginContent> createState() =>
      _VerifyFingerprintLoginContentState();
}

class _VerifyFingerprintLoginContentState
    extends State<_VerifyFingerprintLoginContent> {
  @override
  void initState() {
    super.initState();
    // Automatically trigger fingerprint verification when screen loads
    Future.delayed(TimingConfig.biometricScanDelay, () {
      if (mounted) {
        context.read<BiometricVerifyCubit>().verify();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: BlocConsumer<BiometricVerifyCubit, BiometricVerifyState>(
          listener: (context, state) {
            if (state is BiometricVerifySuccess) {
              context.pushReplacement(AppRoutes.verifyFingerprintLoginSuccess);
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

            return SafeArea(
              child: Column(
                children: [
                  AppSpacing.vertical(88),

                  /// ---------- TITLE SECTION ----------
                  const AuthTitleSection(
                    title: AppStrings.touchIdVerifyTitle,
                    subtitle: "",
                  ),

                  AppSpacing.vSpace50,

                  /// ---------- FINGERPRINT ILLUSTRATION ----------
                  const AuthBiometricIllustration(
                    iconPath: AppAssets.fingerPrintBig,
                    description: AppStrings.touchIdFooter,
                  ),

                  if (isLoading) ...[
                    AppSpacing.vSpace30,
                    const CircularProgressIndicator(),
                    AppSpacing.vSpace20,
                    const Text(AppStrings.verifyingFingerprint),
                  ],

                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
