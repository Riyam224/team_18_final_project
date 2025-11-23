// import 'package:team_18_final_project/core/constants/app_assets.dart';
// import 'package:team_18_final_project/core/constants/app_strings.dart';

// class OnboardingModel {
//   final String image;
//   final String titlePart1;
//   final String titlePart2;
//   final bool isSplitTitle;

//   OnboardingModel({
//     required this.image,
//     required this.titlePart1,
//     this.titlePart2 = "",
//     this.isSplitTitle = false,
//   });

//   String get fullTitle => titlePart1 + titlePart2;
// }

// final onboardingItems = [
//   OnboardingModel(
//     image: AppAssets.onboarding1,
//     titlePart1: AppStrings.onboardingTitle1Part1,
//     titlePart2: AppStrings.onboardingTitle1Part2,
//     isSplitTitle: true,
//   ),
//   OnboardingModel(
//     image: AppAssets.onboarding2,
//     titlePart1: AppStrings.onboardingTitleSecurity,
//   ),
//   OnboardingModel(
//     image: AppAssets.onboarding3,
//     titlePart1: AppStrings.onboardingTitleMarket,
//   ),
//   OnboardingModel(
//     image: AppAssets.onboarding4,
//     titlePart1: AppStrings.onboardingTitleGetStarted,
//   ),
// ];

import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class OnboardingModel {
  final String image;
  final String titlePart1;
  final String? titlePart2;
  final bool isSplitTitle;

  const OnboardingModel({
    required this.image,
    required this.titlePart1,
    this.titlePart2,
    this.isSplitTitle = false,
  });

  /// Used for normal screens (2–4)
  String get fullTitle => isSplitTitle ? "$titlePart1$titlePart2" : titlePart1;
}

final onboardingItems = [
  // ---------------- Screen 1 (split title) ----------------
  OnboardingModel(
    image: AppAssets.onboarding1,
    titlePart1: AppStrings.onboardingTitle1Part1, // "Welcome To "
    titlePart2: AppStrings.onboardingTitle1Part2, // "Crypto X"
    isSplitTitle: true,
  ),

  // ---------------- Screen 2 ----------------
  OnboardingModel(
    image: AppAssets.onboarding2,
    titlePart1: AppStrings.onboardingTitleSecurity,
  ),

  // ---------------- Screen 3 ----------------
  OnboardingModel(
    image: AppAssets.onboarding3,
    titlePart1: AppStrings.onboardingTitleMarket,
  ),

  // ---------------- Screen 4 ----------------
  OnboardingModel(
    image: AppAssets.onboarding4,
    titlePart1: AppStrings.onboardingTitleGetStarted,
  ),
];
