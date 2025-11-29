# 📚 Team 18 Fintech - Documentation Index

Welcome to the documentation for Team 18 Fintech application. This directory contains comprehensive documentation covering all aspects of the project.

## 📖 Main Documentation

### 🌟 **[COMPLETE_DOCUMENTATION.md](./COMPLETE_DOCUMENTATION.md)** - START HERE
**The most comprehensive guide covering everything in the project.**

This is your one-stop documentation covering:
- Complete Architecture & Design Patterns
- Authentication & Security (Firebase, Biometric, Session Management)
- Home Screen & Dashboard
- Bottom Navigation Bar
- Theme System (Light & Dark Mode)
- Splash Screen & Onboarding
- Configuration & Constants
- State Management (BLoC/Cubit)
- Networking & API Integration
- Routing & Navigation
- Dependency Injection
- Testing Strategy
- Security Best Practices
- Performance Optimizations
- Getting Started Guide
- And much more...

**👉 This should be your primary reference document.**

---

## 🎯 Project Overview

**Team 18 Final Project** is a modern Flutter application for cryptocurrency portfolio management with enterprise-grade security features. The app provides real-time market data, portfolio tracking, and advanced security including biometric authentication, session management, and app-level security controls.

### Key Capabilities
- 🔐 **Enterprise Security** - Biometric auth, session management, app lock, root detection
- 📊 **Market Overview** - Global market cap, 24h volume, Bitcoin dominance
- 📈 **Trending Cryptocurrencies** - Discover coins with highest search volume
- 🚀 **Top Gainers** - Track cryptocurrencies with biggest 24h price increases
- 💰 **Portfolio Tracking** - Monitor portfolio value and weekly performance
- 🔄 **Real-time Updates** - Pull-to-refresh for latest market data
- 🎨 **Modern UI** - Clean, responsive design with light/dark themes
- 🔒 **Privacy Protection** - Screenshot prevention, background blur
- 📱 **Responsive Design** - Optimized for all screen sizes

---

## 🏗️ Architecture & Design Patterns

This project follows **Clean Architecture** principles with clear separation of concerns across three main layers:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (UI, Widgets, State Management - Flutter Bloc/Cubit)       │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│    (Business Logic, Entities, Use Cases, Repository         │
│              Interfaces - Pure Dart)                         │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  (API Services, Models, Repository Implementations,         │
│            Data Sources - External Dependencies)            │
└─────────────────────────────────────────────────────────────┘
```

### Design Patterns Used

1. **Repository Pattern** - Abstracts data sources from business logic
2. **Use Case Pattern** - Encapsulates single business actions (SRP)
3. **Bloc/Cubit Pattern** - Manages UI state reactively
4. **Dependency Injection** - Uses GetIt for loose coupling
5. **Factory Pattern** - Used in model constructors for JSON parsing
6. **Either Pattern** - Functional error handling with Dartz

---

## 🛠️ Technology Stack

### Core Framework
- **Flutter SDK** - Cross-platform UI framework (Dart 3.0+)
- **Dart** - Programming language

### State Management
- **flutter_bloc** (9.1.1) - Business Logic Component pattern
- **equatable** (2.0.7) - Value equality for state comparison

### Networking & Data
- **dio** (5.9.0) - HTTP client for API requests
- **retrofit** (4.7.3) - Type-safe REST client generator
- **json_annotation** (4.9.0) - JSON serialization annotations
- **json_serializable** (6.11.1) - Code generation for JSON

### Functional Programming
- **dartz** (0.10.1) - Functional programming (Either, Option)

### Dependency Injection
- **get_it** (8.2.0) - Service locator for DI

### UI & Styling
- **flutter_screenutil** (5.9.3) - Responsive sizing
- **flutter_svg** (2.2.1) - SVG image support
- **carousel_slider** (5.1.1) - Image carousels
- **fl_chart** (1.1.1) - Charts and graphs

### Navigation
- **go_router** (16.2.4) - Declarative routing

### Local Storage
- **shared_preferences** (2.5.3) - Key-value storage

### Development Tools
- **build_runner** (2.7.1) - Code generation
- **retrofit_generator** (10.0.6) - Retrofit code gen
- **flutter_lints** (5.0.0) - Linting rules

### Testing
- **flutter_test** - Widget and unit testing
- **bloc_test** (10.0.0) - Bloc testing utilities
- **mocktail** (1.0.4) - Mocking framework

---

## 📁 Project Structure

```
lib/
├── core/                          # Core utilities and shared code
│   ├── di/                        # Dependency injection setup
│   ├── error/                     # Error handling (Failure classes)
│   ├── networking/                # API configuration, endpoints
│   ├── theme/                     # App theming
│   └── utils/                     # Utility functions, constants
│
├── features/                      # Feature modules
│   └── home/                      # Home screen feature
│       ├── data/                  # Data layer
│       │   ├── data_sources/      # API services
│       │   ├── models/            # Data transfer objects (DTOs)
│       │   └── repositories/      # Repository implementations
│       │
│       ├── domain/                # Domain layer (business logic)
│       │   ├── entities/          # Business objects
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Use case classes
│       │
│       └── presentation/          # Presentation layer
│           ├── cubit/             # State management (Cubit)
│           ├── screens/           # Screen widgets
│           └── widgets/           # Reusable UI components
│
└── main.dart                      # App entry point

