import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TopGainerTile extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String percentage;
  final String imageUrl; // coin logo

  const TopGainerTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentage,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = percentage.contains('-');

    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          /// Coin Icon
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(imageUrl),
          ),

          SizedBox(width: 12.w),

          /// Name + Symbol
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                symbol.toUpperCase(),
                style: theme.textTheme.labelMedium!.copyWith(
                  fontSize: 12.sp,
                  color: theme.textTheme.bodySmall!.color!.withOpacity(0.93),
                  height: 1.2,
                ),
              ),
            ],
          ),

          const Spacer(),

          /// Price + Percentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                price,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                percentage,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isNegative ? AppColors.priceDown : AppColors.priceUp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
