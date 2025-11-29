import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
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
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class SetFingerprintRegisterScreen extends StatelessWidget {
  const SetFingerprintRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BiometricSetupCubit>(),
      child: const _SetFingerprintRegisterContent(),
    );
  }
}

class _SetFingerprintRegisterContent extends StatefulWidget {
  const _SetFingerprintRegisterContent();

  @override
  State<_SetFingerprintRegisterContent> createState() =>
      _SetFingerprintRegisterContentState();
}

class _SetFingerprintRegisterContentState
    extends State<_SetFingerprintRegisterContent> {
  late final IAppLockService _appLockService;
  late final IBiometricService _biometricService;

  @override
  void initState() {
    super.initState();
    _appLockService = sl<IAppLockService>();
    _biometricService = sl<IBiometricService>();

    // Automatically trigger fingerprint setup when screen loads
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _setupFingerprint();
      }
    });
  }

  Future<void> _setupFingerprint() async {
    try {
      // Update activity timestamp BEFORE authentication to prevent app lock during biometric
      await _appLockService.updateActivity();

      // Authenticate with fingerprint
      final result = await _biometricService.authenticate(
        localizedReason: 'Authenticate to set up fingerprint',
      );

      final authenticated = result.fold(
        (failure) => false,
        (success) => success,
      );

      if (authenticated && mounted) {
        // Save biometric settings
        context.read<BiometricSetupCubit>().saveBiometric(type: 'fingerprint');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.fingerprintAuthFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.errorTemplate(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: BlocConsumer<BiometricSetupCubit, BiometricSetupState>(
          listener: (context, state) {
            if (state is BiometricSetupSuccess) {
              context.pushReplacement(AppRoutes.fingerprintSuccessRegister);
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

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppSpacing.vertical(70),

                    /// Title + Subtitle (reusable)
                    const AuthTitleSection(
                      title: AppStrings.setYourFingerPrint,
                      subtitle: AppStrings.addFingerprintSecure,
                    ),

                    AppSpacing.vSpace70,

                    /// Icon + description
                    const AuthBiometricIllustration(
                      iconPath: AppAssets.fingerPrintBig,
                      description: AppStrings.placeFingerprintInstruction,
                    ),

                    if (isLoading) ...[
                      AppSpacing.vSpace20,
                      const CircularProgressIndicator(),
                    ],

                    AppSpacing.vertical(59),

                    /// Skip Button (secondary)
                    Padding(
                      padding: AppSpacing.paddingH16,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: AppSizing.w160,
                          child: SecondaryButton(
                            text: AppStrings.skipFingerprint,
                            onPressed: isLoading
                                ? () {}
                                : () async {
                                    // Update activity timestamp to prevent app lock
                                    await _appLockService.updateActivity();
                                    if (context.mounted) {
                                      context.go(AppRoutes.home);
                                    }
                                  },
                          ),
                        ),
                      ),
                    ),

                    AppSpacing.vSpace40,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
