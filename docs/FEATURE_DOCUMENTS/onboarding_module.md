# Onboarding Module

## Purpose
Guide first-time users through app value props before authentication; stores completion state to skip on subsequent launches.

## Structure
```
features/onboarding/
├─ data/models/onboarding_model.dart
└─ presentation/
   ├─ screens/onboarding_screen.dart
   └─ widgets/onboarding_page.dart, onboarding_indicator.dart
```

## Dependencies
- `RoutesConfig` to mark onboarding as non-sensitive (no blur/screenshot blocking).
- Completion flag persisted via secure storage (`StorageKeysConfig.hasCompletedOnboarding`) in surrounding flows (set when leaving onboarding).

## Flow
- `onboarding_screen.dart` builds pages from `OnboardingModel` list; indicators animate with `TimingConfig.onboardingPageTransitionDuration`.
- On completion, navigate to `/login` or `/register`.

## Extensibility
- Add analytics events per page.
- Move completion persistence to a dedicated use case + repository if onboarding gains dynamic content.
