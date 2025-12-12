import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TradeBottomBar extends StatelessWidget {
  final String coinId;

  const TradeBottomBar({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: BottomActionButton.text(
                textColor: AppColors.alertRed,
                width: double.infinity,
                height: 52.h,
                backgroundColor: isDark ? AppColors.darkBrown : AppColors.lightPink,
                borderRadiusGeometry: BorderRadius.circular(100.r),
                text: context.tr.buttonSell,
                onPressed: () => context.push(RoutePaths.buySellRoute(coinId)),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: BottomActionButton.text(
                textColor: Colors.white,
                width: double.infinity,
                height: 52.h,
                backgroundColor:
                    isDark ? AppColors.lightSurface : AppColors.primary,
                borderRadiusGeometry: BorderRadius.circular(100.r),
                text: context.tr.buttonBuy,
                onPressed: () => context.push(RoutePaths.buySellRoute(coinId)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
