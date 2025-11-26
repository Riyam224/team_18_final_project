import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_footer.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_header.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _RegisterScreenContent(),
    );
  }
}

class _RegisterScreenContent extends StatefulWidget {
  const _RegisterScreenContent();

  @override
  State<_RegisterScreenContent> createState() => _RegisterScreenContentState();
}

class _RegisterScreenContentState extends State<_RegisterScreenContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = UserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        biometricEnabled: false,
      );

      context.read<AuthCubit>().register(user);
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthRegisterSuccess) {
              // Show success dialog and navigate to biometric setup
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Registration Successful'),
                  content: const Text('Would you like to set up biometric authentication?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        // Update activity timestamp to prevent app lock
                        await AppLockService.updateActivity();
                        if (context.mounted) {
                          context.go(AppRoutes.home);
                        }
                      },
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.push(AppRoutes.setFingerprintRegister);
                      },
                      child: const Text('Set Up'),
                    ),
                  ],
                ),
              );
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
                      AppSpacing.vertical(84),

                      /// ------------ HEADER ------------
                      const AuthHeader(
                        title: AppStrings.createYourAccount,
                        subtitle: AppStrings.signUpToEnjoy,
                      ),

                      AppSpacing.vertical(56),

                      /// ------------ INPUT FIELDS ------------
                      AuthTextField(
                        controller: _firstNameController,
                        hint: AppStrings.firstName,
                        icon: Icons.person_outline,
                        enabled: !isLoading,
                        validator: (value) => _validateRequired(value, 'First name'),
                      ),
                      AppSpacing.vSpace16,

                      AuthTextField(
                        controller: _lastNameController,
                        hint: AppStrings.lastName,
                        icon: Icons.person_outline,
                        enabled: !isLoading,
                        validator: (value) => _validateRequired(value, 'Last name'),
                      ),
                      AppSpacing.vSpace16,

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

                      AuthTextField(
                        controller: _confirmPasswordController,
                        hint: AppStrings.confirmPassword,
                        icon: Icons.lock_outline,
                        obscure: true,
                        enabled: !isLoading,
                        validator: _validateConfirmPassword,
                      ),
                      AppSpacing.vSpace16,

                      AuthTextField(
                        controller: _phoneController,
                        hint: AppStrings.phoneNumberPlaceholder,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        enabled: !isLoading,
                        validator: _validatePhone,
                      ),

                      AppSpacing.vSpace30,

                      /// ------------ BUTTON ------------
                      AuthSubmitButton(
                        text: isLoading ? 'Creating Account...' : AppStrings.register,
                        onPressed: isLoading ? () {} : _handleRegister,
                      ),

                      AppSpacing.vertical(26),

                      /// ------------ FOOTER ------------
                      AuthFooter(
                        question: AppStrings.alreadyHaveAccount,
                        actionText: AppStrings.login,
                        onTap: isLoading
                            ? () {}
                            : () {
                                context.go(AppRoutes.login);
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
