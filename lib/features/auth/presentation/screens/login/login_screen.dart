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
import 'package:team_18_final_project/core/security/session_manager.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_footer.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_header.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthLoginSuccess) {
              // Update activity timestamp to prevent app lock
              await AppLockService.updateActivity();
              await SessionManager.startSession();
              if (context.mounted) {
                // Check if biometric is enabled
                if (state.biometricEnabled && state.biometricType != null) {
                  // User has biometric enabled, navigate to home
                  context.go(AppRoutes.home);
                } else {
                  // Navigate to home
                  context.go(AppRoutes.home);
                }
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.symmetricPadding(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSpacing.vertical(103),

                      /// ------------ HEADER ------------
                      const AuthHeader(
                        title: AppStrings.loginToYourAccount,
                        subtitle: AppStrings.welcomeBack,
                      ),

                      AppSpacing.vertical(100),

                      /// ------------ INPUT FIELDS ------------
                      AuthTextField(
                        controller: _emailController,
                        hint: AppStrings.emailId,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        validator: _validateEmail,
                      ),
                      AppSpacing.vSpace16,

                      AuthTextField(
                        controller: _passwordController,
                        hint: AppStrings.password,
                        icon: Icons.lock_outline,
                        obscure: true,
                        enabled: !isLoading,
                        validator: _validatePassword,
                      ),

                      AppSpacing.vSpace16,

                      /// ------------ REMEMBER ME & FORGET PASSWORD ------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: AppSizing.w20,
                                height: AppSizing.h20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppSizing.radiusXSmall),
                                  ),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.textWhite.withValues(alpha: 0.3)
                                        : AppColors.primary.withValues(alpha: 0.5),
                                    width: AppSizing.borderMedium,
                                  ),
                                ),
                              ),
                              AppSpacing.hSpaceXSmall,
                              Text(
                                AppStrings.rememberMe,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textGrayLight
                                      : AppColors.textGray,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    // TODO: navigate to forget password
                                  },
                            child: Text(
                              AppStrings.forgetPassword,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.textWhite : AppColors.textGray,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      AppSpacing.vSpace30,

                      /// ------------ LOGIN BUTTON ------------
                      AuthSubmitButton(
                        text: isLoading ? 'Logging in...' : AppStrings.loginButton,
                        onPressed: isLoading ? () {} : _handleLogin,
                      ),

                      AppSpacing.vSpace40,

                      /// ------------ OR LOGIN WITH ------------
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? AppColors.textWhite.withValues(alpha: 0.2)
                                  : AppColors.gray4,
                              thickness: AppSizing.dividerThickness,
                            ),
                          ),
                          Padding(
                            padding: AppSpacing.paddingH16,
                            child: Text(
                              AppStrings.orLoginWith,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? AppColors.textWhite.withValues(alpha: 0.2)
                                  : AppColors.gray4,
                              thickness: AppSizing.dividerThickness,
                            ),
                          ),
                        ],
                      ),

                      AppSpacing.vertical(23),

                      /// ------------ BIOMETRIC OPTIONS ------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Fingerprint Icon
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    context.push(AppRoutes.verifyFingerprintLogin);
                                  },
                            child: SizedBox(
                              width: AppSizing.biometricIconSmall,
                              height: AppSizing.biometricIconSmall,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.fingerPrintSmall,
                                    width: AppSizing.biometricIconSmall,
                                    height: AppSizing.biometricIconSmall,
                                    colorFilter: ColorFilter.mode(
                                      isDark ? AppColors.textWhiteSoft : AppColors.gray2,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSpacing.hSpace48,
                          // Face ID Icon
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    context.push(AppRoutes.faceIdScanningLogin);
                                  },
                            child: SizedBox(
                              width: AppSizing.biometricIconSmall,
                              height: AppSizing.biometricIconSmall,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.faceIdSmall,
                                    width: AppSizing.biometricIconSmall,
                                    height: AppSizing.biometricIconSmall,
                                    colorFilter: ColorFilter.mode(
                                      isDark ? AppColors.textWhiteSoft : AppColors.gray2,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      AppSpacing.vertical(15),

                      /// ------------ FOOTER ------------
                      AuthFooter(
                        question: AppStrings.dontHaveAccount,
                        actionText: AppStrings.signUp,
                        onTap: isLoading
                            ? () {}
                            : () {
                                context.go(AppRoutes.register);
                              },
                      ),

                      AppSpacing.vSpace20,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
