import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/theme_mode_color.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BitcoinTitleDescription extends StatelessWidget {
  const BitcoinTitleDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Bitcoin",
              style: context.appTheme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: ThemeModeColor.checkColorDarkOrLight(context,
                      colorDark: AppColors.textWhite,
                      colorLight: AppColors.primary))),
          SizedBox(
            height: 22.h,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 337.w),
            child: Text(
              textAlign: TextAlign.left,
              "Bitcoin is a decentralized cryptocurrency originally described in a 2008 whitepaper by a person, or group of people, using the alias Satoshi Nakamoto. It was launched soon after, in\nJanuary 2009.",
              style: context.appTheme.textTheme.bodyLarge!.copyWith(
                  color: ThemeModeColor.checkColorDarkOrLight(context,
                      colorDark: AppColors.textWhite,
                      colorLight: AppColors.gray2),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ));
  }
}
