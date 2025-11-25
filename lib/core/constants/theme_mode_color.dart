import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

class ThemeModeColor {
  ThemeModeColor._();
  static Color checkColorDarkOrLight(BuildContext context,
      {required Color colorDark, required Color colorLight}) {
    return context.isDark() ? colorDark : colorLight;
  }
}
