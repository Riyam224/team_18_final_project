# Team 18 Final Project - Crypto Portfolio App

A Flutter fintech application featuring cryptocurrency portfolio management with Clean Architecture, BLoC state management, and 98% test coverage.

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/your-repo/team_18_final_project.git
cd team_18_final_project
flutter pub get

# Generate code (Retrofit/json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test
```

## ✨ Features

- 📊 **Real-time Portfolio Tracking** - Live cryptocurrency prices via CoinGecko API
- 💰 **Multi-Crypto Support** - BTC, ETH, LTC, and more
- 📈 **Performance Analytics** - 24-hour price changes and trends
- 🥧 **Asset Allocation Charts** - Visual breakdown with donut charts
- 📅 **Historical Data** - Monthly performance filtering
- 🎨 **Modern UI** - Dark/Light theme with custom gradients
- ✅ **98% Test Coverage** - 102 tests (unit, widget, integration)

## 🏗️ Architecture

**Clean Architecture** with three layers:

```
┌─────────────────────┐
│   PRESENTATION      │  ← BLoC/Cubit, Screens, Widgets
├─────────────────────┤
│      DOMAIN         │  ← Entities, Use Cases, Repository Interfaces
├─────────────────────┤
│       DATA          │  ← API, Models, Repository Implementation
└─────────────────────┘
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.x |
| **State Management** | BLoC/Cubit |
| **Dependency Injection** | GetIt |
| **Networking** | Dio + Retrofit |
| **API** | CoinGecko API v3 |
| **Charts** | fl_chart |
| **Error Handling** | Dartz (Either/Failure) |
| **Testing** | flutter_test, Mocktail, bloc_test |

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities & configuration
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection
│   ├── networking/         # API client setup
│   └── utils/              # Utilities (colors, themes)
│
└── features/portfolio/     # Portfolio feature
    ├── domain/             # Business logic (pure Dart)
    ├── data/               # API & data sources
    └── presentation/       # UI & state management

test/
├── core/constants/         # Core constants tests (60 tests)
└── features/portfolio/     # Portfolio tests (102 tests)
    ├── domain/            # Entity & use case tests
    ├── data/              # Repository tests
    └── presentation/      # Cubit & widget tests
```

## 📊 Testing

- **Total Tests**: 102
- **Passing**: 100 (98%)
- **Coverage**: Domain (100%), Data (95%), Presentation (96%)

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Portfolio tests only
flutter test test/features/portfolio/

# Integration tests
flutter test test/features/portfolio/presentation/portfolio_screen_integration_test.dart
```

## 📖 Documentation

### Main Documentation Files

| Document | Purpose |
|----------|---------|
| **[docs/PORTFOLIO.md](docs/PORTFOLIO.md)** | Complete feature guide - architecture, API integration, UI components, how to add cryptocurrencies, troubleshooting |
| **[test/features/portfolio/README.md](test/features/portfolio/README.md)** | Testing guide - how to run tests, test structure, patterns, 98% coverage details |

### Quick Links by Task

| What you need | Where to go |
|--------------|-------------|
| **Set up the project** | This README → [Quick Start](#-quick-start) |
| **Understand architecture** | [docs/PORTFOLIO.md#architecture](docs/PORTFOLIO.md#architecture) |
| **Add a cryptocurrency** | [docs/PORTFOLIO.md#adding-a-new-cryptocurrency](docs/PORTFOLIO.md#adding-a-new-cryptocurrency) |
| **Customize colors** | [docs/PORTFOLIO.md#task-4-customize-colors](docs/PORTFOLIO.md#task-4-customize-colors) |
| **Run tests** | [test/features/portfolio/README.md](test/features/portfolio/README.md#-quick-start) |
| **Fix an issue** | [docs/PORTFOLIO.md#troubleshooting](docs/PORTFOLIO.md#troubleshooting) |

## 🎨 Color System

All colors are centralized with zero hardcoding:

```dart
// Core colors (lib/core/utils/app_colors.dart)
static const Color accentPurple = Color(0xFF8979FF);  // BTC
static const Color accentCyan = Color(0xFF4DD0E1);    // ETH
static const Color accentCoral = Color(0xFFFF8A80);   // LTC

// Portfolio colors reference core colors
static const Color bitcoin = AppColors.accentPurple;
```

**Benefits:** Single source of truth, easy maintenance, reusable across features

## 🔧 Development Workflow

### Adding a New Cryptocurrency

1. Update local data source with holding details
2. Add color to `lib/core/utils/app_colors.dart`
3. Map color/icon in `lib/features/portfolio/presentation/portfolio_utils/app_portfolio_colors.dart`
4. Run tests: `flutter test test/core/constants/app_portfolio_colors_test.dart`

See [docs/PORTFOLIO.md - Adding New Crypto](docs/PORTFOLIO.md#adding-a-new-cryptocurrency) for detailed steps.

### Git Branches

- `main` - Production-ready code
- `develop` - Integration branch (current: `feature/portfolio_v3`)
- `feature/*` - Feature branches

### Commit Convention

```bash
feat: add new cryptocurrency support
fix: correct portfolio calculation
test: add integration tests
docs: update README
```

## 🌐 API Integration

**CoinGecko API**

- Base URL: `https://api.coingecko.com/api/v3`
- No authentication required (free tier)
- Rate limit: 10-50 calls/minute
- [Documentation](https://www.coingecko.com/en/api)

**Supported Cryptocurrencies:**
Bitcoin (BTC), Ethereum (ETH), Litecoin (LTC), Cardano (ADA), Polkadot (DOT), Solana (SOL), Dogecoin (DOGE), Polygon (MATIC), Binance Coin (BNB), Ripple (XRP)

## 🐛 Troubleshooting

**Build issues:**

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Test failures:**

```bash
flutter test --no-sound-null-safety
```

**API rate limiting:** See [docs/PORTFOLIO.md - Troubleshooting](docs/PORTFOLIO.md#troubleshooting)

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3        # State management
  get_it: ^7.6.4              # Dependency injection
  dio: ^5.4.0                 # HTTP client
  retrofit: ^4.0.3            # REST API
  dartz: ^0.10.1              # Functional programming
  fl_chart: ^0.65.0           # Charts
  go_router: ^12.1.1          # Navigation

dev_dependencies:
  mocktail: ^1.0.0            # Mocking
  bloc_test: ^9.1.0           # BLoC testing
  build_runner: ^2.4.6        # Code generation
```

## 📝 Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Write tests for all features
- Use meaningful names
- Keep functions small and focused
- Comment complex business logic

## 🤝 Contributing

1. Create feature branch from `develop`
2. Follow Clean Architecture structure
3. Write tests (aim for >90% coverage)
4. Update documentation
5. Create PR to `develop`
6. Ensure all tests pass

## 📄 License

This project is part of Team 18's final project submission.

---

**Team**: Team 18
**Framework**: Flutter 3.x
**Last Updated**: December 2, 2025
**Test Coverage**: 98% (102 tests)
**Documentation**: [docs/](docs/)
