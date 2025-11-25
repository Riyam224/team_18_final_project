import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 103.h),

                /// ------------ HEADER ------------
                const AuthHeader(
                  title: AppStrings.loginToYourAccount,
                  subtitle: AppStrings.welcomeBack,
                ),

                SizedBox(height: 100.h),

                /// ------------ INPUT FIELDS ------------
                AuthTextField(
                  controller: email,
                  hint: AppStrings.emailId,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),

                AuthTextField(
                  controller: password,
                  hint: AppStrings.password,
                  icon: Icons.lock_outline,
                  obscure: true,
                ),

                SizedBox(height: 16.h),

                /// ------------ REMEMBER ME & FORGET PASSWORD ------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Checkbox(
                            value: false,
                            onChanged: (value) {
                              // TODO: implement remember me
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.textWhite.withValues(alpha: 0.3)
                                  : AppColors.primary.withValues(alpha: 0.5),
                              width: 1.5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
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

                SizedBox(height: 30.h),

                /// ------------ LOGIN BUTTON ------------
                AuthSubmitButton(
                  text: AppStrings.loginButton,
                  onPressed: () {
                    // TODO: add login logic later
                  },
                ),

                SizedBox(height: 40.h),

                /// ------------ OR LOGIN WITH ------------
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.textWhite.withValues(alpha: 0.2)
                            : AppColors.gray4,
                        thickness: 1.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                        thickness: 1.h,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 23.h),

                /// ------------ BIOMETRIC OPTIONS ------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fingerprint Icon
                    GestureDetector(
                      onTap: () {
                        // TODO: implement fingerprint authentication
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              AppAssets.fingerPrintSmall,
                              width: 45,
                              height: 45,
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
                    SizedBox(width: 48.w),
                    // Face ID Icon
                    GestureDetector(
                      onTap: () {
                        // TODO: implement face ID authentication
                      },
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              AppAssets.faceIdSmall,
                              width: 45,
                              height: 45,
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

                SizedBox(height: 15.h),

                /// ------------ FOOTER ------------
                AuthFooter(
                  question: AppStrings.dontHaveAccount,
                  actionText: AppStrings.signUp,
                  onTap: () {
                    // TODO: navigate to register

                    context.go(AppRoutes.register);
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
