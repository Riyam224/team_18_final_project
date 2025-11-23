# Onboarding Feature Documentation

## Overview

The onboarding feature provides a smooth introduction to the app for first-time users. It presents a series of informational screens that showcase key features and benefits before allowing users to proceed to login or registration.

## Architecture

The onboarding feature follows a clean architecture pattern with clear separation between data and presentation layers:

```
lib/features/onboarding/
├── data/
│   └── models/
│       └── onboarding_model.dart   # Data model and content
├── presentation/
│   ├── screens/
│   │   └── onboarding_screen.dart  # Main screen controller
│   └── widgets/
│       ├── onboarding_indicator.dart  # Page indicators
│       └── onboarding_page.dart       # Individual page layout
└── README.md                          # This documentation
```

## User Flow

```
1. User launches app for first time
2. Splash screen navigates to onboarding
3. User sees 4 onboarding pages:
   - Page 1: Welcome to Crypto X (split-colored title)
   - Page 2: Security features
   - Page 3: Market information
   - Page 4: Get started (with action buttons)
4. User can:
   - Swipe through pages
   - Tap "Skip" to go to login
   - Tap "Next" button to advance
   - Tap "Login" or "Register" on final page
5. Onboarding completion is saved to SharedPreferences
6. User won't see onboarding again on future launches
```

## Components

### 1. OnboardingScreen

**Location:** `lib/features/onboarding/presentation/screens/onboarding_screen.dart`

**Purpose:** Main controller that manages the onboarding flow and navigation.

**Key Features:**
- Manages 4-page PageView
- Skip functionality
- Next button navigation
- Page state tracking
- Theme-aware styling

**State Management:**
```dart
final PageController _controller = PageController();
int _currentPage = 0;  // Tracks current page (0-3)
```

**Navigation Methods:**

```dart
// Navigate to next page
void _next() {
  if (_currentPage == onboardingItems.length - 1) return;
  _controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.ease
  );
}

// Skip onboarding and go to login
void _skip() async {
  await AppPrefs.setOnboardingCompleted();
  if (mounted) context.go(AppRoutes.login);
}
```

**UI Structure:**
```
Scaffold
└── SafeArea
    └── Column
        ├── Skip Button (top-right)
        ├── PageView (expandable)
        │   └── OnboardingPage widgets
        └── Bottom Navigation (pages 1-3 only)
            ├── OnboardingIndicator
            └── Next CircleButton
```

### 2. OnboardingPage

**Location:** `lib/features/onboarding/presentation/widgets/onboarding_page.dart`

**Purpose:** Displays the content for each individual onboarding page.

**Key Features:**
- Different layouts for normal vs final page
- Split-color title support
- Theme-aware styling
- Responsive design

**Page Types:**

#### Normal Pages (1-3)
```dart
Widget _buildNormalPage(BuildContext context) {
  return Column(
    children: [
      // Centered illustration image (360h)
      // Title text with optional split-coloring
      // Spacer
    ],
  );
}
```

#### Last Page (4)
```dart
Widget _buildLastPage(BuildContext context) {
  return Column(
    children: [
      // Flexible illustration image
      // Title text
      // Login button (Primary)
      // Register button (Secondary)
    ],
  );
}
```

**Title Rendering:**

The title builder supports two modes:

1. **Split Title (Page 1):**
   - "Welcome To " (normal color)
   - "Crypto X" (primary color, bold)

2. **Normal Title (Pages 2-4):**
   - Single-color title text

```dart
Widget _buildTitle(OnboardingModel model, Color primary, Color textColor) {
  if (model.isSplitTitle) {
    return RichText(...);  // Two-part styled text
  }
  return Text(...);  // Simple text
}
```

### 3. OnboardingIndicator

**Location:** `lib/features/onboarding/presentation/widgets/onboarding_indicator.dart`

**Purpose:** Visual indicator showing current page position.

**Key Features:**
- Animated transitions between states
- Theme-aware colors
- Active/inactive state distinction

**Visual Behavior:**
- **Active indicator:** 24w x 6h (wider)
- **Inactive indicators:** 12w x 6h (narrower)
- **Animation:** 250ms smooth transition
- **Spacing:** 8w between indicators

**Theme Colors:**
```dart
// Light mode
active: AppColors.primary
inactive: AppColors.gray4

// Dark mode
active: AppColors.textWhiteSoft
inactive: AppColors.gray2
```

### 4. OnboardingModel

**Location:** `lib/features/onboarding/data/models/onboarding_model.dart`

**Purpose:** Data structure representing a single onboarding page.

