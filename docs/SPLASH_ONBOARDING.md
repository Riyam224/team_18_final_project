# Splash & Onboarding Documentation

## Overview

This document describes the splash screen and onboarding flow implementation, which handles the initial app experience for both first-time and returning users.

## Application Entry Flow

```
┌─────────────────┐
│   App Launch    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ Splash Screen   │
│ (animated)      │
└────────┬────────┘
         │
         │ 2 second delay
         ↓
┌─────────────────┐
│ Check Session   │
│ Status          │
└────────┬────────┘
         │
         ├─→ First time user → Onboarding
         ├─→ Valid session → Home (with biometric check)
         └─→ No session → Login
```

## Splash Screen

### Location
**File:** `lib/features/splash/presentation/screens/splash_screen.dart`

### Purpose
- Display app branding on launch
- Provide smooth entry animation
- Allow time for initialization
- Route to appropriate screen

### Features

**1. Animation:**
- Fade-in animation (800ms duration)
- Professional app introduction
- Smooth transition

**2. Timing:**
- 2-second display duration
- Allows for initialization tasks
- Non-intrusive delay

**3. Navigation:**
- Currently routes to Login screen
- Can be configured to check onboarding status
- Session restoration handled elsewhere

### Implementation

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateToNext();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to login screen
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo/branding
              Icon(
                Icons.currency_bitcoin,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                'Crypto App',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Customization Options

**1. Change Splash Duration:**
```dart
await Future.delayed(const Duration(seconds: 3)); // 3 seconds instead of 2
```

**2. Add Initialization Logic:**
```dart
Future<void> _navigateToNext() async {
  // Perform initialization
  await _initializeServices();
  await _checkPermissions();

  await Future.delayed(const Duration(seconds: 2));

  // Then navigate
  context.go(_determineNextRoute());
}
```

**3. Dynamic Routing:**
```dart
String _determineNextRoute() {
  // Check if first time user
  if (!AppPrefs.isOnboardingCompleted()) {
    return AppRoutes.onboarding;
  }

  // Check if has valid session
  final sessionManager = GetIt.instance<SessionManager>();
  if (sessionManager.hasValidSession()) {
    return AppRoutes.home;
  }

  // Default to login
  return AppRoutes.login;
}
```

### Route Configuration

**In app_router.dart:**
```dart
GoRoute(
  path: AppRoutes.splash,  // '/splash'
  builder: (_, __) => const SplashScreen(),
),
```

**Initial Location:**
```dart
GoRouter(
  initialLocation: AppRoutes.splash,  // App starts at splash
  // ...
)
```

---

## Onboarding Screen

### Location
**File:** `lib/features/onboarding/presentation/screens/onboarding_screen.dart`

### Purpose
- Introduce app features to first-time users
- Provide visual guide to app capabilities
- Create positive first impression
- Allow users to skip if desired

### Features

**1. Multi-Page View:**
- PageView with multiple onboarding pages
- Swipeable pages
- Smooth page transitions

**2. Progress Indicators:**
- Dot indicators showing current page
- Visual feedback on progress
- Clear navigation cues

**3. Navigation Controls:**
- Skip button (top-right) - Jump directly to login
- Next button - Advance to next page
- Automatic progression on last page

**4. Completion Tracking:**
- Saves onboarding completion status
- Prevents showing onboarding again
- Uses SharedPreferences for persistence

### Implementation Structure

```dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Track Your Portfolio',
      description: 'Monitor your crypto investments in real-time',
      icon: Icons.show_chart,
    ),
    OnboardingPageData(
      title: 'Secure Transactions',
      description: 'Buy and sell crypto with confidence',
      icon: Icons.security,
    ),
    OnboardingPageData(
      title: 'Stay Informed',
      description: 'Get latest market updates and trends',
      icon: Icons.notifications_active,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Skip button
          TextButton(
            onPressed: _skipOnboarding,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Page view
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),

          // Page indicators
          _buildPageIndicators(),

          // Navigation button
          if (_currentPage < _pages.length - 1)
            _buildNextButton()
          else
            _buildGetStartedButton(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPageData data) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            data.icon,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.arrow_forward),
    );
  }

  Widget _buildGetStartedButton() {
    return ElevatedButton(
      onPressed: _completeOnboarding,
      child: const Text('Get Started'),
    );
  }

  Future<void> _skipOnboarding() async {
    await AppPrefs.setOnboardingCompleted(true);
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  Future<void> _completeOnboarding() async {
    await AppPrefs.setOnboardingCompleted(true);
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
```

### Onboarding Page Data Model

```dart
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final String? imagePath;  // Optional: Use image instead of icon

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.imagePath,
  });
}
```

### AppPrefs Helper

**Location:** `lib/core/utils/app_prefs.dart` (or similar)

```dart
class AppPrefs {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }
}
```

### Route Configuration

**In app_router.dart:**
```dart
GoRoute(
  path: AppRoutes.onboarding,  // '/onboarding'
  builder: (_, __) => const OnboardingScreen(),
),
```

---

## Complete Entry Flow Integration

### Enhanced Splash Screen with Full Routing Logic

```dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Show splash for minimum duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Determine next route
    final nextRoute = await _determineNextRoute();
    context.go(nextRoute);
  }

  Future<String> _determineNextRoute() async {
    // 1. Check if first time user
    final isOnboardingCompleted = await AppPrefs.isOnboardingCompleted();
    if (!isOnboardingCompleted) {
      return AppRoutes.onboarding;
    }

    // 2. Check if has valid session
    final sessionManager = GetIt.instance<SessionManager>();
    final hasValidSession = await sessionManager.hasValidSession();

    if (hasValidSession) {
      // Restore session
      await sessionManager.restoreSession();

      // Check if biometric is enabled
      final storage = GetIt.instance<SecureStorageService>();
      final biometricEnabled = await storage.isBiometricEnabled();

      if (biometricEnabled) {
        // Route to biometric verification
        final biometricType = await storage.getBiometricType();
        if (biometricType == 'face') {
          return AppRoutes.faceIdScanningLogin;
        } else {
          return AppRoutes.verifyFingerprintLogin;
        }
      }

      // Session valid, no biometric - go to home
      return AppRoutes.home;
    }

    // 3. No valid session - go to login
    return AppRoutes.login;
  }
}
```

---

## User Flow Scenarios

### Scenario 1: First-Time User

```
App Launch
    ↓
Splash Screen (2s)
    ↓
Onboarding Screen
    ↓ (skip or complete)
Login Screen
    ↓
Register or Login
    ↓
Biometric Setup (optional)
    ↓
Home Screen
```

### Scenario 2: Returning User (Valid Session, Biometric Enabled)

```
App Launch
    ↓
Splash Screen (2s)
    ↓
Session Check (valid)
    ↓
Biometric Verification
    ↓ (success)
Home Screen
```

### Scenario 3: Returning User (Session Expired)

```
App Launch
    ↓
Splash Screen (2s)
    ↓
Session Check (expired)
    ↓
Login Screen
    ↓
Login
    ↓
Biometric Verification
    ↓
Home Screen
```

### Scenario 4: Returning User (Valid Session, No Biometric)

```
App Launch
    ↓
Splash Screen (2s)
    ↓
Session Check (valid)
    ↓
Home Screen (direct)
```

---

## Customization Guide

### 1. Change Onboarding Content

**Add/Remove Pages:**
```dart
final List<OnboardingPageData> _pages = [
  OnboardingPageData(
    title: 'Your Title',
    description: 'Your description',
    icon: Icons.your_icon,
  ),
  // Add more pages
];
```

**Use Images Instead of Icons:**
```dart
class OnboardingPageData {
  final String? imagePath;  // Path to asset image

  // In build method:
  if (data.imagePath != null) {
    Image.asset(data.imagePath!, height: 200);
  } else {
    Icon(data.icon, size: 120);
  }
}
```

### 2. Change Splash Branding

**Update Logo:**
```dart
// Instead of Icon
Image.asset(
  'assets/images/app_logo.png',
  width: 150,
  height: 150,
),
```

**Update App Name:**
```dart
Text(
  'Your App Name',
  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  ),
),
```

### 3. Add Loading Indicator to Splash

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Logo
    Icon(Icons.currency_bitcoin, size: 100),
    const SizedBox(height: 20),
    // App name
    Text('Crypto App'),
    const SizedBox(height: 40),
    // Loading indicator
    CircularProgressIndicator(),
    const SizedBox(height: 20),
    Text(
      'Loading...',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  ],
),
```

### 4. Add Version Number to Splash

```dart
// In pubspec.yaml
version: 1.0.0+1

