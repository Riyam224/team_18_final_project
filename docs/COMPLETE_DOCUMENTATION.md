# Team 18 Fintech - Complete Technical Documentation

## 📱 Project Overview

Team 18 Fintech is a cryptocurrency portfolio management mobile application built with Flutter. The app provides real-time market data, portfolio tracking, and enterprise-grade security features including biometric authentication, session management, and app-level security controls.

---

## 🏗️ Architecture & Design Patterns

### Clean Architecture
The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared utilities and infrastructure
│   ├── config/             # App-wide configuration
│   ├── constants/          # Constant values (strings, colors, spacing)
│   ├── di/                 # Dependency Injection
│   ├── error/              # Error handling & failures
│   ├── networking/         # API clients & network layer
│   ├── routing/            # Navigation & routing
│   ├── security/           # Security services
│   └── utils/              # Utilities & helpers
│
└── features/               # Feature modules (Clean Architecture)
    ├── auth/              # Authentication & Authorization
    │   ├── data/          # Data sources, repositories, models
    │   ├── domain/        # Business logic, entities, use cases
    │   └── presentation/  # UI, state management (Cubits)
    │
    ├── home/              # Home screen & dashboard
    ├── market/            # Market data & cryptocurrency listings
    ├── portfolio/         # User portfolio management
    ├── settings/          # App settings & preferences
    ├── splash/            # Splash screen
    └── onboarding/        # User onboarding flow
```

### Design Patterns Used
- **Repository Pattern**: Abstracts data sources from business logic
- **Dependency Injection**: Using `get_it` for IoC container
- **BLoC/Cubit Pattern**: State management with `flutter_bloc`
- **Factory Pattern**: For creating service instances
- **Strategy Pattern**: For different authentication methods (email, biometric)
- **Observer Pattern**: For route changes and app lifecycle events

---

## 🔐 Authentication & Security

### 1. **Firebase Authentication**

#### Implementation
- **Location**: `lib/features/auth/`
- **Provider**: Firebase Authentication
- **Methods Supported**:
  - Email/Password authentication
  - Biometric authentication (Face ID/Touch ID/Fingerprint)

#### Key Features
```dart
// Firebase initialization
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

#### Registration Flow
1. User enters credentials (first name, last name, email, password, phone)
2. **Validation** performed using custom validators:
   - `NameValidator`: Validates first/last names (2-50 chars, letters/spaces/hyphens)
   - `PasswordValidator`: 8+ chars, uppercase, lowercase, digit, special char
   - `PhoneValidator`: Valid phone format with country code
3. Firebase creates user account
4. User profile stored in Firestore
5. Optional biometric setup offered

#### Login Flow
1. User enters email/password OR uses biometric
2. Firebase authenticates credentials
3. Session created and managed
4. User redirected to home screen

#### Biometric Authentication
- **File**: `lib/core/security/implementations/biometric_service_impl.dart`
- **Features**:
  - Checks device biometric availability
  - Supports Face ID (iOS), Touch ID (iOS), Fingerprint (Android)
  - Fallback to password if biometric fails
  - Secure credential storage in Flutter Secure Storage

```dart
// Biometric authentication check
final canAuthenticate = await _localAuth.canCheckBiometrics;
final isDeviceSupported = await _localAuth.isDeviceSupported();
```

### 2. **Session Management**

#### Implementation
- **Interface**: `ISessionManager`
- **Implementation**: `SessionManagerImpl`
- **Location**: `lib/core/security/implementations/session_manager_impl.dart`

#### Features
- **Session Timeout**: Configurable timeout (default: 30 minutes)
- **Activity Tracking**: Updates last activity timestamp on user interaction
- **Auto-logout**: Automatically logs out inactive users
- **Session Validation**: Checks if session is still valid before sensitive operations

```dart
// Session validation
final isValidResult = await _sessionManager.isSessionValid();
final hasValidSession = isValidResult.fold((_) => false, (valid) => valid);
```

#### Configuration
```dart
// TimingConfig
static const int sessionTimeoutMinutes = 30;
static const Duration sessionTimeout = Duration(minutes: 30);
static const Duration sessionPollInterval = Duration(seconds: 30);
```

### 3. **App Lock Service**

#### Implementation
- **Interface**: `IAppLockService`
- **Implementation**: `AppLockServiceImpl`
- **Location**: `lib/core/security/implementations/app_lock_service_impl.dart`