**Properties:**
```dart
class OnboardingModel {
  final String image;           // Asset path for illustration
  final String titlePart1;      // First part or entire title
  final String? titlePart2;     // Second part (for split titles)
  final bool isSplitTitle;      // Whether to use split coloring

  String get fullTitle;         // Combined title text
}
```

**Content Definition:**
```dart
final onboardingItems = [
  OnboardingModel(
    image: AppAssets.onboarding1,
    titlePart1: AppStrings.onboardingTitle1Part1,  // "Welcome To "
    titlePart2: AppStrings.onboardingTitle1Part2,  // "Crypto X"
    isSplitTitle: true,
  ),
  // ... more pages
];
```

## Content Management

### Adding a New Onboarding Page

1. **Add assets:**
   ```dart
   // In app_assets.dart
   static const String onboarding5 = 'assets/images/onboarding_5.png';
   ```

2. **Add strings:**
   ```dart
   // In app_strings.dart
   static const String onboardingTitle5 = 'Your New Feature';
   ```

3. **Add model:**
   ```dart
   // In onboarding_model.dart
   OnboardingModel(
     image: AppAssets.onboarding5,
     titlePart1: AppStrings.onboardingTitle5,
   ),
   ```

### Modifying Existing Content

To change page content, update the constants in `AppStrings`:

```dart
class AppStrings {
  // Onboarding titles
  static const String onboardingTitle1Part1 = 'Welcome To ';
  static const String onboardingTitle1Part2 = 'Crypto X';
  static const String onboardingTitleSecurity = 'Secure Your Assets';
  static const String onboardingTitleMarket = 'Track Market Trends';
  static const String onboardingTitleGetStarted = 'Ready to Start?';
}
```

## Theme Support

The onboarding feature fully supports light and dark themes:

### Button Styling (Last Page)

**Light Mode:**
- Login button: Primary color background, white text
- Register button: Transparent, primary border, primary text

**Dark Mode:**
- Login button: White background, black text
- Register button: Transparent, white border, white text

### Color Adaptation

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

// Button colors
final buttonColor = isDark ? Colors.white : null;
final buttonTextColor = isDark ? Colors.black : null;
final buttonBorderColor = isDark ? Colors.white : null;

// Indicator colors
final activeColor = isDark ? AppColors.textWhiteSoft : AppColors.primary;
final inactiveColor = isDark ? AppColors.gray2 : AppColors.gray4;
```

## Dependencies

Required packages:
- `flutter_screenutil` - Responsive sizing
- `go_router` - Navigation
- Core modules:
  - `core/constants/app_assets.dart` - Asset paths
  - `core/constants/app_strings.dart` - Text content
  - `core/routing/route_names.dart` - Route definitions
  - `core/storage/shared_prefs.dart` - Persistent storage
  - `core/common_ui/buttons/` - Button components
  - `core/config/app_text_styles.dart` - Typography

## Assets Required

### Images
```yaml
assets:
  - assets/images/onboarding_1.png
  - assets/images/onboarding_2.png
  - assets/images/onboarding_3.png
  - assets/images/onboarding_4.png
```

Recommended specifications:
- Format: PNG with transparency
- Size: 360h (height), width varies
- Resolution: @2x and @3x variants

## State Persistence

The onboarding completion status is stored in SharedPreferences:

```dart
// Save completion status
await AppPrefs.setOnboardingCompleted();

