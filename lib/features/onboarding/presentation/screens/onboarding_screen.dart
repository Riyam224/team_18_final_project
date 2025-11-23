import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/storage/shared_prefs.dart';
import '../../../../core/routing/route_names.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page.dart';
import '../../../../core/common_ui/buttons/circle_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// The onboarding screen that introduces new users to the app.
///
/// Displays a series of 4 informational pages with:
/// - A skip button to bypass onboarding
/// - Page indicators showing current position
/// - A next button to navigate between pages (except on the last page)
/// - Login/Register buttons on the final page
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// Controller for managing the PageView navigation
  final PageController _controller = PageController();

  /// Tracks the current page index (0-3)
  int _currentPage = 0;

  /// Navigates to the next onboarding page.
  ///
  /// Does nothing if already on the last page.
  void _next() {
    if (_currentPage == onboardingItems.length - 1) return;
    _controller.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// Skips the onboarding flow and navigates to login.
  ///
  /// Marks onboarding as completed in SharedPreferences so it won't
  /// be shown again on future app launches.
  void _skip() async {
    await AppPrefs.setOnboardingCompleted();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware button colors
    final circleButtonColor =
        isDarkMode ? AppColors.textWhiteSoft : AppColors.primary;
    final circleButtonIconColor =
        isDarkMode ? AppColors.textBlack : AppColors.textWhite;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (top-right)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.w, top: 10.h),
                child: GestureDetector(
                  onTap: _skip,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                        color: primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // Swipeable PageView containing all onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingItems.length,
                onPageChanged: (value) {
                  setState(() => _currentPage = value);
                },
                itemBuilder: (_, index) {
                  final item = onboardingItems[index];
                  return OnboardingPage(
                    image: item.image,
                    title: item.fullTitle,
                    isLast: index == onboardingItems.length - 1,
                    model: item,
                  );
                },
              ),
            ),

            // Bottom navigation (indicators + next button)
            // Hidden on the last page since it has its own buttons
            if (_currentPage != onboardingItems.length - 1)
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: 53.19.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnboardingIndicator(
                      count: onboardingItems.length,
                      currentPage: _currentPage,
                    ),
                    CircleButton(
                      icon: const Icon(Icons.chevron_right),
                      color: circleButtonColor,
                      iconColor: circleButtonIconColor,
                      onPressed: _next,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