#### Features
- **Inactivity Lock**: Locks app after configured period of inactivity
- **Configurable Timeout**: User can set custom timeout (30s - 30min or Never)
- **Background Lock**: Locks app when moved to background
- **Biometric Unlock**: Requires biometric authentication to unlock

#### Lock Timeout Options
```dart
// Available in AppConstants
static const List<int> autoLockTimeoutOptions = [
  0,    // Never
  30,   // 30 seconds
  60,   // 1 minute
  300,  // 5 minutes
  600,  // 10 minutes
  1800, // 30 minutes
];
```

#### App Lock Screen
- **File**: `lib/features/auth/presentation/screens/security_screens/app_lock_screen.dart`
- Displays when app is locked
- Requires biometric authentication to unlock
- Dark background with centered unlock button

### 4. **Root/Jailbreak Detection**

#### Implementation
- **Interface**: `IRootDetectionService`
- **Implementation**: `RootDetectionServiceImpl`
- **Package**: `flutter_jailbreak_detection`

#### Features
- Detects rooted Android devices
- Detects jailbroken iOS devices
- Detects developer mode
- Shows warning to user if device is compromised
- Logs security events to audit log

```dart
// Security check on app launch
final result = await rootDetectionService.performSecurityCheck();
if (!securityCheck.isSecure) {
  // Show warning to user
  context.go('/root-warning');
}
```

### 5. **Screenshot Prevention**

#### Implementation
- **Service**: `ScreenshotPreventionServiceImpl`
- **Location**: `lib/core/security/implementations/screenshot_prevention_service_impl.dart`

#### Features
- Prevents screenshots on sensitive screens
- Blurs app content when app is in background (task switcher)
- Uses `secure_application` package

#### Protected Routes
```dart
// Example protected routes
static const List<String> protectedRoutes = [
  '/home',
  '/portfolio',
  '/settings',
];
```

### 6. **Secure Storage**

#### Implementation
- **Interface**: `ISecureStorage`
- **Implementation**: `SecureStorageImpl`
- **Package**: `flutter_secure_storage`

#### Features
- Encrypted key-value storage
- AES encryption on Android
- Keychain on iOS
- Stores sensitive data:
  - Authentication tokens
  - Biometric credentials
  - User preferences
  - Session data

#### Storage Keys
All storage keys centralized in `StorageKeysConfig`:
```dart
// Authentication Keys
static const String userId = 'user_id';
static const String authToken = 'auth_token';
static const String refreshToken = 'refresh_token';

// Biometric Keys
static const String biometricEnabled = 'biometric_enabled';
static const String biometricType = 'biometric_type';
static const String biometricEmail = 'biometric_email';
static const String biometricPassword = 'biometric_password';

// Session Keys
static const String sessionId = 'session_id';
static const String lastActivityTime = 'last_activity_time';
```

### 7. **Audit Logging**

#### Implementation
- **Interface**: `IAuditLogService`
- **Implementation**: `AuditLogServiceImpl`

#### Features
- Logs security-related events
- Tracks user actions
- Timestamped entries
- Exportable logs

#### Logged Events
- Login/logout
- Biometric authentication attempts
- Session timeouts
- Root/jailbreak detection
- Failed authentication attempts
- Security setting changes

---

## 🏠 Home Screen & Dashboard

### Architecture
- **Location**: `lib/features/home/`
- **Pattern**: Clean Architecture (Data → Domain → Presentation)
- **State Management**: Cubit (flutter_bloc)

### Data Layer

#### API Service
- **File**: `lib/features/home/data/data_sources/home_api_service.dart`
- **API**: CoinGecko API v3
- **Endpoints**:
  - `/global` - Global market data
  - `/search/trending` - Trending coins
  - `/coins/markets` - Market data for specific coins

#### Repository Implementation
- **File**: `lib/features/home/data/repositories/home_repository_impl.dart`
- **Caching**: 30-second cache for global data to prevent duplicate API calls
- **Error Handling**: Comprehensive error handling with custom failure types

```dart
// Cache implementation
static const Duration marketDataCacheDuration = Duration(seconds: 30);

if (_cachedGlobalData != null &&
    _cacheTimestamp != null &&
    now.difference(_cacheTimestamp!) < marketDataCacheDuration) {
  return _cachedGlobalData; // Return cached data
}
```

### Domain Layer

