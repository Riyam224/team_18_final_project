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
  
  Color _getChangeColor(BuildContext context, bool isDark) {
    if (changePercentage > 0) {
      return AppColors.textLightGreen;
    } else if (changePercentage < 0) {
      return AppColors.alertRed;
    }
    return isDark ? AppColors.textWhite : AppColors.textBlack;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final priceColor = _getChangeColor(context, isDark);
    
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
                color: priceColor,  
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(AppStrings.btc,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: AppColors.gray2)),
          ],
        ),
        _investmentGrowthButton(context, changePercentage)
      ],
    );
  }

  Widget _investmentGrowthButton(BuildContext context, double change) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bool isPositive = change >= 0;
    final buttonColor = isPositive ? AppColors.priceUp : AppColors.alertRed;
    final textColor = isDark ? AppColors.darkBackground : AppColors.lightSurface;
    final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    
    return TextButton(
        onPressed: () {},
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.r))),
            backgroundColor: WidgetStateProperty.all(buttonColor), 
            padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 8).r),
            minimumSize: WidgetStateProperty.all<Size>(Size(70.w, 32.h)),
            textStyle: WidgetStateProperty.all<TextStyle>(
                TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Lato'))),
        child: Row(
          children: [
            Icon(icon,    
                fontWeight: FontWeight.w700,
                color: textColor),
            AppSpacing.horizontal(4),
            Text('${change.abs().toStringAsFixed(2)}%',   
                style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 12.sp,
                    color: textColor)),
          ],
        ));
  }
}