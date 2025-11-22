import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary : const Color(0xFF1D3A70),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---- CURRENT BALANCE ----
          Center(
            child: Opacity(
              opacity: 0.70,
              child: Text(
                'Current Balance',
                style: AppTextStyles.titleSmall.copyWith(
                  color: const Color(0xFFF5F8FE),
                  height: 2.02,
                  letterSpacing: 0.44,
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          Center(
            child: Text(
              "\$143,421.20",
              style: theme.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                height: 1.01,
                letterSpacing: 0.99,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          /// ---- WEEKLY PROFIT ROW ----

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Weekly Profit",
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.cardWeekly,
                    fontWeight: FontWeight.w600,
                    height: 2.02,
                    letterSpacing: 0.44,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "2.35% ▲",
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