#### Entities
```dart
// MarketOverview
class MarketOverview {
  final String totalMarketCap;
  final String totalVolume;
  final double btcDominance;
  final int activeCryptocurrencies;
}

// TrendingCoin
class TrendingCoin {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final int marketCapRank;
}

// PortfolioBalance
class PortfolioBalance {
  final double totalBalance;
  final double weeklyChangePercentage;
}
```

#### Use Cases
- `GetMarketOverviewUseCase` - Fetches global market statistics
- `GetTrendingCoinsUseCase` - Fetches trending cryptocurrencies
- `GetTopGainersUseCase` - Fetches top performing coins
- `GetPortfolioBalanceUseCase` - Calculates user's portfolio value

### Presentation Layer

#### Home Cubit
- **File**: `lib/features/home/presentation/cubits/home_cubit/home_cubit.dart`
- **States**:
  - `HomeInitial` - Initial state
  - `HomeLoading` - Data loading
  - `HomeLoaded` - Data successfully loaded
  - `HomeError` - Error occurred

```dart
// State management
void loadHomeData() async {
  emit(HomeLoading());

  final results = await Future.wait([
    _getMarketOverviewUseCase(),
    _getTrendingCoinsUseCase(),
    _getTopGainersUseCase(),
    _getPortfolioBalanceUseCase(),
  ]);

  emit(HomeLoaded(/* ... */));
}
```

#### UI Components

**Balance Card** (`lib/features/home/presentation/widgets/balance_card.dart`)
- Displays user's total portfolio balance
- Shows weekly profit/loss percentage
- Color-coded green (profit) / red (loss)
- Fallback values for offline/demo mode

**Market Overview Card** (`lib/features/home/presentation/widgets/market_overview_card.dart`)
- Total market cap
- 24h trading volume
- Bitcoin dominance percentage
- Active cryptocurrencies count

**Trending Coins List**
- Horizontal scrollable list
- Coin image, name, symbol
- Current price
- 24h price change
- Market cap rank

**Top Gainers List**
- Vertical list of best performers
- Price information
- Percentage gains
- Quick access to coin details

### User Greeting
```dart
// Personalized greeting based on time of day
String greetingTemplate(String userName) => "Hi, $userName 👋";
```

---

## 🧭 Bottom Navigation Bar

### Implementation
- **Location**: `lib/core/routing/app_router.dart`
- **Package**: `go_router` with `StatefulShellRoute`
- **Type**: Stateful navigation with preserved state

### Navigation Structure

#### Tabs
1. **Home** (`/home`)
   - Dashboard with market overview
   - Portfolio balance
   - Trending coins
   - Top gainers

2. **Market** (`/market`)
   - Full cryptocurrency listings
   - Search functionality
   - Sorting and filtering
   - Real-time price updates

3. **Portfolio** (`/portfolio`)
   - User's holdings
   - Asset allocation
   - Performance tracking
   - Transaction history

4. **Settings** (`/settings`)
   - Profile management
   - Security settings
   - Biometric toggle
   - Auto-lock configuration
   - Logout

### Custom Bottom Navigation Bar
- **File**: `lib/core/common_ui/navigation/custom_bottom_navigation_bar.dart`
- **Design**: Custom icons and styling
- **Theme**: Adapts to light/dark mode
- **State**: Highlights active tab
- **Animation**: Smooth transitions between tabs

```dart
// Navigation configuration
final GoRouter router = GoRouter(
  navigatorKey: appNavigatorKey,
  observers: [appRouteObserver],
  initialLocation: AppRoutes.splash,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [/* Home */]),
        StatefulShellBranch(routes: [/* Market */]),
        StatefulShellBranch(routes: [/* Portfolio */]),
        StatefulShellBranch(routes: [/* Settings */]),
      ],
    ),
  ],
);
```

### State Preservation
- Each tab maintains its own navigation stack
- Scroll positions preserved when switching tabs
- Form data retained
- Network requests not repeated unnecessarily

---

## 🎨 Theme System (Light & Dark Mode)

### Implementation
- **File**: `lib/core/utils/app_theme.dart`
- **Package**: Material 3 theming
- **Mode**: System-based (follows device settings)

### Color System

#### AppColors (`lib/core/utils/app_colors.dart`)

**Brand Colors**
```dart
static const Color primary = Color(0xFF1D3A70);    // Navy blue
static const Color secondary = Color(0xFFF56C2A);  // Orange accent
```

