# Cryptocurrency Tracking App - Complete Documentation

## 📚 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Design Patterns](#architecture--design-patterns)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Features](#features)
6. [Getting Started](#getting-started)
7. [Documentation Index](#documentation-index)

---

## 🎯 Project Overview

**Team 18 Final Project** is a modern Flutter application for tracking cryptocurrency market data in real-time. The app provides users with comprehensive market insights, trending coins, top gainers, and portfolio tracking functionality.

### Key Capabilities
- 📊 **Global Market Overview** - View total market cap, 24h volume, and Bitcoin dominance
- 📈 **Trending Cryptocurrencies** - Discover coins with highest search volume and popularity
- 🚀 **Top Gainers** - Track cryptocurrencies with biggest 24h price increases
- 💰 **Portfolio Balance** - Monitor portfolio value and weekly performance
- 🔄 **Real-time Updates** - Pull-to-refresh for latest market data
- 🎨 **Modern UI** - Clean, responsive design with custom theming

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

## 📖 Documentation Index

For detailed information about specific aspects of the project:

1. **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Deep dive into Clean Architecture implementation
2. **[FILE_STRUCTURE.md](./FILE_STRUCTURE.md)** - Detailed explanation of every file
3. **[API_INTEGRATION.md](./API_INTEGRATION.md)** - API endpoints, models, and data flow
4. **[STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md)** - Bloc/Cubit pattern and state handling
5. **[WIDGET_GUIDE.md](./WIDGET_GUIDE.md)** - UI components and widget tree

---

## 👥 Team
Team 18 - Final Project

## 📄 License
This project is for educational purposes.

---

**Last Updated**: 2025
**Version**: 1.0.0
