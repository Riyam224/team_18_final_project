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

  // ===================================================================
  //                          NORMAL PAGES (1–3)
  // ===================================================================
  Widget _buildNormalPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),

        /// IMAGE
        Center(
          child: Image.asset(
            image,
            height: 360.h,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: 40.h),

        /// TITLE
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
  Widget _buildLastPage(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onBackground;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        /// IMAGE
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

        /// TITLE
        Padding(
          padding: EdgeInsets.only(left: 28.w, right: 24.w),
          child: _buildTitle(model, primary, textColor),
        ),

        SizedBox(height: 59.h),

        /// BUTTONS (LOGIN + REGISTER)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              PrimaryButton(
                text: "Login",
                color: isDark ? Colors.white : null,
                textColor: isDark ? Colors.black : null,
                onPressed: () async {
                  await AppPrefs.setOnboardingCompleted();
                  context.go(AppRoutes.login);
                },
              ),
              SizedBox(height: 16.h),
              SecondaryButton(
                text: "Register",
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

        SizedBox(height: 58.h),
      ],
    );
  }

  // ===================================================================
  //                          TITLE BUILDER
  // ===================================================================
  Widget _buildTitle(OnboardingModel model, Color primary, Color textColor) {
    // Titles with 2 colors (only screen 1)
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

    // Titles with normal styling
    return Text(
      model.titlePart1,
      style: AppTextStyles.onboardingTitle.copyWith(color: textColor),
    );
  }
}