**Light Mode**
```dart
static const Color lightBackground = Color(0xFFF5F8FE);
static const Color lightSurface = Color(0xFFFFFFFF);
static const Color textBlack = Color(0xFF152C07);
static const Color textGray = Color(0xFF494D58);
```

**Dark Mode**
```dart
static const Color darkBackground = Color(0xFF0D0D0D);
static const Color darkBackground2 = Color(0xFF121212);
static const Color darkSurface = Color(0xFF1B1B1B);
static const Color textWhite = Color(0xFFFFFFFF);
static const Color textWhiteSoft = Color(0xFFE2E3E4);
```

**Price Indicators**
```dart
static const Color priceUp = Color(0xFF00CB6A);    // Green
static const Color priceDown = Color(0xFFF26666);  // Red
```

**Cryptocurrency Colors**
```dart
static const Color btcOrange = Color(0xFFF7931A);
static const Color ethBlue = Color(0xFF627EEA);
static const Color bnbYellow = Color(0xFFF3BA2F);
static const Color adaBlue = Color(0xFF0033AD);
static const Color solGreen = Color(0xFF14F195);
```

### Typography

#### AppTextStyles (`lib/core/config/app_text_styles.dart`)

**Display Styles** (Large numbers, balances)
```dart
static const TextStyle displayLarge = TextStyle(
  fontFamily: 'Lato',
  fontSize: 32,
  fontWeight: FontWeight.w700,
);
```

**Headlines** (Screen titles)
```dart
static const TextStyle headlineLarge = TextStyle(
  fontFamily: 'Lato',
  fontSize: 24,
  fontWeight: FontWeight.w700,
);
```

**Body Text**
```dart
static const TextStyle bodyLarge = TextStyle(
  fontFamily: 'Lato',
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
```

**Authentication Screens**
```dart
static const TextStyle authTitle = TextStyle(
  fontFamily: 'Lato',
  fontSize: 28,
  fontWeight: FontWeight.w700,
);

static const TextStyle authBiometricTitle = TextStyle(
  fontFamily: 'Lato',
  fontSize: 26,
  fontWeight: FontWeight.w700,
);
```

### Spacing System

#### AppSpacing (`lib/core/constants/app_spacing.dart`)
- Uses `flutter_screenutil` for responsive sizing
- Consistent padding, margins, and gaps

**Padding**
```dart
static EdgeInsets get paddingAll16 => EdgeInsets.all(16.w);
static EdgeInsets get paddingH20 => EdgeInsets.symmetric(horizontal: 20.w);
static EdgeInsets get paddingV12 => EdgeInsets.symmetric(vertical: 12.h);
```

**Gaps**
```dart
static SizedBox get gapH16 => SizedBox(height: 16.h);
static SizedBox get gapW24 => SizedBox(width: 24.w);
```

### Theme Configuration

#### Light Theme
```dart
static ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.lightSurface,
    background: AppColors.lightBackground,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  // ... more configurations
);
```

#### Dark Theme
```dart
static ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  // ... more configurations
);
```

### Theme Mode Management
```dart
// In main.dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // Follows system preference
);
```

### Adaptive Components
Components automatically adapt to theme mode:
```dart
// Example: Adaptive colors based on theme
final isDarkMode = Theme.of(context).brightness == Brightness.dark;
final textColor = isDarkMode ? AppColors.textWhite : AppColors.textBlack;
final backgroundColor = isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
```

---

## 🎬 Splash Screen & Onboarding

### Splash Screen

#### Implementation
- **File**: `lib/features/splash/presentation/screens/splash_screen.dart`
- **Duration**: 2-3 seconds (configurable)
- **Animation**: Fade-in animation with custom timing

#### Features
1. **Firebase User Check**: Checks if user is authenticated
2. **Session Validation**: Validates existing session
3. **App Lock Check**: Determines if app should be locked
4. **Onboarding Check**: Checks if user has completed onboarding
5. **Smart Routing**: Routes to appropriate screen based on state

#### Routing Logic
```dart
if (user != null && hasValidSession) {
  // Registered user with valid session
  if (shouldLock) {
    goto('/app-lock');
  } else {
    goto('/home');
  }
} else if (hasSeenOnboarding) {
  // User has seen onboarding before
  goto('/login');
} else {
  // First time user
  goto('/onboarding');
}
```

