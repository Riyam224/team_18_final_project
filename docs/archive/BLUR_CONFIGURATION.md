# Blur Configuration - Complete Guide

## Overview
This document explains how screen blur is configured in the app. The blur feature uses `SecureApplication` to protect sensitive financial data when the app goes to background.

## Configuration File
[lib/core/observers/app_route_observer.dart](lib/core/observers/app_route_observer.dart)

## Screen Categories

### 1. **Sensitive Screens (WITH Blur)** 🔒
These screens contain sensitive financial data and WILL have blur applied when app goes to background:

- **Home** - `/home` - Dashboard with balance and transactions
- **Portfolio** - `/portfolio` - User's crypto holdings
- **Coin Details** - `/coinDetails` - Price charts and trading info
- **Transactions** - `/transactions` - Transaction history
- **Buy/Sell** - `/buySell` - Trading interface
- **Payment** - `/payment` - Payment processing

**Why blur?** These screens display sensitive financial information that should be hidden when switching apps or taking screenshots.

### 2. **Non-Blur Screens (NO Blur)** 🔓
These screens will NOT have blur applied:

#### Authentication Screens
- **Login** - `/login`
- **Register** - `/register`

#### Face ID Screens (Registration)
- **Set Face ID Register** - `/setFaceIDRegister`
- **Face ID Scanning Register** - `/faceIdScanningRegister`
- **Face ID Success Register** - `/faceIdSuccessRegister`

#### Fingerprint Screens (Registration)
- **Set Fingerprint Register** - `/setFingerprintRegister`
- **Fingerprint Success Register** - `/fingerprintSuccessRegister`

#### Face ID Screens (Login)
- **Face ID Scanning Login** - `/faceIdScanningLogin`
- **Face ID Verified Success Login** - `/faceIdVerifiedSuccessLogin`

#### Fingerprint Screens (Login)
- **Verify Fingerprint Login** - `/verifyFingerprintLogin`
- **Fingerprint Verified Success Login** - `/verifyFingerprintLoginSuccess`

#### Other Screens
- **Splash** - `/splash`
- **Onboarding** - `/onboarding`
- **Settings** - `/settings`
- **Profile** - `/profile`
- **Market** - `/market`
- **App Lock** - `/app-lock`
- **Lock** - `/lock`
- **Biometric** - `/biometric`
- **Root Warning** - `/root-warning`
- **Biometric Test** - `/biometric-test`
- **Debug Biometrics** - `/debug-biometrics`

**Why no blur?** These screens either:
1. Require visual feedback (biometric authentication)
2. Don't contain sensitive data (onboarding, settings)
3. Are authentication flows that should remain visible

## How It Works

### Priority Order
The app route observer checks screens in this order:

1. **First**: Is it in `nonBlurRoutes`? → NO blur
2. **Second**: Is it in `sensitiveRoutes`? → Apply blur
3. **Third**: Default → NO blur

### Code Logic
```dart
void _handleSecurity(Route<dynamic>? route) {
  final name = route?.settings.name;

  if (_shouldDisableBlur(name)) {
    // NO BLUR - Authentication and biometric screens
    _controller!.open();
    ScreenshotPreventionService.disableScreenshotPrevention();
  } else if (_isSensitive(name)) {
    // BLUR - Sensitive financial screens
    _controller!.secure();
    ScreenshotPreventionService.enableScreenshotPrevention();
  } else {
    // NO BLUR - Normal screens
    _controller!.open();
    ScreenshotPreventionService.disableScreenshotPrevention();
  }
}
```

## Security Features

### SecureApplication Controller
- `controller.secure()` - Enables blur + screenshot blocking
- `controller.open()` - Disables blur + allows screenshots

### Screenshot Prevention
- **Enabled**: On sensitive financial screens
- **Disabled**: On auth, biometric, and normal screens

## User Experience

### Sensitive Screens (e.g., Home, Portfolio)
```
User on Home → App goes to background → Blur applied ✅
User switches back → Blur removed → Content visible
```

### Authentication Screens (e.g., Login, Face ID)
```
User on Login → App goes to background → NO blur ✅
User on Face ID scan → Can see camera/animation → NO blur ✅
User switches back → Content still visible
```

## Adding New Screens

### To Add a Sensitive Screen (WITH blur):
```dart
final List<String> sensitiveRoutes = [
  AppRoutes.home,
  AppRoutes.portfolio,
  AppRoutes.newSensitiveScreen, // ← Add here
];
```

### To Add a Non-Blur Screen (NO blur):
```dart
final List<String> nonBlurRoutes = [
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.newAuthScreen, // ← Add here
];
```

## Testing Checklist

### ✅ Blur Applied (Sensitive Screens)
- [ ] Home screen blurs when app goes to background
- [ ] Portfolio screen blurs when app goes to background
- [ ] Coin details screen blurs when app goes to background
- [ ] Buy/Sell screen blurs when app goes to background
- [ ] Payment screen blurs when app goes to background
- [ ] Screenshots are blocked on these screens

### ✅ No Blur (Authentication Screens)
- [ ] Login screen does NOT blur
- [ ] Register screen does NOT blur
- [ ] Face ID scanning screen does NOT blur (registration)
- [ ] Face ID scanning screen does NOT blur (login)
- [ ] Fingerprint scan screen does NOT blur (registration)
- [ ] Fingerprint verify screen does NOT blur (login)
- [ ] Face ID success screen does NOT blur
- [ ] Fingerprint success screen does NOT blur

### ✅ No Blur (Other Screens)
- [ ] Splash screen does NOT blur
- [ ] Onboarding screens do NOT blur
- [ ] Settings screen does NOT blur
- [ ] Profile screen does NOT blur
- [ ] Market screen does NOT blur

## Common Issues & Solutions

### Issue 1: Biometric screen is blurred
**Solution**: Add the route to `nonBlurRoutes` list

### Issue 2: Sensitive screen is not blurred
**Solution**: Add the route to `sensitiveRoutes` list

### Issue 3: Blur not working at all
**Solution**: Check that `SecureApplicationController` is properly initialized in `main.dart`

### Issue 4: Screenshot blocking not working
**Solution**: Verify `ScreenshotPreventionService` is called in `_handleSecurity()`

## Configuration Summary

| Screen Type | Blur | Screenshot Block | Why |
|------------|------|------------------|-----|
| Home, Portfolio, Coin Details | ✅ | ✅ | Financial data |
| Buy/Sell, Payment | ✅ | ✅ | Transaction data |
| Login, Register | ❌ | ❌ | Authentication flow |
| Face ID screens | ❌ | ❌ | Need visual feedback |
| Fingerprint screens | ❌ | ❌ | Need visual feedback |
| Settings, Profile | ❌ | ❌ | Non-sensitive data |
| Onboarding, Splash | ❌ | ❌ | Public screens |

## Best Practices

1. **Only blur screens with sensitive financial data**
2. **Never blur authentication or biometric screens**
3. **Test blur behavior after adding new routes**
4. **Document why a screen needs blur**
5. **Keep sensitive routes list minimal**

## Technical Details

### Dependencies
- `secure_application` package - Provides blur functionality
- `SecureApplicationController` - Controls blur state
- `AppRouteObserver` - Monitors route changes
- `ScreenshotPreventionService` - Blocks screenshots on Android

### Platform Support
- **iOS**: Blur works via `SecureApplication`
- **Android**: Blur + FLAG_SECURE for screenshot blocking
- **Web**: Not applicable

---

**Last Updated**: 2025-11-29
**Status**: ✅ Fully Configured
**Maintainer**: Development Team
