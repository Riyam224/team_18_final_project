import 'package:flutter/material.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

extension AppThemeData on BuildContext {
  ThemeData get appTheme => Theme.of(this);
}

extension DarkOrLight on BuildContext {
  Brightness get _brightnessTheme => Theme.of(this).brightness;

  bool isDark() => (_brightnessTheme == Brightness.dark);
  bool islight() => (_brightnessTheme == Brightness.light);
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

//  Extension   Localization
extension LocalizationExtension on BuildContext {
    AppLocalizations get tr {
        final localization = AppLocalizations.of(this);
        if (localization == null) {
          throw Exception('AppLocalizations not found');
      }
      return localization;
    }
}