#### Configuration
```dart
// TimingConfig
static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
static const Duration splashRegisteredUserDelay = Duration(milliseconds: 3000);
static const Duration splashNonRegisteredUserDelay = Duration(milliseconds: 2000);
```

### Onboarding

#### Implementation
- **Location**: `lib/features/onboarding/`
- **Screens**: 4 screens with PageView
- **Persistence**: Uses SharedPreferences to track completion

#### Screens
1. **Welcome to Crypto X**
   - Introduction to the app
   - Hero image
   - Welcome message

2. **Transaction Security**
   - Highlights security features
   - Biometric authentication
   - Secure transactions

3. **Fast and Reliable Market Updates**
   - Real-time market data
   - Price alerts
   - Market insights

4. **Get Started Now!**
   - Call to action
   - Login and Register buttons

#### Features
- **Page Indicator**: Shows progress (dots)
- **Skip Button**: Jump to login/register
- **Next Button**: Navigate through screens
- **Smooth Transitions**: Animated page changes
- **Theme Adaptive**: Works in light and dark mode

#### Components

**OnboardingPage** (`lib/features/onboarding/presentation/widgets/onboarding_page.dart`)
- Displays image, title, and content
- Responsive layout
- Theme-aware styling

**OnboardingIndicator** (`lib/features/onboarding/presentation/widgets/onboarding_indicator.dart`)
- Animated dots showing current page
- Active/inactive states
- Color transitions

```dart
// Page transition configuration
static const Duration onboardingPageTransitionDuration =
  Duration(milliseconds: 300);
```

---

## 🔧 Configuration & Constants

### Centralized Configuration
All hardcoded values removed and centralized in configuration files.

### AppConstants
**File**: `lib/core/config/app_constants.dart`

```dart
// App Metadata
static const String appTitle = 'Team 18 Fintech';
static const String appVersion = '1.0.0';

// UI Configuration
static const Size designSize = Size(375, 812);
static const List<DeviceOrientation> allowedOrientations = [
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
];

// Demo Data
static const double defaultDemoBalance = 143421.20;
static const double defaultWeeklyChangePercent = 10.14;

// Auto-Lock Options
static const List<int> autoLockTimeoutOptions = [
  0, 30, 60, 300, 600, 1800
];

// Cache Configuration
static const Duration marketDataCacheDuration = Duration(seconds: 30);
```

### TimingConfig
**File**: `lib/core/config/timing_config.dart`

```dart
// UI Delays
static const Duration shortDelay = Duration(milliseconds: 500);
static const Duration mediumDelay = Duration(seconds: 2);

// Biometric Authentication
static const Duration biometricScanDelay = Duration(milliseconds: 500);
static const Duration biometricSuccessDelay = Duration(seconds: 2);

// Network Timeouts
static const Duration connectionTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);

// Session Management
static const int sessionTimeoutMinutes = 30;
static const Duration sessionTimeout = Duration(minutes: 30);

// Splash Screen
static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
static const Duration splashRegisteredUserDelay = Duration(milliseconds: 3000);
```

### ValidationConfig
**File**: `lib/core/config/validation_config.dart`

```dart
// Password Rules
static const int minPasswordLength = 8;
static const int maxPasswordLength = 128;

// Name Rules
static const int minNameLength = 2;
static const int maxNameLength = 50;

// Phone Rules
static const int minPhoneLength = 10;
static const int maxPhoneLength = 15;

// Regex Patterns
static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
static final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
```

### StorageKeysConfig
**File**: `lib/core/config/storage_keys_config.dart`

All secure storage keys centralized for easy management and refactoring.

### AppStrings
**File**: `lib/core/constants/app_strings.dart`

All UI strings centralized for easy localization and updates:
```dart
// Auth Strings
static const createYourAccount = 'Create Your Account';
static const loginToYourAccount = 'Login To Your Account';
static const register = 'Register';
static const login = 'login';

// Home Strings
static const currentBalance = 'Current Balance';
static const weeklyProfit = 'Weekly Profit';

// Onboarding Strings
static const onboardingTitle1Part1 = "Welcome To ";
static const onboardingTitle1Part2 = "Crypto X";
static const onboardingSkip = "Skip";
```

### Environment Variables
**File**: `lib/core/config/env_config.dart`

