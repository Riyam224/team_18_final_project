// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:team_18_final_project/core/config/app_text_styles.dart';
// import 'package:team_18_final_project/features/onboarding/data/models/onboarding_model.dart';
// import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
// import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
// import 'package:team_18_final_project/core/routing/route_names.dart';
// import 'package:team_18_final_project/core/storage/shared_prefs.dart';
// import 'package:go_router/go_router.dart';

// class OnboardingPage extends StatelessWidget {
//   final String image;
//   final String title;
//   final bool isLast;

//   final OnboardingModel model;

//   const OnboardingPage({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.isLast,
//     required this.model,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).colorScheme.primary;
//     final textColor = Theme.of(context).colorScheme.onSurface;

//     if (isLast) {
//       final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 20.h),
//           Flexible(
//             flex: 3,
//             child: Center(
//               child: Image.asset(
//                 image,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Padding(
//             padding: EdgeInsets.only(left: 28.w, right: 24.w),
//             child: _buildTitle(model, primary, textColor),
//           ),
//           SizedBox(height: 59.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Column(
//               children: [
//                 PrimaryButton(
//                   text: "Login",
//                   color: isDarkMode ? Colors.white : null,
//                   textColor: isDarkMode ? Colors.black : null,
//                   onPressed: () async {
//                     await AppPrefs.setOnboardingCompleted();
//                     context.go(AppRoutes.login);
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//                 SecondaryButton(
//                   text: "Register",
//                   borderColor: isDarkMode ? Colors.white : null,
//                   textColor: isDarkMode ? Colors.white : null,
//                   onPressed: () async {
//                     await AppPrefs.setOnboardingCompleted();
//                     context.go(AppRoutes.register);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 58.h),
//         ],
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 40.h),
//         Center(
//           child: Image.asset(
//             image,
//             height: 360.h,
//             fit: BoxFit.contain,
//           ),
//         ),
//         SizedBox(height: 40.h),
//         Padding(
//           padding: EdgeInsets.only(left: 28.w, right: 24.w),
//           child: _buildTitle(model, primary, textColor),
//         ),
//         SizedBox(height: 53.19.h),
//       ],
//     );
//   }

//   Widget _buildTitle(OnboardingModel model, Color primary, Color textColor) {
//     if (model.isSplitTitle) {
//       return RichText(
//         text: TextSpan(
//           style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
//           children: [
//             TextSpan(text: model.titlePart1),
//             TextSpan(
//               text: model.titlePart2,
//               style: TextStyle(color: primary, fontWeight: FontWeight.w900),
//             ),
//           ],
//         ),
//       );
//     }

//     return Text(
//       model.titlePart1,
//       style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/storage/shared_prefs.dart';
import 'package:team_18_final_project/features/onboarding/data/models/onboarding_model.dart';

/// A single page in the onboarding flow.
///
/// Displays different layouts depending on whether it's the last page:
/// - Normal pages (1-3): Show image and title with standard spacing
/// - Last page (4): Shows image, title, and Login/Register buttons
///
/// Supports split-color titles for emphasis (used in first page).
class OnboardingPage extends StatelessWidget {
  /// Path to the image asset for this page
  final String image;

  /// The title text to display
  final String title;

  /// Whether this is the last page in the onboarding sequence
  final bool isLast;

  /// The data model containing additional styling information
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

  // ===================================================================
  //                          NORMAL PAGES (1–3)
  // ===================================================================
  /// Builds the layout for standard onboarding pages (pages 1-3).
  ///
  /// Shows a centered image at the top followed by the title text.
  Widget _buildNormalPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),

        // Onboarding illustration image
        Center(
          child: Image.asset(
            image,
            height: 360.h,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: 40.h),

        // Title text (may be split-colored on first page)
        Padding(
          padding: EdgeInsets.only(left: 28.w, right: 24.w),
          child: _buildTitle(model, primary, textColor),
        ),

        SizedBox(height: 53.19.h),
      ],
    );
  }

  // ===================================================================
  //                          LAST PAGE (4)
  // ===================================================================
  /// Builds the layout for the final onboarding page (page 4).
  ///
  /// Includes image, title, and Login/Register action buttons.
  /// Uses a flexible layout to accommodate the buttons at the bottom.
  Widget _buildLastPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onBackground;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        // Flexible image that takes available space
        Flexible(
          flex: 3,
          child: Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // Title text
        Padding(
          padding: EdgeInsets.only(left: 28.w, right: 24.w),
          child: _buildTitle(model, primary, textColor),
        ),

        SizedBox(height: 59.h),

        // Action buttons: Login and Register
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Primary "Login" button (theme-aware styling)
              PrimaryButton(
                text: "Login",
                color: isDark ? Colors.white : null,
                textColor: isDark ? Colors.black : null,
                onPressed: () async {
                  // Mark onboarding as complete and navigate to login
                  await AppPrefs.setOnboardingCompleted();
                  context.go(AppRoutes.login);
                },
              ),
              SizedBox(height: 16.h),
              // Secondary "Register" button (theme-aware styling)
              SecondaryButton(
                text: "Register",
                borderColor: isDark ? Colors.white : null,
                textColor: isDark ? Colors.white : null,
                onPressed: () async {
                  // Mark onboarding as complete and navigate to registration
                  await AppPrefs.setOnboardingCompleted();
                  context.go(AppRoutes.register);
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 58.h),
      ],
    );
  }

  // ===================================================================
  //                          TITLE BUILDER
  // ===================================================================
  /// Builds the title widget based on the onboarding model.
  ///
  /// For pages with split titles (like page 1: "Welcome To Crypto X"),
  /// creates a RichText with the second part in a different color.
  /// For normal titles, returns a simple Text widget.
  Widget _buildTitle(OnboardingModel model, Color primary, Color textColor) {
    // Split-colored title (used for page 1)
    if (model.isSplitTitle) {
      return RichText(
        text: TextSpan(
          style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
          children: [
            TextSpan(text: model.titlePart1), // e.g., "Welcome To "
            TextSpan(
              text: model.titlePart2, // e.g., "Crypto X"
              style: TextStyle(
                color: primary, // Highlighted in primary color
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
    }

    // Standard single-color title (pages 2-4)
    return Text(
      model.titlePart1,
      style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
    );
  }
}
