import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/storage/shared_prefs.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page.dart';
import '../../../../core/common_ui/buttons/circle_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage == onboardingItems.length - 1) return;
    _controller.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _skip() async {
    await AppPrefs.setOnboardingCompleted();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final circleButtonColor =
        isDarkMode ? AppColors.textWhiteSoft : AppColors.primary;
    final circleButtonIconColor =
        isDarkMode ? AppColors.textBlack : AppColors.textWhite;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: AppSpacing.paddingR20T10,
                child: GestureDetector(
                  onTap: _skip,
                  child: Text(
                    AppStrings.onboardingSkip,
                    style: TextStyle(
                        color: primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
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
            if (_currentPage != onboardingItems.length - 1)
              Padding(
                padding: AppSpacing.paddingOnly(
                  left: 24,
                  right: 24,
                  bottom: 53.19,
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
