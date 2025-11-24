import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/theme_mode_color.dart';
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
              foregroundImage: NetworkImage(
                  "https://th.bing.com/th/id/R.e7d4ef3338708742ea5fb8c896cc42fc?rik=TzLJyNITDANADQ&pid=ImgRaw&r=0"),
              radius: 23,
              backgroundColor: Theme.of(context).colorScheme.surface
              // AppColors.darkBackground,
              ),
          SizedBox(
            width: 20.w,
          ),
          Text(
            'Bitcoin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                color: ThemeModeColor.checkColorDarkOrLight(
                  context,
                  colorDark: AppColors.textWhite,
                  colorLight: AppColors.primary,
                )),
          ),
        ],
        // Text
      ),
    );
  }
}
