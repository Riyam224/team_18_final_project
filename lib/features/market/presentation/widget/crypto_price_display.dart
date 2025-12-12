import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:intl/intl.dart'; 

class CryptoPriceDisplay extends StatelessWidget {
  final double currentPrice;
  final double changePercentage;
  
  const CryptoPriceDisplay({
    super.key,
    required this.currentPrice,  
    required this.changePercentage, 
  });

  String _formatPrice(double price) {
    return NumberFormat.currency(symbol: '\$').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatPrice(currentPrice),
              style: TextStyle(
                color: isDark ? AppColors.textWhite : AppColors.primary,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(AppStrings.btc,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: AppColors.gray2, fontSize: 14.sp)),
          ],
        ),
        _investmentGrowthButton(context, changePercentage)
      ],
    );
  }

  Widget _investmentGrowthButton(BuildContext context, double change) {
    final theme = Theme.of(context);

    final bool isPositive = change >= 0;
    final buttonColor = isPositive ? AppColors.priceUp : AppColors.alertRed;
    final textColor = Colors.white;
    final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16.sp,
              color: textColor),
          AppSpacing.horizontal(4),
          Text('${change.abs().toStringAsFixed(1)}%',
              style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ],
      ),
    );
  }
}