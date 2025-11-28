// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/storage/shared_prefs.dart';
import 'package:team_18_final_project/features/onboarding/data/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final bool isLast;
  final OnboardingModel model;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.isLast,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return isLast ? _buildLastPage(context) : _buildNormalPage(context);
  }

  Widget _buildNormalPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH40,
        Center(
          child: Image.asset(
            image,
            height: AppSizing.h360,
            fit: BoxFit.contain,
          ),
        ),
        AppSpacing.gapH40,
        Padding(
          padding: AppSpacing.paddingL28R24,
          child: _buildTitle(model, primary, textColor),
        ),
        AppSpacing.gapH53,
      ],
    );
  }

  Widget _buildLastPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH20,
        Flexible(
          flex: 3,
          child: Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        AppSpacing.gapH20,
        Padding(
          padding: AppSpacing.paddingL28R24,
          child: _buildTitle(model, primary, textColor),
        ),
        AppSpacing.gapH59,
        Padding(
          padding: AppSpacing.paddingH24,
          child: Column(
            children: [
              PrimaryButton(
                text: AppStrings.onboardingLogin,
                color: isDark ? Colors.white : null,
                textColor: isDark ? Colors.black : null,
                onPressed: () async {
                  await AppPrefs.setOnboardingCompleted();
                  context.go(AppRoutes.login);
                },
              ),
              AppSpacing.gapH16,
              SecondaryButton(
                text: AppStrings.onboardingRegister,
                borderColor: isDark ? Colors.white : null,
                textColor: isDark ? Colors.white : null,
                onPressed: () async {
                  await AppPrefs.setOnboardingCompleted();
                  context.go(AppRoutes.register);
                },
              ),
            ],
          ),
        ),
        AppSpacing.gapH58,
      ],
    );
  }

  Widget _buildTitle(OnboardingModel model, Color primary, Color textColor) {
    if (model.isSplitTitle) {
      return RichText(
        text: TextSpan(
          style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
          children: [
            TextSpan(text: model.titlePart1),
            TextSpan(
              text: model.titlePart2,
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      model.titlePart1,
      style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
    );
  }
}
