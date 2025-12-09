# Fintech App – Team 18

Enterprise-grade Flutter fintech app with clean architecture, Cubit state management, and a hardened security stack (biometrics, secure storage, auto-lock, screenshot protection, jailbreak/root awareness).

![Build](https://img.shields.io/badge/build-local-green) ![Tests](https://img.shields.io/badge/tests-flutter%20test-blue) ![Coverage](https://img.shields.io/badge/coverage--pending-lightgrey) ![Platform](https://img.shields.io/badge/platforms-iOS%20|%20Android%20|%20Web-lightblue)

---

## Quick Start
- Prerequisites: Flutter 3.0+, Dart 3.0+, Firebase project (for auth)
- Install & run:
  ```bash
  git clone <repository-url>
  cd team_18_final_project
  flutter pub get
  flutter run \
    --dart-define=COINGECKO_API_KEY=<optional_api_key>
  ```
- Environments: `main(env: AppEnvironment.prod)` by default; tests use `AppEnvironment.test` with security fakes (`test/test_config.dart`).

## What’s Inside
- Security: biometrics (`local_auth`), AES-256 encryption, secure storage, auto-lock, background blur/screenshot prevention, jailbreak/root detection, audit logging.
- Product: live market overview (CoinGecko), trending coins, top gainers, portfolio simulator, encrypted transaction history, onboarding, account/profile.
- Architecture: strict Clean Architecture + GetIt DI; Cubit-driven presentation; Retrofit/Dio data layer; `secure_application` + route observer for privacy controls.

## Folder Structure (high level)
```
lib/
├─ core/                 # DI, config, routing, security services, networking
└─ features/             # Clean modules
   ├─ auth/              # Firebase auth, biometrics, sessions
   ├─ home/              # Dashboard + market overview (CoinGecko)
   ├─ market/            # Coin detail UI + trade simulator
   ├─ portfolio/         # Portfolio simulator + charts
   ├─ transactions/      # Encrypted transaction log
   ├─ profile/           # My account + security tiles
   ├─ settings/          # App settings shell
   ├─ onboarding/        # First-run tour
   └─ splash/            # Startup & gating
docs/                    # Architecture, flows, security, testing, features
test/                    # Unit/widget tests + security fakes
integration_test/        # End-to-end harness
```

## Screenshots / Demos
- Add captures to `docs/images/` and reference them below once available:
  - Home dashboard
  - Biometric login success
  - Portfolio allocation chart
  - App-lock screen + blur overlay

## Tech Stack
- Framework: Flutter (Material 3), Dart 3
- Networking: Dio + Retrofit (CoinGecko)
- State: Cubit (flutter_bloc)
- DI: GetIt service locator
- Security: flutter_secure_storage, encrypt (AES), local_auth, secure_application, platform channels for screenshot prevention
- Navigation: go_router with guarded routes
- Analytics/Backend: Firebase Auth/Firestore/Storage

## Documentation
- Architecture: `docs/ARCHITECTURE.md`
- State management: `docs/STATE_MANAGEMENT.md`
- Auth + biometrics: `docs/AUTH_FLOW.md`
- Security layers: `docs/SECURITY_FEATURES_OVERVIEW.md`
- Testing: `docs/TESTING.md`
- CI/CD: `docs/CI_CD.md`
- Feature specs: `docs/FEATURE_DOCUMENTS/`

## Testing
```bash
flutter test                    # unit/widget
flutter test integration_test   # E2E harness
flutter test --coverage         # coverage -> coverage/lcov.info
```
- Tests bootstrap DI with in-memory security fakes (`test/test_config.dart`, `test/support/test_security_fakes.dart`).
- Platform-dependent suites (biometrics, screenshot prevention, root detection) may be skipped until platform channels are mocked.

## Configuration
- Market data (optional): `--dart-define=COINGECKO_API_KEY=<key>`
- Security timing: `lib/core/config/timing_config.dart`
- Sensitive routes: `lib/core/config/routes_config.dart`

## Contributing
- Run `flutter analyze && flutter format` before PRs.
- Keep feature modules self-contained (data → domain → presentation).
- Update docs when adding features; never delete `docs/SECURITY_FEATURES_OVERVIEW.md`.

### Firebase Setup

1. Create Firebase project
2. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Enable Authentication and Firestore

**→ [Configuration Guide](docs/CORE_ARCHITECTURE_GUIDE.md#configuration-system)**

---

## 🚦 Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Commit changes
git add .
git commit -m "feat: add your feature"

# Push and create PR
git push origin feature/your-feature-name
```

### Branch Strategy
- `main` - Production releases
- `develop` - Active development
- `feature/*` - New features
- `bugfix/*` - Bug fixes

---

## 📝 Contributing

### Adding a New Feature

1. **Create feature directory** in `lib/features/`
2. **Follow Clean Architecture** - separate presentation, domain, data layers
3. **Register dependencies** in `lib/core/di/di.dart`
4. **Add routes** in `lib/core/routing/app_router.dart`
5. **Write tests** for all layers
6. **Update documentation**

**→ [Adding Features Guide](docs/FEATURES_COMPLETE_GUIDE.md#adding-a-new-feature)**

### Code Style

- Follow Flutter/Dart conventions
- Use `flutter_lints` package
- Write meaningful commit messages
- Document public APIs
- Test your code

---

## 🛡️ Security

This app implements enterprise-grade security:

- ✅ **Biometric Authentication** - Secure login with Face ID/Touch ID
- ✅ **Data Encryption** - AES-256 encryption at rest
- ✅ **Secure Storage** - Platform keychain/keystore
- ✅ **Session Management** - Auto-expiring sessions
- ✅ **Screenshot Protection** - Prevents screenshots on sensitive screens
- ✅ **Root Detection** - Warns on compromised devices
- ✅ **Audit Logging** - Security event tracking

**→ [Complete Security Documentation](docs/SECURITY_FEATURES_OVERVIEW.md)**

---

## 📊 Project Status

### Current Version
- **Version**: 1.0.0+1
- **Flutter**: 3.0+
- **Status**: Active Development

### Features Status
- ✅ Authentication & Biometric Login
- ✅ Home Dashboard
- ✅ Market Data Integration
- ✅ Portfolio Management
- ✅ Transaction History
- ✅ Security Features
- ✅ Theme System (Light/Dark)
- 🚧 Trading Features (In Progress)
- 🚧 Advanced Charts (Planned)

---

## 👥 Team

**Team 18** - Final Project

---

## 📄 License

This project is for educational purposes.

---

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Firebase Documentation](https://firebase.google.com/docs)
- [CoinGecko API](https://www.coingecko.com/en/api/documentation)

---

## 📞 Support

### Having Issues?

1. Check the **[Documentation](docs/)** folder
2. Review **[Troubleshooting Guide](docs/SECURITY_FEATURES_OVERVIEW.md#troubleshooting)**
3. Run `flutter doctor` to check your setup
4. Clean and rebuild: `flutter clean && flutter pub get`

### Common Issues

| Issue | Solution |
|-------|----------|
| Build errors | Run `flutter clean && flutter pub get` |
| API not working | Add `COINGECKO_API_KEY` environment variable |
| Tests failing | Check test dependencies and mocks |
| Firebase errors | Verify Firebase configuration files |

---

**Last Updated**: 2025-11-30 | **Documentation**: [View Docs](docs/)
