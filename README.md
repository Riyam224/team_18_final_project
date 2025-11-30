# Fintech App - Team 18 Final Project

A modern Flutter fintech application with enterprise-grade security features, real-time cryptocurrency market data, and clean architecture implementation.

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- Firebase account (for authentication)

### Installation

```bash
# Clone repository
git clone <repository-url>
cd team_18_final_project

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### With CoinGecko API Key (Optional)

For full market data features:

```bash
flutter run --dart-define=COINGECKO_API_KEY=your_api_key_here
```

Get your free API key: [CoinGecko API](https://www.coingecko.com/en/api/pricing)

---

## ✨ Key Features

### 🔐 Security Features
- **Biometric Authentication** - Face ID / Touch ID / Fingerprint login
- **End-to-End Encryption** - AES-256 encryption for sensitive data
- **Session Management** - Auto-expiring secure sessions
- **App Lock** - Automatic locking after inactivity
- **Screenshot Prevention** - Blocks screenshots on sensitive screens
- **Root/Jailbreak Detection** - Security warnings on compromised devices
- **Audit Logging** - Security event tracking

### 💰 Finance Features
- **Live Market Data** - Real-time cryptocurrency prices via CoinGecko API
- **Portfolio Tracking** - Monitor your crypto holdings
- **Transaction History** - Encrypted transaction records
- **Market Overview** - Global crypto market statistics
- **Trending Coins** - Discover popular cryptocurrencies
- **Top Gainers** - Track best performing coins

### 🎨 User Experience
- **Clean Architecture** - Maintainable and testable codebase
- **Modern UI** - Material Design 3 with light/dark themes
- **Responsive Design** - Optimized for all screen sizes
- **Smooth Navigation** - GoRouter with declarative routing
- **Onboarding Flow** - Welcoming first-time user experience

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

```
┌─────────────────────────────────────┐
│     Presentation Layer              │  ← UI, Screens, Cubits
├─────────────────────────────────────┤
│        Domain Layer                 │  ← Business Logic, Use Cases
├─────────────────────────────────────┤
│         Data Layer                  │  ← API, Database, Repositories
├─────────────────────────────────────┤
│         Core Layer                  │  ← DI, Security, Networking
└─────────────────────────────────────┘
```

**→ [Read Architecture Guide](docs/ARCHITECTURE.md)**

---

## 📁 Project Structure

```
lib/
├── core/                   # Infrastructure & shared code
│   ├── config/            # App configuration
│   ├── di/                # Dependency injection
│   ├── networking/        # HTTP client setup
│   ├── routing/           # Navigation
│   └── security/          # Security services
│
├── features/              # Feature modules (Clean Architecture)
│   ├── auth/             # Authentication & security
│   ├── home/             # Dashboard & market overview
│   ├── market/           # Crypto market & trading
│   ├── portfolio/        # Portfolio management
│   ├── profile/          # User profile
│   ├── settings/         # App settings
│   └── transactions/     # Transaction history
│
└── main.dart             # App entry point

docs/                     # Comprehensive documentation
test/                     # Unit & widget tests
integration_test/         # Integration tests
```

**→ [See detailed structure in Architecture Guide](docs/ARCHITECTURE.md)**

---

## 📚 Documentation

Comprehensive documentation is available in the [`docs/`](docs/) folder:

| Document | Description |
|----------|-------------|
| **[Architecture Guide](docs/ARCHITECTURE.md)** | Clean Architecture implementation |
| **[Core Architecture](docs/CORE_ARCHITECTURE_GUIDE.md)** | Core layer deep dive (DI, Security, Config) |
| **[Features Guide](docs/FEATURES_COMPLETE_GUIDE.md)** | All app features explained |
| **[Security Features](docs/SECURITY_FEATURES_OVERVIEW.md)** | Complete security reference |
| **[Authentication Flow](docs/AUTH_FLOW.md)** | Auth & biometric implementation |
| **[API Integration](docs/API_INTEGRATION.md)** | CoinGecko API & networking |
| **[Testing Guide](docs/TESTING_GUIDE.md)** | Testing strategy & guides |
| **[Test Coverage](docs/TEST_COVERAGE.md)** | Coverage reports & analysis |

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# With coverage
flutter test --coverage
```

### Test Structure

- `test/` - Unit and widget tests
- `integration_test/` - End-to-end tests
- Test coverage reports available

**→ [Testing Guide](docs/TESTING_GUIDE.md)** | **[Coverage Guide](docs/TEST_COVERAGE.md)**

---

## 💻 Tech Stack

### Core
- **Flutter** - Cross-platform framework
- **Dart 3.0+** - Programming language
- **Firebase** - Authentication & Firestore

### Key Packages
- **flutter_bloc** - State management
- **dio** - HTTP client
- **go_router** - Navigation
- **get_it** - Dependency injection
- **flutter_secure_storage** - Secure data storage
- **local_auth** - Biometric authentication
- **encrypt** - AES encryption

**→ [View pubspec.yaml](pubspec.yaml)**

---

## 🔧 Configuration

### Environment Variables

```bash
# CoinGecko API (optional)
--dart-define=COINGECKO_API_KEY=your_key
```

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
