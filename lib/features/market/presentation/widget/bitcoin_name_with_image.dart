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
    return Padding(
      padding: const EdgeInsets.only(left: 13).r,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurface,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 27.h,
                    width: 27.w,
                    errorBuilder: (context, error, stackTrace) => AppSvgWidget(
                      height: 27.h,
                      width: 27.w,
                      assetsName: AppAssets.bitcoinIcon, 
                    ),
                  )     
                : AppSvgWidget(
                    height: 27.h,
                    width: 27.w,
                    assetsName: AppAssets.bitcoinIcon,
                  ),
          ),
          AppSpacing.horizontal(20),
          Text(coinName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20.sp,
                    color: isDark ? AppColors.textWhite : AppColors.primary,
                  )),
        ],
      ),
    );
  }
}