# Portfolio Module

## Purpose
Simulate and visualize a crypto portfolio with live pricing/market chart data from CoinGecko. Provides allocation chart, holdings list, and time-range selection.

## Structure
```
features/portfolio/
├─ data/
│  ├─ datasources/portfolio_api_service.dart (simplePrice, marketChart)
│  ├─ datasources/portfolio_local_data_source.dart (seed holdings)
│  ├─ repositories/portfolio_repository_impl.dart
│  ├─ models/ (SimplePriceModel, MarketChartModel)
│  └─ mappers/market_chart_mapper.dart
├─ domain/
│  ├─ entities/ (PortfolioOverview, PortfolioHolding, MarketChart)
│  ├─ repositories/portfolio_repository.dart
│  └─ usecases/get_portfolio_overview_usecase.dart
└─ presentation/
   ├─ cubit/portfolio_cubit.dart + portfolio_state.dart
   ├─ screens/portfolio_screen.dart
   └─ widgets/ (allocation_chart, holding_card, total_value_card, etc.)
```

## Dependencies
- Dio + Retrofit (`PortfolioApiService`)
- Seed data from `PortfolioLocalDataSource`
- Formatting helpers: `AppPortfolioConstants`, `AppPortfolioColors`

## Cubit Flow
- `PortfolioCubit.load()` → `GetPortfolioOverviewUseCase` → repository.
- States: loading → loaded(totalValue, changeLabel, allocations, holdings) or error.

```mermaid
flowchart TD
  A[load()/loadForMonth] --> B[GetPortfolioOverviewUseCase]
  B --> C{PortfolioRepository.fetchPortfolio}
  C -->|API fail + cache| D[Use cache]
  C -->|ok| E[PortfolioOverview]
  D --> F[PortfolioState.loaded]
  E --> F[PortfolioState.loaded]
  C -->|fail no cache| G[PortfolioState.error]
```

## API Calls
- `GET /simple/price?ids=...&vs_currencies=usd&include_24hr_change=true` → `SimplePriceModel` map.
- `GET /coins/{id}/market_chart?vs_currency=usd&days={n}` → `MarketChartModel` (used for historical/month selections).

## Models & Mapping
- `PortfolioRepositoryImpl` maps `SimplePriceModel` to `PortfolioHolding` (value, change%); aggregates to `PortfolioOverview`.
- `MarketChartMapper` extracts latest price and 24h change for historical views.
- Presentation layer formats currency/percentages before rendering.
