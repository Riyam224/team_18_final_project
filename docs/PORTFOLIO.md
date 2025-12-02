# Portfolio Feature - Complete Documentation

## 📋 Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Data & API](#data--api)
- [Transactions](#transactions)
- [State & Routing](#state--routing)
- [UI Components](#ui-components)
- [Testing](#testing)
- [Common Tasks](#common-tasks)
- [Data/State Flow](#datastate-flow)

---

## Overview
A cryptocurrency portfolio experience built with Clean Architecture and BLoC. It surfaces total balance, allocation donut, holdings list, and recent transactions with optional historical lookbacks.

Key capabilities:
- 📊 Portfolio total + weighted change label
- 🥧 Allocation donut by asset
- 📈 24h change per holding
- 🧭 Month selector → historical pricing (30/60/90+ days)
- 📜 Seeded recent transactions
- 🔢 Deterministic calculations (no DateTime.now in tests; guarded floating-point comparisons)

Core formulas:
```
valueUsd = amount * priceUsd
totalValue = Σ valueUsd
totalChangeUsd = Σ (valueUsd * changePercent24h / 100)
weightedChange% = totalValue == 0 ? 0 : (totalChangeUsd / totalValue) * 100
allocation% per holding = valueUsd / totalValue * 100
```

---

## Quick Start
- Run app: `flutter run`
- Navigate: Portfolio is the initial route (`/portfolio`) and a bottom-nav tab.
- Run tests (portfolio only): `flutter test test/features/portfolio/`
- Run coverage: `flutter test --coverage test/features/portfolio/`

---

## Architecture
Clean split: Presentation → Domain → Data.

```
Presentation: screens, widgets, cubits
Domain: entities, repository interface, use case
Data: data sources (remote/local), models, repository implementation
```

Dependencies flow inward only (no layer reaches “out”).

---

## Project Structure
```
lib/features/portfolio/
├── data/
│   ├── datasources/
│   │   ├── portfolio_api_service.dart       # Retrofit CoinGecko client
│   │   ├── portfolio_remote_data_source.dart# API calls wrapper
│   │   ├── portfolio_local_data_source.dart # Seeded holdings
│   │   └── transaction_local_data_source.dart # Seeded transactions (clock injected)
│   ├── models/                              # SimplePriceModel, MarketChartModel
│   └── repositories/
│       └── portfolio_repository_impl.dart   # Combines seeds + prices, cache fallback
├── domain/
│   ├── entities/                            # PortfolioHolding, PortfolioOverview, Transaction
│   ├── repositories/                        # PortfolioRepository (interface)
│   └── usecases/                            # GetPortfolioOverviewUseCase
└── presentation/
    ├── cubit/                               # PortfolioCubit + state
    ├── constants/                           # PortfolioColors, PortfolioConstants
    ├── screens/                             # PortfolioScreen
    └── widgets/                             # AllocationChart, HoldingCard, MonthSelector, etc.

lib/core/
├── di/di.dart                               # GetIt registrations (Dio, services, repo, cubit)
├── routing/app_router.dart                  # GoRouter, bottom nav shell, initial route=/portfolio
└── constants/app_strings.dart               # Month labels, copy
```

---

## Data & API
- Base URL: `https://api.coingecko.com/api/v3` (`lib/core/networking/api_base_url.dart`)
- Services: `portfolio_api_service.dart` (Retrofit)
  - `/simple/price` for current prices + 24h change
  - `/coins/{id}/market_chart` for historical prices (days param)
- Remote DS: `portfolio_remote_data_source.dart` wraps service calls.
- Local DS (holdings): `portfolio_local_data_source.dart` seeds BTC/ETH/LTC amounts and icons.
- Repository: `portfolio_repository_impl.dart`
  - If days provided → fetch market charts per asset, compute latest price + period change %
  - Else → fetch simple prices
  - Builds `PortfolioOverview`, caches last good response for fallback on errors
- Market chart mapping: `MarketChartModel` parses `[timestampMs, price]` pairs; `latestPrice`, `earliestPrice`, `priceChangePercent`, and `averagePrice` derive directly from the series.
- Error handling: API failures are wrapped via `ApiErrorHandler`; repository falls back to cached `PortfolioOverview` when available, otherwise returns `Failure`. Cubit emits `PortfolioState.error` only when no cache can serve.

---

## Transactions
- Entity: `features/portfolio/domain/entities/transaction.dart`
- Local DS: `transaction_local_data_source.dart` (accepts an injectable clock for deterministic tests) seeds two sample transactions (BTC buy, ETH sell) relative to provided `now`.
- UI: mapped into `TransactionTile` list in `PortfolioScreen`.

---

## State & Routing
- Routing: `lib/core/routing/app_router.dart` uses GoRouter with a bottom-nav `ShellRoute`. Initial location: `AppRoutes.portfolio`.
- DI: `lib/core/di/di.dart` registers Dio, `PortfolioApiService`, local/remote data sources, repository, use case, and `PortfolioCubit`.
- DI snippet (GetIt):
  ```dart
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton(() => PortfolioApiService(sl()));
  sl.registerLazySingleton(() => PortfolioLocalDataSource());
  sl.registerLazySingleton(() => PortfolioRemoteDataSource(api: sl()));
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(remote: sl(), local: sl()),
  );
  sl.registerFactory(() => GetPortfolioOverviewUseCase(repository: sl()));
  sl.registerFactory(() => PortfolioCubit(getPortfolioOverview: sl()));
  ```
- Cubit: `PortfolioCubit` loads current or historical data (`loadForMonth` maps month index → days via `PortfolioConstants.monthIndexToDays`), formats currency, builds allocation segments and holding view models.
- Constants: `PortfolioConstants` (month/day mapping, label fragments), `PortfolioColors` (icon/color mapping per asset).

---

## UI Components
- `PortfolioScreen`: title, `TotalValueCard`, `MonthSelector`, `AllocationChart`, holdings list (`HoldingCard`), transactions (`TransactionTile`).
- `AllocationChart`: custom donut painter.
- `HoldingCard`: shows percent weight, amount, value, and 24h change.
- `MonthSelector`: chips mapped to days (30–180 by default).
- Allocation segments: each segment value = holding.valueUsd; percent = value / totalValue * 100.
- Theming/colors pulled from shared core styles plus `PortfolioColors`.

---

## Testing
Deterministic, DateTime.now-free tests with injected clocks/mocks and tight precision guards.

### Helpers (test/helpers/)
- `test_portfolio_data.dart`: shared holdings/overview fixtures.
- `fake_portfolio_repository.dart`: controllable repository for cubit/use case tests (tracks calls/days).
- `test_di_initializer.dart`: GetIt setup for tests.
- `mock_svg.dart`: fakes SVG asset loading for widget tests.
- `test_utils.dart`: fixed clock (`fixedNow`) and stable `expectClose`.

### Key Suites
- Data: `transaction_local_data_source_test.dart` (clock-injected, deterministic timestamps)
- Domain: `portfolio_holding_test.dart`, `portfolio_overview_test.dart`, `transaction_test.dart`, `get_portfolio_overview_usecase_test.dart`
- Presentation: `portfolio_cubit_test.dart` (uses fake repo), `portfolio_screen_integration_test.dart` (uses test DI + SVG mock), constants tests.

Run: `flutter test test/features/portfolio/`
Coverage: run `flutter test --coverage test/features/portfolio/` (see HTML report for current numbers).

---

## Common Tasks
- Add asset: update `portfolio_local_data_source.dart` amounts + `PortfolioColors` mappings; ensure icon/color set.
- Adjust historical windows: edit `PortfolioConstants.monthIndexToDays`.
- Change routing start tab: update `initialLocation` in `core/routing/app_router.dart`.
- Update transactions seed: adjust `transaction_local_data_source.dart`; inject clock in tests for determinism.
- Extend DI for new collaborators: register in `core/di/di.dart`.
- Add historical chart for a new coin: ensure CoinGecko ID is present in seeds, `PortfolioColors` has color/icon, and historical fetch (`fetchMarketChart`) accepts the ID; consider rate limits when expanding the list.

---

## Data/State Flow
```
PortfolioScreen
  └─ BlocProvider -> PortfolioCubit
      └─ load()/loadForMonth(days)
          └─ GetPortfolioOverviewUseCase
              └─ PortfolioRepositoryImpl
                  ├─ PortfolioLocalDataSource (seeded holdings)
                  ├─ PortfolioRemoteDataSource (prices/market_chart)
                  └─ Cache (last good overview on error)
      └─ emits PortfolioState:
          ├─ loading -> UI spinner
          ├─ loaded  -> charts/cards/transactions
          └─ error   -> message (only if no cache)
```

Last updated: keep in sync with `lib/core/di/di.dart`, `features/portfolio/...` modules, and `test/features/portfolio/` helper/test files.
