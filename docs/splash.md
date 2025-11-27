# Splash Feature Documentation

## Overview

The splash feature provides the initial loading screen displayed when the application launches. It creates a smooth, branded entry point with animations and handles navigation based on the user's onboarding status.

## Architecture

The splash feature follows a clean architecture pattern with separation of concerns:

```
lib/features/splash/
├── presentation/
│   ├── screens/
│   │   └── splash_screen.dart      # Main splash screen
│   └── widgets/
│       └── splash_icon.dart        # Theme-aware logo widget
└── README.md                       # This documentation
```

## Components

### 1. SplashScreen

**Location:** `lib/features/splash/presentation/screens/splash_screen.dart`

**Purpose:** The main entry point screen that displays when the app launches.

**Key Features:**
- Animated fade-in effect for the logo
- Background image display
- Automatic navigation after 2-second delay
- Checks onboarding completion status
- Theme-aware (supports light/dark mode)

**Flow:**
```
1. App launches
2. SplashScreen displays
3. Logo fades in (800ms animation)
4. Wait 2 seconds total
5. Check if onboarding is completed
6. Navigate to:
   - Home Screen (if onboarding completed)
   - Onboarding Screen (if not completed)
```

**Technical Details:**
- Uses `AnimationController` with `SingleTickerProviderStateMixin`
- Implements `FadeTransition` for smooth logo appearance
- Uses `AppPrefs.isOnboardingCompleted()` to check user status
- Implements proper mounted check before navigation

**Code Example:**
```dart
// Navigation logic
Future<void> _navigate() async {
  await Future.delayed(const Duration(milliseconds: 2000));
  final completed = await AppPrefs.isOnboardingCompleted();

  if (!mounted) return; // Safety check

  if (completed) {
    context.go(AppRoutes.home);
  } else {
    context.go(AppRoutes.onboarding);
  }
}
```

### 2. SplashIcon

**Location:** `lib/features/splash/presentation/widgets/splash_icon.dart`

**Purpose:** A reusable widget that displays the app logo with theme awareness.

**Key Features:**
- Automatically switches between light/dark logo variants
- SVG support for scalable graphics
- Responsive sizing using `flutter_screenutil`

**Theme Behavior:**
- **Dark Mode:** Shows light-colored logo (`AppAssets.splashLightIcon`)
- **Light Mode:** Shows dark-colored logo (`AppAssets.splashDarkIcon`)

**Code Example:**
```dart
// Theme-aware icon selection
final isDark = Theme.of(context).brightness == Brightness.dark;

return SvgPicture.asset(
  isDark ? AppAssets.splashLightIcon : AppAssets.splashDarkIcon,
  width: 165.w,
  height: 165.h,
);
```

## Dependencies

The splash feature relies on the following packages:

- `flutter_screenutil` - Responsive sizing
- `flutter_svg` - SVG image support
- `go_router` - Navigation
- Core modules:
  - `core/constants/app_assets.dart` - Asset paths
  - `core/routing/route_names.dart` - Route definitions
  - `core/storage/shared_prefs.dart` - Persistent storage

## Assets Required

The splash feature requires the following assets to be defined in `AppAssets`:

```dart
class AppAssets {
  static const String splashBg = 'assets/images/splash_bg.png';
  static const String splashLightIcon = 'assets/icons/logo_light.svg';
  static const String splashDarkIcon = 'assets/icons/logo_dark.svg';
}
```

## Configuration

### Animation Timing

You can adjust the animation timing by modifying these values in `splash_screen.dart`:

```dart
// Logo fade-in duration
_controller = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 800), // Change this
);

// Total splash screen display time
await Future.delayed(const Duration(milliseconds: 2000)); // Change this
```

### Navigation Routes

The splash screen navigates to routes defined in `AppRoutes`:

```dart
if (completed) {
  context.go(AppRoutes.home);        // Main app screen
} else {
  context.go(AppRoutes.onboarding);  // Onboarding flow
}
```

## Usage

The splash screen is typically set as the initial route in your router configuration:

```dart
GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // ... other routes
  ],
);
```

## State Management

The splash feature uses:
- **Local State:** `StatefulWidget` for animation controller
- **Persistent Storage:** `SharedPreferences` via `AppPrefs` for onboarding status

## Testing Considerations

When testing the splash feature:

1. **Navigation Testing:**
   - Test navigation to home when onboarding is completed
   - Test navigation to onboarding when not completed

2. **Animation Testing:**
   - Verify fade-in animation works correctly
   - Test animation disposal on unmount

3. **Theme Testing:**
   - Verify correct logo variant displays in light mode
   - Verify correct logo variant displays in dark mode

4. **Timing Testing:**
   - Test that navigation occurs after proper delay
   - Test mounted check prevents navigation after disposal

## Common Modifications

### Change Splash Duration

```dart
// In _navigate() method
await Future.delayed(const Duration(milliseconds: 3000)); // 3 seconds
```

### Add Additional Checks

```dart
Future<void> _navigate() async {
  await Future.delayed(const Duration(milliseconds: 2000));

  final completed = await AppPrefs.isOnboardingCompleted();
  final isLoggedIn = await AppPrefs.isUserLoggedIn(); // Additional check

  if (!mounted) return;

  if (!completed) {
    context.go(AppRoutes.onboarding);
  } else if (!isLoggedIn) {
    context.go(AppRoutes.login);
  } else {
    context.go(AppRoutes.home);
  }
}
```

### Customize Animation

```dart
// Change animation curve
_fade = CurvedAnimation(
  parent: _controller,
  curve: Curves.elasticOut, // Different curve
);
```

## Troubleshooting

### Issue: Logo not displaying
**Solution:** Verify assets are properly defined in `pubspec.yaml` and `AppAssets`

### Issue: Navigation not working
**Solution:** Check that routes are properly defined in router configuration

### Issue: Wrong logo variant showing
**Solution:** Verify theme brightness detection and asset paths

### Issue: Animation stuttering
**Solution:** Ensure `SingleTickerProviderStateMixin` is properly implemented

## Best Practices

1. **Always check mounted:** Before navigation, verify widget is still mounted
2. **Dispose controllers:** Properly dispose animation controllers to prevent memory leaks
3. **Theme awareness:** Always support both light and dark themes
4. **Responsive sizing:** Use `flutter_screenutil` for consistent sizing across devices
5. **Error handling:** Consider adding error handling for asset loading

## Future Enhancements

Potential improvements for the splash feature:

- [ ] Add loading progress indicator
- [ ] Implement splash animation variations
- [ ] Add app version display
- [ ] Include connectivity check
- [ ] Add error state handling
- [ ] Implement skeleton loading for smoother transition
- [ ] Add analytics tracking for splash screen duration

## Related Documentation

- [Onboarding Feature Documentation](../onboarding/README.md)
- [Navigation Documentation](../../core/routing/README.md)
- [Theme Documentation](../../core/theme/README.md)
