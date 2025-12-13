# Documentation Index

This document serves as the complete index and navigation guide for all project documentation. Use this to find specific information about the CryptoWallet Flutter application's architecture, features, security, and code quality.

---

## 📚 Documentation Index

### Architecture & Design

| Document | Description |
|----------|-------------|
| [**ARCHITECTURE.md**](./ARCHITECTURE.md) | Clean Architecture guide - layers, patterns, dependency injection, and data flow |
| [**CORE_ARCHITECTURE_GUIDE.md**](./CORE_ARCHITECTURE_GUIDE.md) | Core layer reference - services, configuration, networking, utilities |
| [**STATE_MANAGEMENT.md**](./STATE_MANAGEMENT.md) | State management patterns and Cubit implementation |
| [**CODE_QUALITY_IMPROVEMENTS.md**](./CODE_QUALITY_IMPROVEMENTS.md) | Code quality improvements, SOLID principles, clean code practices |

### Features Documentation

| Document | Description |
|----------|-------------|
| [**AUTH_FLOW.md**](./AUTH_FLOW.md) | Authentication system - login, registration, biometric flows |
| [**FEATURES_COMPLETE_GUIDE.md**](./FEATURES_COMPLETE_GUIDE.md) | Complete feature guide - home, market, portfolio, transactions |
| [**API_INTEGRATION.md**](./API_INTEGRATION.md) | CoinGecko API integration and data sources |

### Module-Specific Documentation

| Module | Description |
|--------|-------------|
| [**auth_module.md**](./FEATURE_DOCUMENTS/auth_module.md) | Authentication module details |
| [**home_module.md**](./FEATURE_DOCUMENTS/home_module.md) | Home/Dashboard module |
| [**market_module.md**](./FEATURE_DOCUMENTS/market_module.md) | Market features |
| [**portfolio_module.md**](./FEATURE_DOCUMENTS/portfolio_module.md) | Portfolio management |
| [**transactions_module.md**](./FEATURE_DOCUMENTS/transactions_module.md) | Transaction history |
| [**profile_module.md**](./FEATURE_DOCUMENTS/profile_module.md) | User profile |
| [**settings_module.md**](./FEATURE_DOCUMENTS/settings_module.md) | App settings |
| [**onboarding_module.md**](./FEATURE_DOCUMENTS/onboarding_module.md) | Onboarding flow |

### Security

| Document | Description |
|----------|-------------|
| [**SECURITY_FEATURES_OVERVIEW.md**](./SECURITY_FEATURES_OVERVIEW.md) | Complete security features - biometric auth, encryption, session management |

### Testing & Quality

| Document | Description |
|----------|-------------|
| [**TESTING.md**](./TESTING.md) | Testing strategy, structure, philosophy, and best practices |

### DevOps

| Document | Description |
|----------|-------------|
| [**CI_CD.md**](./CI_CD.md) | CI/CD pipeline and deployment |

---

## 🎯 Quick Start

### New to the Project?

Start with these documents in order:

1. **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Understand the overall architecture
2. **[CORE_ARCHITECTURE_GUIDE.md](./CORE_ARCHITECTURE_GUIDE.md)** - Learn about core services
3. **[AUTH_FLOW.md](./AUTH_FLOW.md)** - Understand authentication flows
4. **[FEATURES_COMPLETE_GUIDE.md](./FEATURES_COMPLETE_GUIDE.md)** - Explore app features

### Working on Features?

- **Home/Market Features:** [FEATURES_COMPLETE_GUIDE.md](./FEATURES_COMPLETE_GUIDE.md)
- **API Integration:** [API_INTEGRATION.md](./API_INTEGRATION.md)
- **Authentication:** [AUTH_FLOW.md](./AUTH_FLOW.md)
- **State Management:** [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md)

### Security & Testing?

- **Security Implementation:** [SECURITY_FEATURES_OVERVIEW.md](./SECURITY_FEATURES_OVERVIEW.md)
- **Writing Tests:** [TESTING.md](./TESTING.md)

---

## 🏗️ Project Structure

```text
lib/
├── core/                    # Core infrastructure
│   ├── config/             # Configuration files
│   ├── di/                 # Dependency injection
│   ├── networking/         # HTTP client, API
│   ├── routing/            # Navigation
│   ├── security/           # Security services
│   └── common_ui/          # Shared widgets
│
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   │   ├── domain/        # Business logic
│   │   ├── data/          # Data sources
│   │   └── presentation/  # UI & state
│   ├── home/              # Home/Dashboard
│   ├── market/            # Market listings
│   ├── portfolio/         # Portfolio
│   ├── transactions/      # Transaction history
│   └── profile/           # User profile
│
└── main.dart              # App entry point
```

---

