# Theming Guide

This document explains how theming is implemented in the Team 18 Fintech App, including color schemes, text styles, and how to use and customize themes.

## Overview

The app supports both **Light Mode** and **Dark Mode** with automatic system detection. Themes are centrally managed and applied throughout the app using Flutter's built-in theming system.

## Architecture

### Theme Files Structure

```
lib/core/utils/
├── app_theme.dart      # Theme entry point and system UI configuration
├── light_theme.dart    # Light theme configuration
├── dark_theme.dart     # Dark theme configuration
└── app_colors.dart     # Color palette constants

lib/core/config/
└── app_text_styles.dart # Typography definitions
```

## Color Palette

Colors are defined in [app_colors.dart](../lib/core/utils/app_colors.dart) and organized by category:

### Primary Brand Colors
```dart
AppColors.primary      // #1D3A70 - Main brand blue
AppColors.secondary    // #F56C2A - Orange accent
```

### Accent Colors
```dart
AppColors.accentBlue   // #4766F9
AppColors.accentBlue2  // #6079FA
AppColors.accentPurple // #8979FF
```

### Light Mode Colors
```dart
AppColors.lightBackground  // #F5F8FE - Main background
AppColors.lightSurface     // #FFFFFF - Card/surface color
AppColors.lightSurface2    // #F8F8F8 - Secondary surface

// Light text colors
AppColors.textBlack           // #152C07
AppColors.textDark            // #000000
AppColors.textGray            // #494D58
AppColors.textGraySecondary   // #8C8C8C
```

### Dark Mode Colors
```dart
AppColors.darkBackground   // #0D0D0D - Main background
AppColors.darkBackground2  // #121212 - Secondary background
AppColors.darkSurface      // #1B1B1B - Surface color
AppColors.darkCard         // #27292A - Card background

// Dark text colors
AppColors.textWhite        // #FFFFFF
AppColors.textWhiteSoft    // #E2E3E4
AppColors.textGrayDark     // #787A8D
AppColors.textGrayLight    // #9CA3AF
```

### Functional Colors
```dart
// Price indicators
AppColors.priceUp      // #00CB6A - Green for positive changes
AppColors.priceDown    // #F26666 - Red for negative changes

// Status colors
AppColors.success      // #69D895
AppColors.warning      // #F7931A
AppColors.error        // #F47E7E
```

### Gray Scale
```dart
AppColors.gray1   // #979797
AppColors.gray2   // #5D5C5D
AppColors.gray3   // #949494
AppColors.gray4   // #BEBEBE
AppColors.gray5   // #DDDDDD
AppColors.gray6   // #F7F7F7
```

## Theme Configuration

### AppTheme Class

The [AppTheme](../lib/core/utils/app_theme.dart) class provides:

```dart
class AppTheme {
  static ThemeData get lightTheme => buildLightTheme();
  static ThemeData get darkTheme => buildDarkTheme();

  static void setSystemUIOverlayStyle(ThemeMode mode);
}
```

### Light Theme

Defined in [light_theme.dart](../lib/core/utils/light_theme.dart):

```dart
ThemeData buildLightTheme() {
  return ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,
    cardColor: AppColors.lightSurface,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      onBackground: AppColors.textBlack,
      onSurface: AppColors.textBlack,
      // ...
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
      // ...
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      foregroundColor: AppColors.textBlack,
    ),
    // ...
  );
}
```

### Dark Theme

Defined in [dark_theme.dart](../lib/core/utils/dark_theme.dart):

```dart
ThemeData buildDarkTheme() {
  return ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,
    cardColor: AppColors.darkCard,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onBackground: AppColors.textWhite,
      onSurface: AppColors.textWhite,
      // ...
    ),
    // ...
  );
}
```

## Usage in App

### Main App Configuration

In [main.dart](../lib/main.dart):

```dart
class FintechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,  // Follows system preference
      // ...
    );
  }
}
```

### System UI Overlay

The app automatically configures system UI (status bar, navigation bar) based on the theme:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  // Configure system UI to match theme
  AppTheme.setSystemUIOverlayStyle(ThemeMode.system);

  runApp(const FintechApp());
}
```

This ensures:
- Transparent status bar
- Correct icon brightness (dark icons on light background, light icons on dark background)
- Matching navigation bar colors

## Using Colors in Widgets

### Accessing Theme Colors

```dart
// Using ColorScheme (recommended)
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
  ),
)

// Using direct color constants
Container(
  color: AppColors.primary,
  child: Text('Hello', style: TextStyle(color: AppColors.textWhite)),
)

// Using themed text styles
Text(
  'Title',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### Background Colors

```dart
// Scaffold background (auto-adapts to theme)
Scaffold(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
)

// Card surfaces
Card(
  color: Theme.of(context).cardColor,
)
```

### Price Indicators

```dart
Text(
  '+5.2%',
  style: TextStyle(
    color: isPositive ? AppColors.priceUp : AppColors.priceDown,
  ),
)
```

## Customizing Themes

### Adding New Colors

1. Add color constants to [app_colors.dart](../lib/core/utils/app_colors.dart):

```dart
class AppColors {
  // ...existing colors
  static const Color customColor = Color(0xFF123456);
}
```

2. Update light and dark themes to use the new color:

```dart
// In light_theme.dart or dark_theme.dart
colorScheme: const ColorScheme.light(
  // ...existing colors
  tertiary: AppColors.customColor,
)
```

### Modifying Existing Themes

To change theme behavior:

1. Edit [light_theme.dart](../lib/core/utils/light_theme.dart) for light mode
2. Edit [dark_theme.dart](../lib/core/utils/dark_theme.dart) for dark mode

### Changing Theme Mode

To switch from system-based to manual theme control:

```dart
// In main.dart
MaterialApp.router(
  themeMode: ThemeMode.light,  // Always light
  // themeMode: ThemeMode.dark,   // Always dark
  // themeMode: ThemeMode.system, // Follow system (default)
)
```

## Text Styling

Text styles are defined in `app_text_styles.dart` and integrated with themes. See the text styles configuration for typography details.

### Available Text Styles

```dart
Theme.of(context).textTheme.headlineLarge
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.bodySmall
Theme.of(context).textTheme.labelLarge
```

## Best Practices

1. **Always use theme colors** instead of hardcoded colors when possible
2. **Use ColorScheme** for dynamic theme adaptation
3. **Test both light and dark modes** during development
4. **Avoid mixing direct colors with theme colors** - pick one approach per component
5. **Use semantic color names** (e.g., `onPrimary` instead of `Colors.white`)
6. **Consider accessibility** - ensure sufficient contrast ratios

## Responsive Design

The app uses `flutter_screenutil` for responsive sizing. The design base size is **375x812** (iPhone X):

```dart
ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  // ...
)
```

Use `.w`, `.h`, `.sp` extensions for responsive dimensions:

```dart
Container(
  width: 100.w,    // Responsive width
  height: 50.h,    // Responsive height
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp),  // Responsive font size
  ),
)
```

## Related Files

- [app_theme.dart](../lib/core/utils/app_theme.dart) - Theme entry point
- [light_theme.dart](../lib/core/utils/light_theme.dart) - Light theme
- [dark_theme.dart](../lib/core/utils/dark_theme.dart) - Dark theme
- [app_colors.dart](../lib/core/utils/app_colors.dart) - Color constants
- [main.dart](../lib/main.dart) - App initialization
