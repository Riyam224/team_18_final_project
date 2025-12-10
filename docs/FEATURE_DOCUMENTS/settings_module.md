# Settings Module

## Purpose
Provide entry point to app-wide preferences (theme, notifications placeholder) and links to security controls (biometrics, auto-lock) surfaced elsewhere.

## Structure
```
features/settings/presentation/screens/settings_screen.dart
```

## Notes
- Presentational screen composed of static tiles and navigation shortcuts.
- Security-related settings (biometric toggle, auto-lock duration) are managed through the Profile module + security services; keep any new settings wired through domain/use cases instead of direct storage writes.
