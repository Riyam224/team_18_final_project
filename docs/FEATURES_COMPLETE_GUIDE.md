# Features - Complete Reference Guide

This document provides a comprehensive overview of all application features, their implementation, usage, and architecture.

---

## Table of Contents

- [Overview](#overview)
- [Feature Architecture](#feature-architecture)
- [Authentication & Security](#authentication--security)
- [Splash & Onboarding](#splash--onboarding)
- [Home Dashboard](#home-dashboard)
- [Market & Trading](#market--trading)
- [Portfolio Management](#portfolio-management)
- [User Profile & Settings](#user-profile--settings)
- [Transaction Management](#transaction-management)
- [Feature-Specific Documentation](#feature-specific-documentation)

---

## Overview

The application is organized using **feature-based architecture**. Each feature is a self-contained module with its own:

- Presentation layer (UI, screens, cubits)
- Domain layer (use cases, entities, repositories)
- Data layer (data sources, models, implementations)

### Feature Modules

```
lib/features/
├── auth/              # Authentication & biometric login
├── splash/            # Splash screen
├── onboarding/        # User onboarding flow
├── home/              # Dashboard & market overview
├── market/            # Crypto market & trading
├── portfolio/         # User portfolio management
├── profile/           # User profile
├── settings/          # App settings
└── transactions/      # Transaction history
```

---

## Feature Architecture

Each feature follows **Clean Architecture**:

```
lib/features/[feature_name]/
├── presentation/
│   ├── screens/       # UI screens
│   ├── widgets/       # Feature-specific widgets
│   └── cubits/        # State management (BLoC/Cubit)
├── domain/
│   ├── entities/      # Business models
│   ├── repositories/  # Repository interfaces
│   ├── usecases/      # Business logic
│   ├── failures/      # Feature-specific errors
│   └── validation/    # Domain validation logic
└── data/
    ├── models/        # Data models (JSON serializable)
    ├── datasources/   # API/local data sources
    ├── repositories/  # Repository implementations
    └── mappers/       # Entity ↔ Model mapping
```

### Dependency Flow

```
Presentation → Domain → Data → Core

Screens/Widgets
    ↓ use
Cubits
    ↓ call
Use Cases
    ↓ use
Repositories (interface)
    ↑ implement
Repository Implementations
    ↓ use
Data Sources
    ↓ use
Core Services (DI, Networking, Security)
```

---

## Authentication & Security

**Location**: `lib/features/auth/`

### Features

1. **Email/Password Registration**
2. **Biometric Setup** (Fingerprint / Face ID)
3. **Email/Password Login**
4. **Biometric Login**
5. **App Lock / Unlock**
6. **Session Management**
7. **Secure Credential Storage**

### Architecture

#### Presentation Layer

**Screens**:

**Registration Flow**:
- [presentation/screens/register/register_screen.dart](../lib/features/auth/presentation/screens/register/register_screen.dart)
- [presentation/screens/register/fingerprint_setup_register_screen.dart](../lib/features/auth/presentation/screens/register/fingerprint_setup_register_screen.dart)
- [presentation/screens/register/faceid_setup_register_screen.dart](../lib/features/auth/presentation/screens/register/faceid_setup_register_screen.dart)
- [presentation/screens/register/fingerprint_success_register_screen.dart](../lib/features/auth/presentation/screens/register/fingerprint_success_register_screen.dart)
- [presentation/screens/register/faceid_success_register_screen.dart](../lib/features/auth/presentation/screens/register/faceid_success_register_screen.dart)

**Login Flow**:
- [presentation/screens/login/login_screen.dart](../lib/features/auth/presentation/screens/login/login_screen.dart)
- [presentation/screens/login/fingerprint_verify_login_screen.dart](../lib/features/auth/presentation/screens/login/fingerprint_verify_login_screen.dart)
- [presentation/screens/login/faceid_scanning_login_screen.dart](../lib/features/auth/presentation/screens/login/faceid_scanning_login_screen.dart)
- [presentation/screens/login/fingerprint_verify_success_login_screen.dart](../lib/features/auth/presentation/screens/login/fingerprint_verify_success_login_screen.dart)

**Security Screens**:
- [presentation/screens/security_screens/app_lock_screen.dart](../lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart) - Auto-lock unlock screen
- [presentation/screens/security_screens/root_warning_screen.dart](../lib/features/auth/presentation/screens/security_screens/root_warning_screen.dart) - Root/jailbreak warning

**State Management**:
- [presentation/cubits/auth_cubit/auth_cubit.dart](../lib/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart) - Login/register logic
- [presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart](../lib/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart) - Biometric registration
- [presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart](../lib/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart) - Biometric login

#### Domain Layer

**Entities**:
- [domain/entities/user_entity.dart](../lib/features/auth/domain/entities/user_entity.dart) - User data model
- [domain/entities/auth_session_entity.dart](../lib/features/auth/domain/entities/auth_session_entity.dart) - Session data
- [domain/entities/biometric_credentials_entity.dart](../lib/features/auth/domain/entities/biometric_credentials_entity.dart) - Biometric credentials
- [domain/entities/user_profile_entity.dart](../lib/features/auth/domain/entities/user_profile_entity.dart) - User profile
- [domain/entities/user_settings_entity.dart](../lib/features/auth/domain/entities/user_settings_entity.dart) - User settings

**Use Cases**:
- [domain/usecases/login_user_usecase.dart](../lib/features/auth/domain/usecases/login_user_usecase.dart)
- [domain/usecases/register_user_usecase.dart](../lib/features/auth/domain/usecases/register_user_usecase.dart)
- [domain/usecases/biometric_login_usecase.dart](../lib/features/auth/domain/usecases/biometric_login_usecase.dart)
- [domain/usecases/store_biometric_settings_usecase.dart](../lib/features/auth/domain/usecases/store_biometric_settings_usecase.dart)
- [domain/usecases/store_user_credentials_usecase.dart](../lib/features/auth/domain/usecases/store_user_credentials_usecase.dart)

**Validation**:
- [domain/validation/email_validator.dart](../lib/features/auth/domain/validation/email_validator.dart)
- [domain/validation/password_validator.dart](../lib/features/auth/domain/validation/password_validator.dart)
- [domain/validation/name_validator.dart](../lib/features/auth/domain/validation/name_validator.dart)
- [domain/validation/phone_validator.dart](../lib/features/auth/domain/validation/phone_validator.dart)

**Failures**:
- [domain/failures/auth_failure.dart](../lib/features/auth/domain/failures/auth_failure.dart)
- [domain/failures/biometric_failure.dart](../lib/features/auth/domain/failures/biometric_failure.dart)
- [domain/failures/session_failure.dart](../lib/features/auth/domain/failures/session_failure.dart)

#### Data Layer

**Data Sources**:
- [data/datasources/auth_remote_datasource.dart](../lib/features/auth/data/datasources/auth_remote_datasource.dart) - Firebase Auth
- [data/datasources/auth_local_datasource.dart](../lib/features/auth/data/datasources/auth_local_datasource.dart) - Secure storage
- [data/datasources/firebase_user_service.dart](../lib/features/auth/data/datasources/firebase_user_service.dart) - Firestore user data

**Repository**:
- [data/repositories/auth_repository_impl.dart](../lib/features/auth/data/repositories/auth_repository_impl.dart)

**Models**:
- [data/models/user_model.dart](../lib/features/auth/data/models/user_model.dart)
- [data/models/auth_session.dart](../lib/features/auth/data/models/auth_session.dart)
- [data/models/user_profile.dart](../lib/features/auth/data/models/user_profile.dart)

### Firebase Integration

Uses Firebase for authentication backend:
- **Firebase Auth**: Email/password authentication
- **Cloud Firestore**: User profile and settings storage
- **Secure Storage**: Encrypted local storage for credentials

Configuration:
- [firebase_options.dart](../lib/firebase_options.dart) - Auto-generated Firebase config
- Platform-specific configs in `android/` and `ios/` directories

---

## Splash & Onboarding

### Splash Screen

**Location**: `lib/features/splash/`

**Features**:
- App logo animation
- Smart navigation based on app state:
  - First launch → Onboarding
  - Not authenticated → Login
  - Authenticated → Home

**Implementation**:
- [presentation/screens/splash_screen.dart](../lib/features/splash/presentation/screens/splash_screen.dart)

### Onboarding

**Location**: `lib/features/onboarding/`

**Features**:
- 4-page onboarding flow
- Skip functionality
- Next/Previous navigation
- Final CTA to sign up

**Implementation**:
- [presentation/screens/onboarding_screen.dart](../lib/features/onboarding/presentation/screens/onboarding_screen.dart)
- [presentation/widgets/onboarding_page.dart](../lib/features/onboarding/presentation/widgets/onboarding_page.dart)
- [presentation/widgets/onboarding_indicator.dart](../lib/features/onboarding/presentation/widgets/onboarding_indicator.dart)

**Data**:
- [data/models/onboarding_model.dart](../lib/features/onboarding/data/models/onboarding_model.dart)

---

## Home Dashboard

**Location**: `lib/features/home/`

### Features

1. **Portfolio Balance** - Total portfolio value with percentage change
2. **Market Overview** - Global crypto market statistics
3. **Trending Coins** - Currently trending cryptocurrencies
4. **Top Gainers** - Best performing coins in 24h

### Architecture

#### Presentation Layer

**Screens**:
- [presentation/screens/home_screen.dart](../lib/features/home/presentation/screens/home_screen.dart)

**Widgets**:
- [presentation/widgets/balance_card.dart](../lib/features/home/presentation/widgets/balance_card.dart)
- [presentation/widgets/market_overview_grid.dart](../lib/features/home/presentation/widgets/market_overview_grid.dart)
- [presentation/widgets/trending_now_list.dart](../lib/features/home/presentation/widgets/trending_now_list.dart)
- [presentation/widgets/top_gainers_list.dart](../lib/features/home/presentation/widgets/top_gainers_list.dart)
- [presentation/widgets/home_header.dart](../lib/features/home/presentation/widgets/home_header.dart)

**State Management**:
- [presentation/cubit/home_cubit.dart](../lib/features/home/presentation/cubit/home_cubit.dart)
- [presentation/cubit/home_state.dart](../lib/features/home/presentation/cubit/home_state.dart)

#### Domain Layer

**Entities**:
- [domain/entities/portfolio_balance.dart](../lib/features/home/domain/entities/portfolio_balance.dart)
- [domain/entities/market_overview.dart](../lib/features/home/domain/entities/market_overview.dart)
- [domain/entities/trending_coin.dart](../lib/features/home/domain/entities/trending_coin.dart)
- [domain/entities/top_gainer.dart](../lib/features/home/domain/entities/top_gainer.dart)

**Use Cases**:
- [domain/usecases/get_portfolio_balance_usecase.dart](../lib/features/home/domain/usecases/get_portfolio_balance_usecase.dart)
- [domain/usecases/get_market_overview_usecase.dart](../lib/features/home/domain/usecases/get_market_overview_usecase.dart)
- [domain/usecases/get_trending_coins_usecase.dart](../lib/features/home/domain/usecases/get_trending_coins_usecase.dart)
- [domain/usecases/get_top_gainers_usecase.dart](../lib/features/home/domain/usecases/get_top_gainers_usecase.dart)

**Repository Interface**:
- [domain/repositories/home_repository.dart](../lib/features/home/domain/repositories/home_repository.dart)

#### Data Layer

**Data Sources**:
- [data/data_sources/home_api_service.dart](../lib/features/home/data/data_sources/home_api_service.dart) - Retrofit API service
- [data/data_sources/home_api_service.g.dart](../lib/features/home/data/data_sources/home_api_service.g.dart) - Generated code

**Models**:
- [data/models/global_data_model.dart](../lib/features/home/data/models/global_data_model.dart)
- [data/models/trending_coin_model.dart](../lib/features/home/data/models/trending_coin_model.dart)
- [data/models/top_gainer_model.dart](../lib/features/home/data/models/top_gainer_model.dart)

**Repository Implementation**:
- [data/repositories/home_repository_impl.dart](../lib/features/home/data/repositories/home_repository_impl.dart)

### API Integration

Uses **CoinGecko API** for live market data:

```dart
@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio) = _HomeApiService;

  @GET('/coins/markets')
  Future<List<CoinModel>> getMarkets(
    @Query('vs_currency') String currency,
  );

  @GET('/search/trending')
  Future<TrendingResponse> getTrending();
}
```

API key configuration via environment variables:
```bash
flutter run --dart-define=COINGECKO_API_KEY=your_key
```

---

## Market & Trading

**Location**: `lib/features/market/`

### Features

1. **Market Screen** - Browse all cryptocurrencies
2. **Coin Details** - Detailed coin information
3. **Buy/Sell Screen** - Trading interface
4. **Payment Screen** - Complete purchase

### Screens

- [presentation/screens/market_screen.dart](../lib/features/market/presentation/screens/market_screen.dart)
- [presentation/screens/coin_details_screen.dart](../lib/features/market/presentation/screens/coin_details_screen.dart)
- [presentation/screens/buy_sell_screen.dart](../lib/features/market/presentation/screens/buy_sell_screen.dart)
- [presentation/screens/payment_screen.dart](../lib/features/market/presentation/screens/payment_screen.dart)

### Navigation

```dart
// Navigate to coin details
context.go('/coin-details/${coinId}');

// Navigate to buy/sell
context.go('/buy-sell/${coinId}');

// Navigate to payment
context.go('/payment');
```

### Security

All market screens are **sensitive routes** with:
- Screenshot prevention enabled
- Background blur enabled
- Secure navigation

---

## Portfolio Management

**Location**: `lib/features/portfolio/`

### Features

1. **Holdings Overview** - All owned cryptocurrencies
2. **Performance Tracking** - Profit/loss calculation
3. **Asset Allocation** - Portfolio distribution
4. **Transaction History** - Recent trades

### Implementation

**Screens**:
- [presentation/screens/portfolio_screen.dart](../lib/features/portfolio/presentation/screens/portfolio_screen.dart)

---

## User Profile & Settings

### Profile

**Location**: `lib/features/profile/`

**Features**:
- View user information
- Edit profile details
- Account management

**Implementation**:
- [presentation/screens/profile_screen.dart](../lib/features/profile/presentation/screens/profile_screen.dart)
- [presentation/cubit/profile_cubit.dart](../lib/features/profile/presentation/cubit/profile_cubit.dart)

### Settings

**Location**: `lib/features/settings/`

**Features**:
- Security settings
- Auto-lock timeout configuration
- Session timeout configuration
- Biometric toggle
- Theme preferences
- Notification settings

**Implementation**:
- [presentation/screens/settings_screen.dart](../lib/features/settings/presentation/screens/settings_screen.dart)

---

## Transaction Management

**Location**: `lib/features/transactions/`

### Features

1. **Transaction History** - All past transactions
2. **Encrypted Storage** - Secure transaction records
3. **Transaction Details** - View full transaction info
4. **Clear History** - Remove all transactions

### Architecture

#### Domain Layer

**Entities**:
- [domain/entities/transaction_record.dart](../lib/features/transactions/domain/entities/transaction_record.dart)

**Repository Interface**:
- [domain/repositories/transaction_repository.dart](../lib/features/transactions/domain/repositories/transaction_repository.dart)

**Use Cases**:
- [domain/usecases/get_transactions_usecase.dart](../lib/features/transactions/domain/usecases/get_transactions_usecase.dart)
- [domain/usecases/add_transaction_usecase.dart](../lib/features/transactions/domain/usecases/add_transaction_usecase.dart)
- [domain/usecases/clear_transactions_usecase.dart](../lib/features/transactions/domain/usecases/clear_transactions_usecase.dart)

#### Data Layer

**Data Source**:
- [data/datasources/encrypted_transaction_data_source.dart](../lib/features/transactions/data/datasources/encrypted_transaction_data_source.dart)

Uses **AES-256 encryption** for all transaction data.

**Repository Implementation**:
- [data/repositories/transaction_repository_impl.dart](../lib/features/transactions/data/repositories/transaction_repository_impl.dart)

### Security

Transaction data is:
- ✅ Encrypted at rest (AES-256)
- ✅ Stored in secure storage
- ✅ Never logged or exposed
- ✅ Cleared on logout

---

## Feature-Specific Documentation

For more detailed information on specific features, see:

### Authentication
- [AUTH_FLOW.md](AUTH_FLOW.md) - Detailed authentication flow
- [SECURITY_FEATURES_OVERVIEW.md](SECURITY_FEATURES_OVERVIEW.md) - Security features

### UI/UX
- [SPLASH_ONBOARDING.md](SPLASH_ONBOARDING.md) - Splash and onboarding implementation
- [splash.md](splash.md) - Splash screen details
- [onboarding.md](onboarding.md) - Onboarding flow details
- [theming.md](theming.md) - Theme system

### Technical
- [API_INTEGRATION.md](API_INTEGRATION.md) - CoinGecko API integration
- [networking.md](networking.md) - Network layer details
- [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md) - BLoC/Cubit patterns

### Architecture
- [ARCHITECTURE.md](ARCHITECTURE.md) - Clean Architecture details
- [CORE_ARCHITECTURE_GUIDE.md](CORE_ARCHITECTURE_GUIDE.md) - Core layer reference
- [FILE_STRUCTURE.md](FILE_STRUCTURE.md) - Project organization

---

## Adding a New Feature

### Step-by-Step Guide

1. **Create Feature Directory**:
   ```
   lib/features/new_feature/
   ├── presentation/
   ├── domain/
   └── data/
   ```

2. **Define Domain Layer** (business logic first):
   ```dart
   // domain/entities/new_entity.dart
   class NewEntity {
     final String id;
     final String name;
     NewEntity({required this.id, required this.name});
   }

   // domain/repositories/new_repository.dart
   abstract class NewRepository {
     Future<Either<Failure, NewEntity>> getData();
   }

   // domain/usecases/get_data_usecase.dart
   class GetDataUseCase {
     final NewRepository repository;
     GetDataUseCase(this.repository);

     Future<Either<Failure, NewEntity>> call() {
       return repository.getData();
     }
   }
   ```

3. **Implement Data Layer**:
   ```dart
   // data/models/new_model.dart
   class NewModel {
     final String id;
     final String name;

     NewModel({required this.id, required this.name});

     factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(
       id: json['id'],
       name: json['name'],
     );

     NewEntity toEntity() => NewEntity(id: id, name: name);
   }

   // data/datasources/new_datasource.dart
   class NewDataSource {
     final Dio dio;
     NewDataSource(this.dio);

     Future<NewModel> fetchData() async {
       final response = await dio.get('/endpoint');
       return NewModel.fromJson(response.data);
     }
   }

   // data/repositories/new_repository_impl.dart
   class NewRepositoryImpl implements NewRepository {
     final NewDataSource dataSource;
     NewRepositoryImpl(this.dataSource);

     @override
     Future<Either<Failure, NewEntity>> getData() async {
       try {
         final model = await dataSource.fetchData();
         return Right(model.toEntity());
       } catch (e) {
         return Left(ServerFailure(message: e.toString()));
       }
     }
   }
   ```

4. **Create Presentation Layer**:
   ```dart
   // presentation/cubit/new_cubit.dart
   class NewCubit extends Cubit<NewState> {
     final GetDataUseCase getDataUseCase;

     NewCubit(this.getDataUseCase) : super(NewInitial());

     Future<void> loadData() async {
       emit(NewLoading());
       final result = await getDataUseCase();
       result.fold(
         (failure) => emit(NewError(failure.message)),
         (data) => emit(NewLoaded(data)),
       );
     }
   }

   // presentation/screens/new_screen.dart
   class NewScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return BlocProvider(
         create: (_) => sl<NewCubit>()..loadData(),
         child: BlocBuilder<NewCubit, NewState>(
           builder: (context, state) {
             if (state is NewLoading) return CircularProgressIndicator();
             if (state is NewError) return Text(state.message);
             if (state is NewLoaded) return Text(state.data.name);
             return SizedBox();
           },
         ),
       );
     }
   }
   ```

5. **Register in DI** ([lib/core/di/di.dart](../lib/core/di/di.dart)):
   ```dart
   Future<void> _setupNewFeature() async {
     // Data source
     sl.registerLazySingleton<NewDataSource>(
       () => NewDataSource(sl<Dio>()),
     );

     // Repository
     sl.registerLazySingleton<NewRepository>(
       () => NewRepositoryImpl(sl<NewDataSource>()),
     );

     // Use case
     sl.registerLazySingleton(() => GetDataUseCase(sl<NewRepository>()));

     // Cubit
     sl.registerFactory(() => NewCubit(sl<GetDataUseCase>()));
   }
   ```

6. **Add Route** ([lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart)):
   ```dart
   GoRoute(
     path: AppRoutes.newFeature,
     builder: (_, __) => const NewScreen(),
   ),
   ```

7. **Test**:
   - Write unit tests for domain layer
   - Write widget tests for presentation
   - Write integration tests for full flow

---

## Summary

The application features:

### ✅ Core Features
- Authentication (email/password + biometric)
- User registration with biometric setup
- Secure session management
- App lock/unlock

### ✅ Market Features
- Live cryptocurrency market data
- Trending coins and top gainers
- Coin details and charts
- Buy/sell trading interface

### ✅ Portfolio Features
- Holdings overview
- Performance tracking
- Transaction history

### ✅ User Features
- Profile management
- Settings configuration
- Theme customization

### ✅ Security Features
- End-to-end encryption
- Screenshot prevention
- Root/jailbreak detection
- Audit logging

All features follow Clean Architecture, are fully testable, and integrate seamlessly with the core layer.

---

## Related Documentation

- [Security Features Overview](SECURITY_FEATURES_OVERVIEW.md)
- [Core Architecture Guide](CORE_ARCHITECTURE_GUIDE.md)
- [Authentication Flow](AUTH_FLOW.md)
- [API Integration](API_INTEGRATION.md)
- [Architecture Guide](ARCHITECTURE.md)
