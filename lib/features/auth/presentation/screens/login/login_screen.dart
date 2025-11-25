import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_footer.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_header.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.symmetricPadding(horizontal: 20, vertical: 16),
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
                  controller: email,
                  hint: AppStrings.emailId,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                AppSpacing.vSpace16,

                AuthTextField(
                  controller: password,
                  hint: AppStrings.password,
                  icon: Icons.lock_outline,
                  obscure: true,
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
                            value: false,
                            onChanged: (value) {
                              // TODO: implement remember me
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
                      onTap: () {
                        // TODO: navigate to forget password
                      },
                      child: Text(
                        AppStrings.forgetPassword,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color:
                              isDark ? AppColors.textWhite : AppColors.textGray,
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
                  text: AppStrings.loginButton,
                  onPressed: () {
                    // TODO: add login logic later
                    context.go(AppRoutes.home);
                  },
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
                      onTap: () {
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
                      onTap: () {
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
                  onTap: () {
                    // TODO: navigate to register

                    context.go(AppRoutes.register);
                  },
                ),

                AppSpacing.vSpace20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