```dart
// API Keys loaded from environment
static const String coinGeckoApiKey = String.fromEnvironment(
  'COINGECKO_API_KEY',
  defaultValue: '',
);
```

**Setup**: Create `.env` file (gitignored)
```bash
COINGECKO_API_KEY=your_api_key_here
```

---

## 🔄 State Management

### BLoC/Cubit Pattern

#### Why Cubit?
- Simpler than full BLoC for most use cases
- Clear separation of business logic and UI
- Testable and predictable state changes
- Stream-based reactive programming

#### Example: Home Cubit

**States**
```dart
abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MarketOverview marketOverview;
  final List<TrendingCoin> trendingCoins;
  final List<TopGainer> topGainers;
  final PortfolioBalance portfolioBalance;
}

class HomeError extends HomeState {
  final String message;
}
```

**Cubit Implementation**
```dart
class HomeCubit extends Cubit<HomeState> {
  final GetMarketOverviewUseCase _getMarketOverviewUseCase;
  final GetTrendingCoinsUseCase _getTrendingCoinsUseCase;
  final GetTopGainersUseCase _getTopGainersUseCase;
  final GetPortfolioBalanceUseCase _getPortfolioBalanceUseCase;

  HomeCubit(/* dependencies */) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // Load all data in parallel
    final results = await Future.wait([
      _getMarketOverviewUseCase(),
      _getTrendingCoinsUseCase(),
      _getTopGainersUseCase(),
      _getPortfolioBalanceUseCase(),
    ]);

    // Handle results
    emit(HomeLoaded(/* ... */));
  }
}
```

**UI Usage**
```dart
BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    if (state is HomeLoading) {
      return LoadingWidget();
    } else if (state is HomeLoaded) {
      return HomeContent(data: state);
    } else if (state is HomeError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

#### Other Cubits
- `AuthCubit` - Authentication state
- `RegisterCubit` - Registration flow
- `LoginCubit` - Login flow
- `BiometricVerifyCubit` - Biometric authentication
- `MarketCubit` - Market data
- `PortfolioCubit` - Portfolio management

---

## 🌐 Networking & API

### API Integration

#### CoinGecko API
- **Base URL**: `https://api.coingecko.com/api/v3`
- **Authentication**: API Key (required for higher rate limits)
- **Package**: `dio` for HTTP requests
- **Configuration**: `lib/core/networking/dio_client.dart`

#### API Client Setup
```dart
class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    dio.options = BaseOptions(
      baseUrl: NetworkConfig.coinGeckoBaseUrl,
      connectTimeout: TimingConfig.connectionTimeout,
      receiveTimeout: TimingConfig.receiveTimeout,
      headers: {
        'x-cg-pro-api-key': EnvConfig.coinGeckoApiKey,
        'Content-Type': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(ErrorInterceptor());
  }
}
```

#### Endpoints Used
```dart
// Global market data
GET /global

// Trending coins
GET /search/trending

// Market data
GET /coins/markets
  ?vs_currency=usd
  &order=market_cap_desc
  &per_page=100
  &page=1

// Coin details
GET /coins/{id}
  ?localization=false
  &tickers=false
  &market_data=true
```

### Error Handling

#### Custom Failure Types
```dart
abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {}
class NetworkFailure extends Failure {}
class CacheFailure extends Failure {}
class ValidationFailure extends Failure {}
```

#### API Error Handler
**File**: `lib/core/networking/api_error_handler.dart`

```dart
class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet.';
        case DioExceptionType.receiveTimeout:
          return 'Server took too long to respond.';
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response);
        default:
          return 'Network error occurred.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
```

### Response Models
**Location**: `lib/features/home/data/models/`

```dart
class TrendingCoinModel {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;

  factory TrendingCoinModel.fromJson(Map<String, dynamic> json) {
    return TrendingCoinModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['thumb'],
    );
  }

  TrendingCoin toEntity() {
    return TrendingCoin(
      id: id,
      name: name,
      symbol: symbol,
      imageUrl: imageUrl,
    );
  }
}
```

---

## 🗺️ Routing & Navigation

### Go Router Implementation

#### Configuration
**File**: `lib/core/routing/app_router.dart`

```dart
class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    observers: [appRouteObserver],
    initialLocation: AppRoutes.splash,
    routes: _buildRoutes(),
  );
}
```

#### Route Names
**File**: `lib/core/routing/route_names.dart`

