import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late List<String> items;
  late int buttonId;
  @override
  void initState() {
    items = ['1h', '1d', '1w', '1m', '1y'];
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
    return ThemeModeColor.checkColorDarkOrLight(context,
        colorDark: index == buttonId ? AppColors.textDark : AppColors.textGray,
        colorLight:
            index == buttonId ? AppColors.textWhite : AppColors.textGray);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(items.length, (int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: TextButton(
                onPressed: () {
                  buttonId = index;
                  setState(() {});
                },
                style: context.appTheme.textButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      getButtonColor(index: index),
                    ),
                    minimumSize: WidgetStateProperty.all(Size(50.w, 25.h))),
                child: Text(
                  items[index],
                  style: context.appTheme.textTheme.labelMedium!
                      .copyWith(color: getTextColor(index: index)),
                )),
          );
        }));
  }
}
