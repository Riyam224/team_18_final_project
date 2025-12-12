import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        indicatorColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.market);
              break;
            case 2:
              context.go(AppRoutes.portfolio);
              break;
            case 3:
              context.go(AppRoutes.settings);
              break;
            default:
              context.go(AppRoutes.home);
          }
        },
        destinations: [
          _svgItem(
            context: context,
            index: 0,
            selectedIndex: selectedIndex,
            label: context.tr.home,
            icon: AppAssets.home,
            selectedIcon: AppAssets.homeFilled,
          ),
          _svgItem(
            context: context,
            index: 1,
            selectedIndex: selectedIndex,
            label: context.tr.market,
            icon: AppAssets.market,
            selectedIcon: AppAssets.marketFilled,
          ),
          _svgItem(
            context: context,
            index: 2,
            selectedIndex: selectedIndex,
            label: context.tr.portfolio,
            icon: AppAssets.portfolio,
            selectedIcon: AppAssets.portfolioFilled,
          ),
          _svgItem(
            context: context,
            index: 3,
            selectedIndex: selectedIndex,
            label: context.tr.settings,
            icon: AppAssets.settings,
            selectedIcon: AppAssets.settingsFilled,
          ),
        ],
      ),
    );
  }

  NavigationDestination _svgItem({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required String label,
    required String icon,
    required String selectedIcon,
  }) {
    final bool isActive = index == selectedIndex;
    final theme = Theme.of(context);
    final selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? AppColors.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            AppColors.textGrayLight;

    return NavigationDestination(
      icon: SvgPicture.asset(
        isActive ? selectedIcon : icon,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          isActive ? selectedColor : unselectedColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  int _getIndex(BuildContext context) {
    final uri = GoRouterState.of(context).uri.toString();

    if (uri.startsWith(AppRoutes.home)) return 0;
    if (uri.startsWith(AppRoutes.market)) return 1;
    if (uri.startsWith(AppRoutes.portfolio)) return 2;
    if (uri.startsWith(AppRoutes.settings)) return 3;

    return 0;
  }
}
