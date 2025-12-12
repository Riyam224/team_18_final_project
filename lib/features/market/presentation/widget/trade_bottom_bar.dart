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
      height: 62.h,
      color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomActionButton.text(
            textColor: AppColors.alertRed,
            width: 145.w,
            height: 45.h,
            backgroundColor: isDark ? AppColors.darkBrown : AppColors.lightPink,
            borderRadiusGeometry: BorderRadius.circular(31),
            text: context.tr.buttonSell,
            onPressed: () => context.push(RoutePaths.buySellRoute(coinId)),
          ),
          BottomActionButton.text(
            textColor: isDark ? AppColors.darkBackground : AppColors.textWhite,
            width: 145.w,
            height: 45.h,
            backgroundColor:
                isDark ? AppColors.lightSurface : AppColors.primary,
            borderRadiusGeometry: BorderRadius.circular(31),
            text: context.tr.buttonBuy,
            onPressed: () => context.push(RoutePaths.buySellRoute(coinId)),
          )
        ],
      ),
    );
  }
}
