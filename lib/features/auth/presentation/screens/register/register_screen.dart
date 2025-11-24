import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_footer.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_header.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        // ⬅️ THIS MAKES THE ECLIPSE REUSABLE
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 84.h),

                /// ------------ HEADER ------------
                const AuthHeader(
                  title: AppStrings.createYourAccount,
                  subtitle: AppStrings.signUpToEnjoy,
                ),

                SizedBox(height: 56.h),

                /// ------------ INPUT FIELDS ------------
                AuthTextField(
                  controller: firstName,
                  hint: AppStrings.firstName,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16.h),

                AuthTextField(
                  controller: lastName,
                  hint: AppStrings.lastName,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16.h),

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

                AuthTextField(
                  controller: confirmPassword,
                  hint: AppStrings.confirmPassword,
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                SizedBox(height: 16.h),

                AuthTextField(
                  controller: phone,
                  hint: AppStrings.phoneNumberPlaceholder,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 30.h),

                /// ------------ BUTTON ------------
                AuthSubmitButton(
                  text: AppStrings.register,
                  onPressed: () {
                    // TODO: add register logic later
                  },
                ),

                SizedBox(height: 26.h),

                /// ------------ FOOTER ------------
                AuthFooter(
                  question: AppStrings.alreadyHaveAccount,
                  actionText: AppStrings.login,
                  onTap: () {
                    // TODO: navigate to login

                    context.go(AppRoutes.login);
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