// Check completion status
final completed = await AppPrefs.isOnboardingCompleted();
```

### Implementation (AppPrefs)

```dart
class AppPrefs {
  static const String _onboardingKey = 'onboarding_completed';

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
```

## Navigation Routes

The onboarding screen navigates to:

```dart
// Skip or complete onboarding
context.go(AppRoutes.login);      // Login screen

// Alternative: direct to registration
context.go(AppRoutes.register);   // Registration screen
```

## Responsive Design

All sizing uses `flutter_screenutil` for consistent responsive behavior:

```dart
// Spacing
SizedBox(height: 40.h)
EdgeInsets.symmetric(horizontal: 24.w)

// Image sizing
height: 360.h
width: 165.w

// Text sizing
fontSize: 16.sp

// Border radius
borderRadius: BorderRadius.circular(20.r)
```

## Animations

### Page Transitions
- **Duration:** 300ms
- **Curve:** `Curves.ease`
- Triggered by next button or swipe gesture

### Indicator Animation
- **Duration:** 250ms
- **Property:** Width (12w ↔ 24w)
- **Curve:** Default linear

## Testing Considerations

### Unit Tests
```dart
// Test model
test('OnboardingModel should combine title parts', () {
  final model = OnboardingModel(
    image: 'test.png',
    titlePart1: 'Hello ',
    titlePart2: 'World',
    isSplitTitle: true,
  );
  expect(model.fullTitle, 'Hello World');
});
```

### Widget Tests
```dart
// Test navigation
testWidgets('Skip button navigates to login', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Skip'));
  await tester.pumpAndSettle();
  expect(find.byType(LoginScreen), findsOneWidget);
});
```

### Integration Tests
- Test complete onboarding flow
- Verify state persistence
- Test theme switching
- Test page swiping

## Common Modifications

### Change Number of Pages

1. Update `onboardingItems` list in `onboarding_model.dart`
2. The UI automatically adapts to list length

### Customize Animation Speed

```dart
// In OnboardingScreen._next()
_controller.nextPage(
  duration: const Duration(milliseconds: 500),  // Change this
  curve: Curves.elasticOut,  // Change curve
);
```

### Add Progress Text

```dart
// In OnboardingScreen.build()
Text('${_currentPage + 1} / ${onboardingItems.length}')
```

### Change Button Placement

```dart
// Modify conditional in OnboardingScreen
if (_currentPage != onboardingItems.length - 1)
  // Show indicator and next button on all pages
```

## Accessibility

Consider adding:

```dart
Semantics(
  label: 'Onboarding page ${_currentPage + 1} of ${onboardingItems.length}',
  child: OnboardingPage(...),
)
```

## Best Practices

1. **Keep it short:** 3-5 pages maximum
2. **Clear value proposition:** Show benefits, not features
3. **Skip option:** Always allow users to skip
4. **Visual hierarchy:** Use clear typography and spacing
5. **Consistent timing:** Animations should feel natural (200-300ms)
6. **Test on devices:** Verify responsive behavior on various screen sizes
7. **Localization:** Use string constants for easy translation
8. **Analytics:** Track which pages users view and skip rate

## Performance Considerations

- Images are loaded synchronously (consider precaching)
- Use `const` constructors where possible
- Dispose PageController properly
- Images should be optimized for mobile

## Troubleshooting

### Issue: Images not loading
**Solution:** Verify assets in `pubspec.yaml` and check file paths in `AppAssets`

### Issue: Navigation not working on last page
**Solution:** Check that buttons properly call `AppPrefs.setOnboardingCompleted()`

### Issue: Indicator not animating
**Solution:** Verify `setState()` is called in `onPageChanged`

### Issue: Split title not showing colors
**Solution:** Check `isSplitTitle` flag and verify both title parts are provided

### Issue: Button colors wrong in dark mode
**Solution:** Verify theme brightness detection and conditional color application

## Future Enhancements

Potential improvements:

- [ ] Add swipe gestures hints
- [ ] Implement auto-advance timer option
- [ ] Add lottie animations for illustrations
- [ ] Include video support
- [ ] Add analytics tracking
- [ ] Implement A/B testing for content
- [ ] Add interactive elements (quizzes, etc.)
- [ ] Support landscape orientation
- [ ] Add haptic feedback on page change
- [ ] Implement progress save (resume from last page)

## Analytics Events

Recommended events to track:

```dart
// Track page views
analytics.logEvent('onboarding_page_viewed', {
  'page_index': _currentPage,
  'page_title': onboardingItems[_currentPage].titlePart1,
});

// Track completion
analytics.logEvent('onboarding_completed', {
  'method': 'skip' | 'complete',
  'pages_viewed': _currentPage + 1,
});

// Track button taps
analytics.logEvent('onboarding_action', {
  'action': 'login' | 'register',
});
```

## Related Documentation

- [Splash Feature Documentation](../splash/README.md)
- [Authentication Documentation](../auth/README.md)
- [Navigation Documentation](../../core/routing/README.md)
- [Theme Documentation](../../core/theme/README.md)
- [Common UI Components](../../core/common_ui/README.md)

## Example: Custom Onboarding Page

```dart
// Add a custom interactive page
OnboardingModel(
  image: AppAssets.onboardingCustom,
  titlePart1: 'Your Custom Title',
  customWidget: CustomInteractiveWidget(),  // Future enhancement
),
```

## Localization Support

To support multiple languages:

```dart
// Use localized strings
titlePart1: AppLocalizations.of(context).onboardingTitle1,

// Or use a localization package
titlePart1: 'onboarding_title_1'.tr(),
```

## Version History

- **v1.0.0** - Initial implementation with 4 pages
- **v1.1.0** - Added theme support
- **v1.2.0** - Improved animations and responsiveness
