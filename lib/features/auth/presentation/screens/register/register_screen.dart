import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
            padding: AppSpacing.symmetricPadding(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppSpacing.vertical(84),

                /// ------------ HEADER ------------
                const AuthHeader(
                  title: AppStrings.createYourAccount,
                  subtitle: AppStrings.signUpToEnjoy,
                ),

                AppSpacing.vertical(56),

                /// ------------ INPUT FIELDS ------------
                AuthTextField(
                  controller: firstName,
                  hint: AppStrings.firstName,
                  icon: Icons.person_outline,
                ),
                AppSpacing.vSpace16,

                AuthTextField(
                  controller: lastName,
                  hint: AppStrings.lastName,
                  icon: Icons.person_outline,
                ),
                AppSpacing.vSpace16,

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

                AuthTextField(
                  controller: confirmPassword,
                  hint: AppStrings.confirmPassword,
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                AppSpacing.vSpace16,

                AuthTextField(
                  controller: phone,
                  hint: AppStrings.phoneNumberPlaceholder,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                AppSpacing.vSpace30,

                /// ------------ BUTTON ------------
                AuthSubmitButton(
                  text: AppStrings.register,
                  onPressed: () {
                    // TODO: add register logic later
                  },
                ),

                AppSpacing.vertical(26),

                /// ------------ FOOTER ------------
                AuthFooter(
                  question: AppStrings.alreadyHaveAccount,
                  actionText: AppStrings.login,
                  onTap: () {
                    // TODO: navigate to login

                    context.go(AppRoutes.login);
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