// In splash screen
import 'package:package_info_plus/package_info_plus.dart';

// Get version
final packageInfo = await PackageInfo.fromPlatform();
final version = packageInfo.version;

// Display
Text(
  'v$version',
  style: Theme.of(context).textTheme.bodySmall,
),
```

---

## Styling

### Theme Integration

Both screens respect the app theme:

**Colors:**
- Primary color for branding
- Scaffold background
- Text colors from theme

**Typography:**
- Theme text styles
- Consistent font sizes
- Proper text hierarchy

**Spacing:**
- Using `SizedBox` for consistent spacing
- Proper padding and margins
- Responsive layout

### Dark Mode Support

Both screens automatically support dark mode through theme:

```dart
Theme.of(context).primaryColor          // Adapts to theme
Theme.of(context).scaffoldBackgroundColor
Theme.of(context).textTheme.headlineMedium
```

---

## Animation Details

### Splash Screen Animation

**Fade-In Effect:**
```dart
AnimationController(
  duration: const Duration(milliseconds: 800),
  vsync: this,
);

Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ),
);
```

### Onboarding Page Transitions

**Smooth Page Changes:**
```dart
_pageController.nextPage(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);
```

### Optional: Add More Animations

**Scale Animation:**
```dart
late Animation<double> _scaleAnimation;

_scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
  CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
);

// In build:
ScaleTransition(
  scale: _scaleAnimation,
  child: Icon(...),
)
```

---

## Testing

### Manual Testing Checklist

**Splash Screen:**
- [ ] Animation plays smoothly
- [ ] Correct duration (2 seconds)
- [ ] Routes to correct next screen
- [ ] Works in light and dark mode
- [ ] No errors on navigation

**Onboarding Screen:**
- [ ] All pages display correctly
- [ ] Skip button works
- [ ] Next button advances pages
- [ ] Page indicators update
- [ ] Get Started button on last page
- [ ] Saves completion status
- [ ] Routes to login after completion
- [ ] Doesn't show again after completion

### Reset Onboarding (For Testing)

```dart
// Clear onboarding status
await AppPrefs.setOnboardingCompleted(false);

// Or clear all preferences
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

---

## Accessibility

### Screen Reader Support

Both screens should include semantic labels:

```dart
Semantics(
  label: 'App Logo',
  child: Icon(Icons.currency_bitcoin),
)

Semantics(
  label: 'Skip onboarding',
  button: true,
  child: TextButton(...),
)
```

### Text Scaling

Ensure text scales properly:
```dart
// Use theme text styles (automatically scale)
Theme.of(context).textTheme.headlineMedium
```

---

## Performance Considerations

### Asset Optimization

If using images:
- Compress images for smaller size
- Use appropriate resolutions
- Provide multiple densities (1x, 2x, 3x)

### Animation Performance

- Use `const` constructors where possible
- Dispose controllers properly
- Avoid rebuilding entire tree

### Navigation Performance

- Use `context.go()` instead of `context.push()` to replace route
- Minimize work during navigation
- Async operations should not block UI

---

## Best Practices

1. **Keep Splash Short** - 2-3 seconds maximum
2. **Onboarding Optional** - Always provide skip option
3. **Track Completion** - Don't show onboarding repeatedly
4. **Smooth Transitions** - Use animations for polish
5. **Respect Theme** - Support light/dark modes
6. **Accessibility** - Add semantic labels
7. **Performance** - Optimize assets and animations
8. **Error Handling** - Handle navigation failures gracefully

---

## Common Issues & Solutions

### Issue: Onboarding shows every time
**Solution:** Ensure `AppPrefs.setOnboardingCompleted(true)` is called and awaited

### Issue: Splash screen stuck
**Solution:** Check that navigation is not blocked by errors. Use try-catch around `context.go()`

### Issue: Animation not smooth
**Solution:** Use `SingleTickerProviderStateMixin` and dispose controller properly

### Issue: Page indicators not updating
**Solution:** Ensure `setState()` is called in `onPageChanged` callback

---

## Future Enhancements

1. **Animated Transitions** - Add custom page transitions
2. **Video Background** - Use video instead of static splash
3. **Interactive Tutorial** - Add interactive onboarding elements
4. **Localization** - Multi-language support for onboarding
5. **A/B Testing** - Test different onboarding flows
6. **Analytics** - Track onboarding completion rates
7. **Skip to Specific Page** - Allow jumping to any onboarding page
8. **Gesture Tutorials** - Show gesture-based features
