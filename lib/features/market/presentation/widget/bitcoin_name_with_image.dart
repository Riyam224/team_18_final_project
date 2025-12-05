import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BitcoinNameWithImage extends StatelessWidget {
  const BitcoinNameWithImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13).r,
      child: Row(
        children: [
          CircleAvatar(
              radius: 22.r,
              backgroundColor: context.isDark()
                  ? AppColors.darkBackground
                  : AppColors.lightSurface,
              child: AppSvgWidget(
                height: 27.h,
                width: 27.w,
                assetsName: AppAssets.bitcoinIcon,
              )),
          AppSpacing.horizontal(20),
          Text(AppStrings.bitcoin,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20.sp,
                    color: context.isDark()
                        ? AppColors.textWhite
                        : AppColors.primary,
                  )),
        ],
      ),
    );
  }
}
