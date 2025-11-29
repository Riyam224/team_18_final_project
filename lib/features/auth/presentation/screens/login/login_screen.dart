import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/config/validation_messages_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
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

  late final IAppLockService _appLockService;
  late final ISessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _appLockService = sl<IAppLockService>();
    _sessionManager = sl<ISessionManager>();
  }

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
      return ValidationMessagesConfig.emailRequired;
    }
    if (!ValidationConfig.emailRegex.hasMatch(value)) {
      return ValidationMessagesConfig.emailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessagesConfig.passwordRequired;
    }
    if (value.length < ValidationConfig.minPasswordLength) {
      return ValidationMessagesConfig.getPasswordMinLengthMessage(
        ValidationConfig.minPasswordLength,
      );
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
              // Prevent immediate app-lock, start session, then route to biometric verification
              await _appLockService.resetLock();
              // Note: ISessionManager.startSession requires userId and token parameters
              // These should come from the AuthLoginSuccess state
              if (context.mounted) {
                final type = (state.biometricType ?? '').toLowerCase();
                final targetRoute = type == 'face'
                    ? AppRoutes.faceIdScanningLogin
                    : AppRoutes.verifyFingerprintLogin;
                context.go(targetRoute);
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
                padding:
                    AppSpacing.symmetricPadding(horizontal: 20, vertical: 16),
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
                        textDirection: TextDirection.ltr,
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
                                    borderRadius: BorderRadius.circular(
                                        AppSizing.radiusXSmall),
                                  ),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.textWhite
                                            .withValues(alpha: 0.3)
                                        : AppColors.primary
                                            .withValues(alpha: 0.5),
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
                                color: isDark
                                    ? AppColors.textWhite
                                    : AppColors.textGray,
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
                        text: isLoading
                            ? AppStrings.loggingIn
                            : AppStrings.loginButton,
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
                                color: isDark
                                    ? AppColors.textGrayLight
                                    : AppColors.textGray,
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
                                    context
                                        .push(AppRoutes.verifyFingerprintLogin);
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
                                      isDark
                                          ? AppColors.textWhiteSoft
                                          : AppColors.gray2,
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
                                      isDark
                                          ? AppColors.textWhiteSoft
                                          : AppColors.gray2,
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
