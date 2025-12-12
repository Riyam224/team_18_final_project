import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BitcoinNameWithImage extends StatelessWidget {
  final String coinName;
  final String imageUrl;

  const BitcoinNameWithImage({
    super.key,
    required this.coinName,  
    required this.imageUrl, 
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          ),
          padding: EdgeInsets.all(8.r),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => AppSvgWidget(
                    assetsName: AppAssets.bitcoinIcon,
                  ),
                )
              : AppSvgWidget(
                  assetsName: AppAssets.bitcoinIcon,
                ),
        ),
        AppSpacing.horizontal(16),
        Text(coinName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                )),
      ],
    );
  }
}