## 🔍 Finding What You Need

### I need to understand...

| Topic | Read This |
|-------|-----------|
| How the app is architected | [ARCHITECTURE.md](./ARCHITECTURE.md) |
| How login/registration works | [AUTH_FLOW.md](./AUTH_FLOW.md) |
| How security features work | [SECURITY_FEATURES_OVERVIEW.md](./SECURITY_FEATURES_OVERVIEW.md) |
| How to add a new feature | [ARCHITECTURE.md](./ARCHITECTURE.md) + [CORE_ARCHITECTURE_GUIDE.md](./CORE_ARCHITECTURE_GUIDE.md) |
| How to write tests | [TESTING.md](./TESTING.md) |
| What APIs are used | [API_INTEGRATION.md](./API_INTEGRATION.md) |
| State management patterns | [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md) |
| Recent code improvements | [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md) |
| Core services | [CORE_ARCHITECTURE_GUIDE.md](./CORE_ARCHITECTURE_GUIDE.md) |
| Feature implementations | [FEATURES_COMPLETE_GUIDE.md](./FEATURES_COMPLETE_GUIDE.md) |

### I want to...

| Goal | Read This |
|------|-----------|
| Add a new feature | [ARCHITECTURE.md](./ARCHITECTURE.md) sections on layers and patterns |
| Integrate a new API | [API_INTEGRATION.md](./API_INTEGRATION.md) + [ARCHITECTURE.md](./ARCHITECTURE.md) repository pattern |
| Add biometric auth to a screen | [SECURITY_FEATURES_OVERVIEW.md](./SECURITY_FEATURES_OVERVIEW.md) + [AUTH_FLOW.md](./AUTH_FLOW.md) |
| Write unit tests | [TESTING.md](./TESTING.md) unit testing section |
| Understand routing | [CORE_ARCHITECTURE_GUIDE.md](./CORE_ARCHITECTURE_GUIDE.md) routing section |
| Use secure storage | [SECURITY_FEATURES_OVERVIEW.md](./SECURITY_FEATURES_OVERVIEW.md) secure storage section |
| Follow best practices | [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md) |
| Set up CI/CD | [CI_CD.md](./CI_CD.md) |

---

## ✅ Code Quality Standards

The codebase follows these standards (see [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md)):

### Clean Architecture ✅

- Domain layer has no external dependencies
- Dependency rule enforced (inward dependencies only)
- Proper layer separation

### SOLID Principles ✅

- Single Responsibility Principle
- Open/Closed Principle
- Liskov Substitution Principle
- Interface Segregation Principle
- Dependency Inversion Principle

### Clean Code ✅

- No hardcoded values (all in constants)
- Production-safe logging (`debugPrint`)
- Meaningful method names
- Minimal comments (code is self-documenting)
- Small, focused methods

### Testing ✅

- Unit tests for use cases
- Widget tests for UI
- Integration tests for flows
- 122+ test cases passing

---

## 🚀 Getting Started

1. **Clone and setup:**

   ```bash
   flutter pub get
   ```

2. **Read the architecture:**
   - [ARCHITECTURE.md](./ARCHITECTURE.md) - Understand the structure

3. **Explore a feature:**
   - [AUTH_FLOW.md](./AUTH_FLOW.md) - See how authentication works
   - [FEATURES_COMPLETE_GUIDE.md](./FEATURES_COMPLETE_GUIDE.md) - See all features

4. **Run tests:**

   ```bash
   flutter test
   ```

5. **Start coding:**
   - Follow patterns in [ARCHITECTURE.md](./ARCHITECTURE.md)
   - Follow quality standards in [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md)

---

## 📝 Documentation Standards

All documentation follows:

- ✅ Clear structure with table of contents
- ✅ Code examples for complex concepts
- ✅ Visual diagrams for flows (Mermaid)
- ✅ Cross-references between docs
- ✅ Regular updates with code changes

---

## 🤝 Contributing

When adding new features:

1. **Follow the architecture** - See [ARCHITECTURE.md](./ARCHITECTURE.md)
2. **Follow quality standards** - See [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md)
3. **Write tests** - See [TESTING.md](./TESTING.md)
4. **Update docs** - Document new features
5. **Review checklist:**
   - ✅ Clean Architecture layers respected
   - ✅ SOLID principles followed
   - ✅ No hardcoded values
   - ✅ Tests written
   - ✅ Documentation updated

---

## 📧 Support

For questions about the architecture or implementation:

1. Check relevant documentation above
2. Review code examples in docs
3. Check [CODE_QUALITY_IMPROVEMENTS.md](./CODE_QUALITY_IMPROVEMENTS.md) for recent changes

---

**Last Updated**: December 2025
**Version**: 1.0.0