```dart
class AppRoutes {
  // Public routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Protected routes (require authentication)
  static const String home = '/home';
  static const String market = '/market';
  static const String portfolio = '/portfolio';
  static const String settings = '/settings';

  // Security routes
  static const String appLock = '/app-lock';
  static const String rootWarning = '/root-warning';

  // Auth flow routes
  static const String biometricSetup = '/biometric-setup';
  static const String faceIdScanning = '/faceid-scanning';
  static const String fingerprintSetup = '/fingerprint-setup';
}
```

#### Route Observer
**File**: `lib/core/observers/app_route_observer.dart`

Tracks route changes for:
- Analytics
- Security (screenshot prevention)
- Background blur
- Audit logging

```dart
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // Track navigation
    _logRouteChange(route);
    _updateSecureState(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // Handle back navigation
  }
}
```

### Deep Linking
- Supports custom URL schemes
- Web URL support
- Path parameters
- Query parameters

---

## 📦 Dependency Injection

### Get It Implementation
**File**: `lib/core/di/di.dart`

```dart
final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External Dependencies
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FlutterSecureStorage());

  // Core Services
  sl.registerLazySingleton<ISecureStorage>(
    () => SecureStorageImpl(sl()),
  );

  sl.registerLazySingleton<IBiometricService>(
    () => BiometricServiceImpl(sl()),
  );

  sl.registerLazySingleton<ISessionManager>(
    () => SessionManagerImpl(sl()),
  );

  sl.registerLazySingleton<IAppLockService>(
    () => AppLockServiceImpl(sl()),
  );

  // Feature Dependencies
  _registerHomeDependencies();
  _registerAuthDependencies();
  _registerMarketDependencies();
  _registerPortfolioDependencies();
}
```

### Service Registration Pattern
```dart
void _registerHomeDependencies() {
  // Data Sources
  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiService(sl()),
  );

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMarketOverviewUseCase(sl()));
  sl.registerLazySingleton(() => GetTrendingCoinsUseCase(sl()));

  // Cubits
  sl.registerFactory(() => HomeCubit(
    getMarketOverviewUseCase: sl(),
    getTrendingCoinsUseCase: sl(),
    getTopGainersUseCase: sl(),
    getPortfolioBalanceUseCase: sl(),
  ));
}
```

---

## 🧪 Testing Strategy

### Test Structure
```
test/
├── unit/              # Unit tests
│   ├── cubits/       # Cubit/BLoC tests
│   ├── repositories/ # Repository tests
│   └── services/     # Service tests
│
├── widget/           # Widget tests
│   └── screens/      # Screen widget tests
│
└── integration/      # Integration tests
    └── flows/        # User flow tests
```

### Mocking
- **Package**: `mocktail`
- Mock all external dependencies
- Test behavior, not implementation

### Coverage Goals
- Unit tests: >80%
- Widget tests: >60%
- Integration tests: Critical flows

---

## 📱 Responsive Design

### ScreenUtil Configuration
```dart
ScreenUtilInit(
  designSize: AppConstants.designSize, // Size(375, 812)
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_, child) {
    return MaterialApp.router(/* ... */);
  },
)
```

### Responsive Sizing
```dart
// Width responsive
width: 200.w  // Scales based on screen width

// Height responsive
height: 100.h  // Scales based on screen height

// Font responsive
fontSize: 16.sp  // Scales based on screen size

// Radius responsive
borderRadius: BorderRadius.circular(8.r)
```

---

## 🔒 Security Best Practices

### Implemented Security Measures
1. ✅ **Encrypted Storage**: All sensitive data encrypted at rest
2. ✅ **HTTPS Only**: All API calls over secure connections
3. ✅ **Certificate Pinning**: (Recommended for production)
4. ✅ **Biometric Authentication**: Multi-factor authentication
5. ✅ **Session Management**: Auto-logout on inactivity
6. ✅ **Root/Jailbreak Detection**: Warns users of compromised devices
7. ✅ **Screenshot Prevention**: Protects sensitive screens
8. ✅ **Background Blur**: Hides content in app switcher
9. ✅ **Audit Logging**: Tracks security events
10. ✅ **Input Validation**: All user inputs validated
11. ✅ **Environment Variables**: API keys not hardcoded
12. ✅ **Code Obfuscation**: (Recommended for release builds)

