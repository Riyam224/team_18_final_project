import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

/// Data model representing a single onboarding page.
///
/// Contains all the information needed to display an onboarding screen,
/// including the image asset path and title text. Supports split titles
/// where part of the text is highlighted in a different color.
class OnboardingModel {
  /// Path to the image asset to display on this page
  final String image;

  /// First part of the title text (or the entire title for normal pages)
  final String titlePart1;

  /// Optional second part of the title (used for split-color titles)
  final String? titlePart2;

  /// Whether this title should be rendered with two different colors
  final bool isSplitTitle;

  const OnboardingModel({
    required this.image,
    required this.titlePart1,
    this.titlePart2,
    this.isSplitTitle = false,
  });

  /// Returns the complete title text by combining both parts.
  ///
  /// Used for normal screens (2–4) where the title doesn't need
  /// split coloring but may still use the two-part structure.
  String get fullTitle => isSplitTitle ? "$titlePart1$titlePart2" : titlePart1;
}

/// List of all onboarding pages displayed in sequence.
///
/// Contains 4 pages:
/// 1. Welcome screen with split-colored title
/// 2. Security features overview
/// 3. Market information screen
/// 4. Get started screen with Login/Register buttons
final onboardingItems = [
  // Screen 1: Welcome (with split-colored title)
  OnboardingModel(
    image: AppAssets.onboarding1,
    titlePart1: AppStrings.onboardingTitle1Part1, // "Welcome To "
    titlePart2: AppStrings.onboardingTitle1Part2, // "Crypto X"
    isSplitTitle: true,
  ),

  // Screen 2: Security
  OnboardingModel(
    image: AppAssets.onboarding2,
    titlePart1: AppStrings.onboardingTitleSecurity,
  ),

  // Screen 3: Market
  OnboardingModel(
    image: AppAssets.onboarding3,
    titlePart1: AppStrings.onboardingTitleMarket,
  ),

  // Screen 4: Get Started (final page with action buttons)
  OnboardingModel(
    image: AppAssets.onboarding4,
    titlePart1: AppStrings.onboardingTitleGetStarted,
  ),
];
