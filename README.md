# Team 18 Final Project - Fintech App

A modern Flutter fintech application with a comprehensive architecture setup, featuring cryptocurrency integration via CoinGecko API, clean architecture patterns, and full dark/light theme support.

## Table of Contents
- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Features Implemented](#features-implemented)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Architecture](#architecture)
- [Core Components](#core-components)
- [Environment Configuration](#environment-configuration)
- [Dependencies](#dependencies)
- [Development Guidelines](#development-guidelines)
- [Git Workflow](#git-workflow)

## Project Overview

This is a Flutter-based fintech application built with modern architecture patterns including:
- Clean Architecture principles
- Dependency Injection with GetIt
- State Management with BLoC/Provider
- Routing with GoRouter
- API integration with Retrofit + Dio
- Environment configuration management
- Comprehensive theming system

## Project Structure

```
lib/
├── core/                          # Core functionality and shared resources
│   ├── common_ui/                 # Reusable UI components
│   │   └── widgets/               # Custom widgets
│   │       ├── bottom_action_button.dart
│   │       ├── bottom_navigation.dart
│   │       ├── custom_back_button.dart
│   │       ├── custom_icon_with_bg.dart
│   │       └── custom_text_field.dart
│   ├── config/                    # App configuration
│   │   └── app_text_styles.dart   # Typography system
│   ├── di/                        # Dependency injection
│   │   └── di.dart                # GetIt setup
│   ├── error/                     # Error handling
│   │   ├── auth_error_msg.dart
│   │   └── failure.dart           # Failure classes
│   ├── networking/                # Network layer
│   │   ├── api_base_url.dart
│   │   ├── api_error_handler.dart
│   │   ├── dio_client.dart        # Dio configuration
│   │   └── endpoints.dart
│   ├── routing/                   # Navigation
│   │   ├── app_router.dart        # GoRouter setup
│   │   └── routes.dart            # Route constants
│   ├── storage/                   # Local storage
│   │   └── shared_prefs.dart
│   └── utils/                     # Utilities
│       ├── app_colors.dart        # Color palette
│       ├── app_theme.dart         # Theme configuration
│       ├── dark_theme.dart        # Dark theme
│       └── light_theme.dart       # Light theme
└── main.dart                      # App entry point
```

## Features Implemented

### 1. Theming System
- **Complete dark and light themes** with automatic system preference detection
- **Custom color palette** featuring:
  - Primary brand colors (blue and orange)
  - Comprehensive light/dark mode colors
  - Status colors (success, warning, error)
  - Price indicators (up/down)
- **Typography system** using Lato font family with 15+ text styles
- **System UI overlay** configuration for status bar/navigation bar

**Files:**
- [lib/core/utils/app_colors.dart](lib/core/utils/app_colors.dart)
- [lib/core/config/app_text_styles.dart](lib/core/config/app_text_styles.dart)
- [lib/core/utils/app_theme.dart](lib/core/utils/app_theme.dart)
- [lib/core/utils/dark_theme.dart](lib/core/utils/dark_theme.dart)
- [lib/core/utils/light_theme.dart](lib/core/utils/light_theme.dart)

### 2. Networking Layer
- **Dio HTTP client** with interceptors
- **CoinGecko API integration** for cryptocurrency data
- **Request/Response logging** (debug mode only)
- **Error handling** with rate limiting and authentication checks
- **Environment-based API key** management

**Files:**
- [lib/core/networking/dio_client.dart](lib/core/networking/dio_client.dart)
- [lib/core/networking/api_base_url.dart](lib/core/networking/api_base_url.dart)
- [lib/core/networking/endpoints.dart](lib/core/networking/endpoints.dart)
- [lib/core/networking/api_error_handler.dart](lib/core/networking/api_error_handler.dart)

### 3. Routing System
- **GoRouter** for declarative navigation
- **Route constants** for type-safe navigation
- **Error page** (404 handling)
- Ready for nested navigation and deep linking

**Files:**
- [lib/core/routing/app_router.dart](lib/core/routing/app_router.dart)
- [lib/core/routing/routes.dart](lib/core/routing/routes.dart)

### 4. Dependency Injection
- **GetIt** service locator configured
- Ready for feature modules
- Supports lazy and singleton registrations

**Files:**
- [lib/core/di/di.dart](lib/core/di/di.dart)

### 5. Reusable Widgets
Custom UI components built for the app:
- Bottom action buttons
- Bottom navigation
- Custom back button
- Icon with background
- Custom text fields

**Files:**
- [lib/core/common_ui/widgets/](lib/core/common_ui/widgets/)

### 6. Error Handling
- **Failure classes** using Equatable
  - `ServerFailure`
  - `CacheFailure`
  - `NetworkFailure`
  - `ValidationFailure`
  - `UnknownFailure`
- Auth-specific error messages

**Files:**
- [lib/core/error/failure.dart](lib/core/error/failure.dart)
- [lib/core/error/auth_error_msg.dart](lib/core/error/auth_error_msg.dart)

## Prerequisites

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **CoinGecko API Key**: Get from [https://www.coingecko.com/en/api/pricing](https://www.coingecko.com/en/api/pricing)

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd team_18_final_project
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment Variables
Create a `.env` file in the project root:
```bash
cp .env.example .env
```

Edit `.env` and add your CoinGecko API key:
```env
COINGECKO_API_KEY=your_actual_api_key_here
```

### 4. Run the App
```bash
flutter run
```

### 5. Run Tests
```bash
flutter test
```

## Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

### Layer Structure
```
Presentation Layer (UI + State Management)
        ↓
Domain Layer (Business Logic + Use Cases)
        ↓
Data Layer (Repositories + Data Sources)
        ↓
Core Layer (Shared Resources)
```

### Design Patterns Used
- **Repository Pattern**: For data abstraction
- **Dependency Injection**: Using GetIt for loose coupling
- **BLoC/Provider**: For state management
- **Either Pattern**: Using Dartz for functional error handling
- **Factory Pattern**: For creating service instances

## Core Components

### Color System
**Light Mode:**
- Background: `#F5F8FE`
- Surface: `#FFFFFF`
- Primary: `#1D3A70` (brand blue)
- Secondary: `#F56C2A` (orange accent)

**Dark Mode:**
- Background: `#0D0D0D`
- Surface: `#1B1B1B`
- Card: `#27292A`
- Text: `#FFFFFF` / `#E2E3E4`

### Typography Scale
- **Display**: 28-32px (portfolio balances)
- **Headline**: 18-24px (screen titles)
- **Title**: 14-16px (section titles)
- **Body**: 12-16px (content)
- **Label**: 10-14px (buttons, tags)

### Network Configuration
- **Base URL**: `https://api.coingecko.com/api/v3`
- **Timeout**: 30 seconds (connect & receive)
- **Headers**: JSON accept + CoinGecko API key
- **Interceptors**: Logging, error handling, API key injection

## Environment Configuration

The app uses `flutter_dotenv` for environment variable management:

### Required Variables
| Variable | Description | Required |
|----------|-------------|----------|
| `COINGECKO_API_KEY` | CoinGecko API authentication key | Yes |

### Security Notes
- Never commit `.env` file to version control
- `.env` is listed in `.gitignore`
- Use `.env.example` as a template
- API key is automatically injected via Dio interceptor

## Dependencies

### Production Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^9.1.1 | State management |
| `provider` | ^6.1.2 | State management alternative |
| `get_it` | ^8.2.0 | Dependency injection |
| `go_router` | ^16.2.4 | Navigation |
| `dio` | ^5.9.0 | HTTP client |
| `retrofit` | ^4.7.3 | Type-safe API calls |
| `dartz` | ^0.10.1 | Functional programming |
| `equatable` | ^2.0.7 | Value equality |
| `shared_preferences` | ^2.5.3 | Local storage |
| `flutter_dotenv` | ^5.2.1 | Environment variables |
| `flutter_svg` | ^2.2.1 | SVG support |
| `carousel_slider` | ^5.1.1 | Carousel widgets |
| `json_annotation` | ^4.9.0 | JSON serialization |

### Dev Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.7.1 | Code generation |
| `json_serializable` | ^6.11.1 | JSON code gen |
| `retrofit_generator` | ^10.0.6 | Retrofit code gen |
| `flutter_lints` | ^5.0.0 | Linting rules |
| `mocktail` | ^1.0.4 | Mocking for tests |
| `bloc_test` | ^10.0.0 | BLoC testing utilities |

## Development Guidelines

### Code Style
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter_lints` rules (already configured)
- Run `flutter analyze` before committing

### Naming Conventions
- **Files**: snake_case (e.g., `app_colors.dart`)
- **Classes**: PascalCase (e.g., `AppColors`)
- **Variables/Functions**: camelCase (e.g., `buildDarkTheme`)
- **Constants**: camelCase (e.g., `lightBackground`)

### Adding New Features
1. Create feature folder under `lib/features/`
2. Follow structure: `presentation/`, `domain/`, `data/`
3. Register dependencies in `di.dart`
4. Add routes in `app_router.dart`
5. Write unit tests

### Commit Message Format
```
feat: add user authentication
fix: resolve login button state issue
docs: update README with API setup
style: format code according to dart style
refactor: extract common widgets
test: add unit tests for login bloc
```

## Git Workflow

### Branches
- `develop`: Main development branch
- `feature/*`: Feature branches
- `bugfix/*`: Bug fix branches
- `hotfix/*`: Production hotfixes

### Workflow
1. Create feature branch from `develop`
   ```bash
   git checkout -b feature/user-profile
   ```

2. Make changes and commit
   ```bash
   git add .
   git commit -m "feat: add user profile screen"
   ```

3. Push and create pull request
   ```bash
   git push origin feature/user-profile
   ```

4. Merge to `develop` after review

### Recent Commits
- `3201049` - feat: add core structure, theme, text styles, env setup, gitignore
- `696ed61` - chore: ignore VS Code folder
- `8520492` - Resolve merge conflicts and add final Flutter project
- `d42ca26` - Initial Flutter project setup

## Next Steps

### TODO for Team Members

#### High Priority
1. Implement authentication feature (login/signup)
2. Create home screen with main navigation
3. Add cryptocurrency listing screen
4. Implement portfolio management
5. Setup API service with Retrofit annotations

#### Medium Priority
6. Add local database (Hive/Floor)
7. Implement user preferences storage
8. Create transaction history screen
9. Add chart/graph widgets
10. Setup push notifications

#### Low Priority
11. Add biometric authentication
12. Implement multi-language support
13. Add analytics tracking
14. Create onboarding flow
15. Write comprehensive tests

## Troubleshooting

### Common Issues

**Issue: `.env` file not loading**
```dart
// Check console for warning message:
⚠️ Warning: Failed to load .env file
```
**Solution**: Ensure `.env` exists in project root and contains valid key-value pairs

**Issue: API requests failing with 401**
```dart
🚫 Unauthorized. API key might be invalid or missing.
```
**Solution**: Verify `COINGECKO_API_KEY` in `.env` is correct

**Issue: Font not loading**
**Solution**: Run `flutter clean && flutter pub get`

**Issue: Build fails after pulling**
**Solution**: Run `flutter pub get` and `flutter pub run build_runner build --delete-conflicting-outputs`

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [CoinGecko API Documentation](https://docs.coingecko.com/reference/introduction)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [BLoC Pattern Guide](https://bloclibrary.dev/)

## Team Information

**Project**: Team 18 Final Project
**Repository**: team_18_final_project
**Current Branch**: develop

## License

See [LICENSE](LICENSE) file for details.

---

**Last Updated**: November 20, 2024

For questions or issues, please contact the team or create an issue in the repository.