### Security Checklist for Production
- [ ] Enable ProGuard/R8 (Android)
- [ ] Enable bitcode (iOS)
- [ ] Implement certificate pinning
- [ ] Enable code obfuscation
- [ ] Remove all debug logs
- [ ] Implement rate limiting
- [ ] Add CAPTCHA for auth
- [ ] Enable 2FA (optional)
- [ ] Implement biometric re-authentication for sensitive operations
- [ ] Regular security audits
- [ ] Penetration testing

---

## 🚀 Performance Optimizations

### Implemented Optimizations
1. **API Response Caching**: 30-second cache for market data
2. **Image Caching**: Automatic with `cached_network_image`
3. **Lazy Loading**: Lists load data on demand
4. **State Preservation**: Tab states preserved in navigation
5. **Debouncing**: Search inputs debounced
6. **Pagination**: Large lists paginated
7. **Selective Rebuilds**: BlocBuilder limits rebuilds
8. **const Constructors**: Reduces widget rebuilds
9. **Asset Optimization**: Compressed images

### Performance Monitoring
- Use Flutter DevTools for profiling
- Monitor frame rendering times
- Track memory usage
- Analyze network requests
- Check build times

---

## 📚 Key Packages Used

### Core Dependencies
```yaml
# State Management
flutter_bloc: ^8.1.3
equatable: ^2.0.5

# Networking
dio: ^5.4.0
retrofit: ^4.0.3

# Routing
go_router: ^13.0.0

# Dependency Injection
get_it: ^7.6.4
injectable: ^2.3.2

# Firebase
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6

# Security
flutter_secure_storage: ^9.0.0
local_auth: ^2.1.8
flutter_jailbreak_detection: ^1.10.0
secure_application: ^3.7.1

# UI
flutter_screenutil: ^5.9.0
cached_network_image: ^3.3.1

# Utilities
shared_preferences: ^2.2.2
dartz: ^0.10.1
intl: ^0.18.1
```

---

## 🎯 Future Enhancements

### Planned Features
1. **Multi-language Support**: i18n/l10n implementation
2. **Push Notifications**: Price alerts and notifications
3. **Chart Visualizations**: Interactive price charts
4. **Watchlist**: Favorite coins tracking
5. **Transaction History**: Buy/sell tracking
6. **Portfolio Analytics**: Advanced analytics and insights
7. **News Integration**: Crypto news feed
8. **Social Features**: Share portfolios, follow traders
9. **Widget Support**: Home screen widgets
10. **Apple Watch/Wear OS**: Companion apps

### Technical Debt
1. Implement comprehensive unit tests
2. Add integration tests
3. Improve error messages
4. Add retry mechanisms for failed requests
5. Implement offline mode
6. Add analytics tracking
7. Improve accessibility
8. Add haptic feedback
9. Optimize app size
10. Implement CI/CD pipeline

---

## 📖 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Firebase project setup
- CoinGecko API key

### Installation

1. **Clone Repository**
```bash
git clone <repository-url>
cd team_18_final_project
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
```bash
flutterfire configure
```

4. **Environment Variables**
```bash
cp .env.example .env
# Add your CoinGecko API key to .env
```

5. **Run App**
```bash
flutter run
```

### Build for Production

**Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

---

## 🤝 Contributing Guidelines

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` before committing
- Format code with `dart format`
- Write meaningful commit messages

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Production hotfixes

### Pull Request Process
1. Create feature branch from `develop`
2. Implement changes
3. Write/update tests
4. Update documentation
5. Run tests and analyze
6. Create pull request
7. Code review
8. Merge to `develop`

---

## 📝 License

Copyright © 2024 Team 18 Fintech. All rights reserved.

---

## 👥 Team

**Team 18**
- Project developed as part of academic curriculum
- Focus: Mobile app development with Flutter
- Emphasis: Enterprise-grade security features

---

## 📧 Support

For questions or issues:
- Check existing documentation
- Search GitHub issues
- Contact team members
- Create new issue with detailed description

---

## 🔗 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [CoinGecko API Docs](https://www.coingecko.com/en/api)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [BLoC Documentation](https://bloclibrary.dev)

### Tutorials
- [Flutter Security Best Practices](https://flutter.dev/security)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)
- [BLoC Pattern Tutorial](https://bloclibrary.dev/#/gettingstarted)

---

**Document Version**: 1.0.0
**Last Updated**: 2024-01-29
**Maintained By**: Team 18
