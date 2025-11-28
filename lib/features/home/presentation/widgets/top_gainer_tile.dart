// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
      height: AppSizing.h72,
      padding: AppSpacing.paddingH16V14,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
      ),
      child: Row(
        children: [
          /// Coin Icon
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: AppSizing.radius20,
              backgroundColor: AppColors.white,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: AppSizing.radius20,
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.currency_bitcoin,
                size: AppSizing.radius20,
                color: AppColors.primary,
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: AppSizing.radius20,
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.currency_bitcoin,
                size: AppSizing.radius20,
                color: AppColors.primary,
              ),
            ),
          ),

          AppSpacing.gapW12,

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
              AppSpacing.gapH4,
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
              AppSpacing.gapH4,
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