docs/                              # Documentation
├── README.md                      # This file
├── ARCHITECTURE.md                # Detailed architecture explanation
├── FILE_STRUCTURE.md              # Complete file-by-file breakdown
├── API_INTEGRATION.md             # API and networking details
└── STATE_MANAGEMENT.md            # State management guide
```

---

## ✨ Features

### 1. Home Screen Dashboard
The main screen displays:
- User greeting with profile access
- Portfolio balance card showing total value and weekly change
- Market overview grid with key metrics
- Trending cryptocurrencies carousel
- Top gainers list

### 2. Market Data
- **Global Statistics**: Total market cap, 24h volume, active coins
- **Bitcoin Dominance**: BTC's percentage of total market
- **Price Changes**: 24h percentage changes for all coins

### 3. Portfolio Tracking
- Total portfolio value in USD
- Weekly performance percentage
- Visual indicators for gains/losses

### 4. Real-time Updates
- Pull-to-refresh functionality
- Automatic data caching (30s TTL)
- Parallel API requests for performance

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- IDE (VS Code, Android Studio, IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd team_18_final_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### API Configuration
The app uses the CoinGecko API. The base URL is configured in:
```
lib/core/networking/endpoints.dart
```

---

## 🗂️ Topic-Specific Documentation

### Architecture & Structure

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Clean Architecture implementation details
- **[FILE_STRUCTURE.md](./FILE_STRUCTURE.md)** - Project folder structure and organization
- **[STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md)** - BLoC/Cubit pattern implementation
- **[QUICK_START_GUIDE.md](./QUICK_START_GUIDE.md)** - Quick reference for project structure

### Features

- **[AUTH_FLOW.md](./AUTH_FLOW.md)** - Authentication flow and implementation
- **[SPLASH_ONBOARDING.md](./SPLASH_ONBOARDING.md)** - Splash screen and onboarding flow
- **[splash.md](./splash.md)** - Detailed splash screen documentation
- **[onboarding.md](./onboarding.md)** - Detailed onboarding documentation

### Security

- **[SECURITY.md](./SECURITY.md)** - Security overview
- **[SECURITY_ARCHITECTURE.md](./SECURITY_ARCHITECTURE.md)** - Detailed security implementation

### Technical

- **[API_INTEGRATION.md](./API_INTEGRATION.md)** - API integration guide
- **[networking.md](./networking.md)** - Network layer documentation
- **[theming.md](./theming.md)** - Theme system documentation

### Project Information

- **[PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)** - Project overview and summary

---

## 🚀 Quick Navigation Guide

**I want to...**

### Learn about the entire project
→ Read [COMPLETE_DOCUMENTATION.md](./COMPLETE_DOCUMENTATION.md)

### Understand the architecture
→ Read [ARCHITECTURE.md](./ARCHITECTURE.md) and [FILE_STRUCTURE.md](./FILE_STRUCTURE.md)

### Implement authentication
→ Read [AUTH_FLOW.md](./AUTH_FLOW.md)

### Understand security features
→ Read [SECURITY_ARCHITECTURE.md](./SECURITY_ARCHITECTURE.md)

### Work with the API
→ Read [API_INTEGRATION.md](./API_INTEGRATION.md)

### Customize the theme
→ Read [theming.md](./theming.md)

### Understand state management
→ Read [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md)

### Get started quickly
→ Read [QUICK_START_GUIDE.md](./QUICK_START_GUIDE.md)

---

## 📁 Documentation Structure

```
docs/
├── README.md                        # This file - Documentation index
├── COMPLETE_DOCUMENTATION.md        # 🌟 Main comprehensive documentation
│
├── Architecture & Structure
│   ├── ARCHITECTURE.md
│   ├── FILE_STRUCTURE.md
│   ├── STATE_MANAGEMENT.md
│   └── QUICK_START_GUIDE.md
│
├── Features
│   ├── AUTH_FLOW.md
│   ├── SPLASH_ONBOARDING.md
│   ├── splash.md
│   └── onboarding.md
│
├── Security
│   ├── SECURITY.md
│   └── SECURITY_ARCHITECTURE.md
│
├── Technical
│   ├── API_INTEGRATION.md
│   ├── networking.md
│   └── theming.md
│
├── Project Info
│   └── PROJECT_SUMMARY.md
│
└── archive/                         # Historical/outdated documentation
    ├── ARCHITECTURE_COMPARISON.md
    ├── CLEAN_ARCHITECTURE_SUMMARY.md
    ├── CLEAN_CODE_IMPROVEMENTS.md
    └── ... (17 archived files)
```

---

## 📋 Documentation Organization

### Current Documentation

Located in the `docs/` folder, organized by topic for easy navigation.

### Archived Documentation

Located in `docs/archive/` - Contains historical documents from development:

- Migration guides
- Refactoring plans
- Implementation progress logs
- Fix documentation
- Legacy configuration references

These are kept for historical reference but may contain outdated information.

---

## 🔄 Keeping Documentation Updated

When updating the project:

1. Update relevant topic-specific documentation
2. Update the main [COMPLETE_DOCUMENTATION.md](./COMPLETE_DOCUMENTATION.md)
3. Keep this README.md index up to date
4. Archive outdated documentation rather than deleting it

---

## 📝 Documentation Standards

All documentation follows these standards:

- Clear headings and structure
- Code examples where applicable
- File paths referenced with links
- Emoji icons for visual organization
- Up-to-date with current implementation

---

## 👥 Contributing to Documentation

When adding new features:

1. Document in the appropriate topic file
2. Update COMPLETE_DOCUMENTATION.md
3. Add references to this index
4. Include code examples
5. Link to relevant files

---

## 📞 Support

For questions about the documentation:

- Check the comprehensive [COMPLETE_DOCUMENTATION.md](./COMPLETE_DOCUMENTATION.md) first
- Search through topic-specific docs
- Review code examples in the documentation
- Check archived docs for historical context

---

## 👥 Team

Team 18 - Final Project

---

## 📄 License

This project is for educational purposes.

---

**Last Updated**: 2024-01-29
**Documentation Version**: 2.0.0
**Maintained By**: Team 18
