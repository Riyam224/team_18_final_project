import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/constants/theme_mode_color.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class DetermineColorForButtonState extends StatefulWidget {
  const DetermineColorForButtonState({super.key});

  @override
  State<DetermineColorForButtonState> createState() =>
      _DetermineColorForButtonStateState();
}

class _DetermineColorForButtonStateState
    extends State<DetermineColorForButtonState> {
  late int buttonId;
  @override
  void initState() {
    buttonId = 0;
    super.initState();
  }

  Color getButtonColor({required int index}) {
    return ThemeModeColor.checkColorDarkOrLight(context,
        colorDark: index == buttonId
            ? AppColors.lightSurface
            : AppColors.darkBackground,
        colorLight:
            index == buttonId ? AppColors.primary : AppColors.lightSurface);
  }

  Color getTextColor({required int index}) {
    return index == buttonId
        ? (context.isDark() ? AppColors.textDark : AppColors.textWhite)
        : AppColors.textGray;

    // ThemeModeColor.checkColorDarkOrLight(context,
    //     colorDark: index == buttonId ? AppColors.textDark : AppColors.textGray,
    //     colorLight:
    //         index == buttonId ? AppColors.textWhite : AppColors.textGray);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(AppStrings.items.length, (int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: TextButton(
                onPressed: () {
                  buttonId = index;
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8))),
                  minimumSize: WidgetStateProperty.all(Size(50.w, 32.h)),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(context.isDark()
                          ? index == buttonId
                              ? AppColors.lightSurface
                              : AppColors.darkBackground
                          : index == buttonId
                              ? AppColors.primary
                              : AppColors.lightSurface),
                ),
                child: Text(AppStrings.items[index],
                    style: context.appTheme.textTheme.labelMedium!.copyWith(
                        color: index == buttonId
                            ? (context.isDark()
                                ? AppColors.textDark
                                : AppColors.textWhite)
                            : AppColors.textGray))),
          );
        }));
  }
}
