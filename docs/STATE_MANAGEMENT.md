# State Management Guide

Complete guide to understanding state management using Bloc/Cubit pattern in this project.

## Table of Contents
1. [Why Bloc/Cubit?](#why-bloccubit)
2. [Cubit vs Bloc](#cubit-vs-bloc)
3. [Home Feature State Management](#home-feature-state-management)
4. [State Flow Diagrams](#state-flow-diagrams)
5. [Best Practices](#best-practices)

---

## Why Bloc/Cubit?

### The Problem: Managing UI State

**Without State Management**:
```dart
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  MarketOverview? marketOverview;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData(); // ❌ Hard to test
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    // ❌ Business logic mixed with UI
    // ❌ Hard to reuse
    // ❌ Difficult to test
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return LoadingWidget();
    if (errorMessage != null) return ErrorWidget();
    return DataWidget(marketOverview);
  }
}
```

**Problems**:
- Business logic in widget (hard to test)
- State scattered across multiple variables
- No single source of truth
- Difficult to reuse logic
- setState causes unnecessary rebuilds

### The Solution: Bloc/Cubit

**With Bloc/Cubit**:
```dart
// Business logic (Cubit) - Testable!
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadData() async {
    emit(HomeLoading());
    try {
      final data = await fetchData();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

// UI - Clean and simple!
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) return LoadingWidget();
          if (state is HomeError) return ErrorWidget(state.message);
          if (state is HomeLoaded) return DataWidget(state.data);
          return InitialWidget();
        },
      ),
    );
  }
}
```

**Benefits**:
✅ Separation of concerns (UI vs Logic)
✅ Single source of truth (state)
✅ Easy to test business logic
✅ Reusable across widgets
✅ Efficient rebuilds (only when state changes)
✅ Predictable state transitions

---

## Cubit vs Bloc

### Cubit (Simpler)

**What is it?**
- Lightweight state management
- Direct method calls to change state
- No events, just methods

**Structure**:
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// Usage
cubit.increment(); // Direct method call
```

**When to use**:
- Simple state changes
- Straightforward logic flow
- Don't need event history
- Quick prototyping

### Bloc (More Complex)

**What is it?**
- Event-driven state management
- Events trigger state changes
- More structured and testable

**Structure**:
```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}

// Usage
bloc.add(Increment()); // Add event
```

**When to use**:
- Complex business logic
- Need event transformation
- Event debouncing/throttling
- Multiple events trigger same state
- Need event history for debugging

### This Project Uses: Cubit

**Why?**
- State changes are straightforward
- No complex event handling needed
- Simpler to understand for new developers
- Less boilerplate code

---

## Home Feature State Management

### State Classes

**Location**: `lib/features/home/presentation/cubit/home_state.dart`

```dart
// Base state class
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}
```

#### 1. HomeInitial

**Purpose**: Default state when screen first created

```dart
class HomeInitial extends HomeState {}
```

**When emitted**:
- Cubit constructor: `super(HomeInitial())`
- Before any data loading

**UI Response**:
- Show initial/empty state
- Usually displays nothing or placeholder

#### 2. HomeLoading

**Purpose**: Data is being fetched from API

```dart
class HomeLoading extends HomeState {}
```

**When emitted**:
- Start of `loadHomeData()` method
- Start of `refreshHomeData()` method

**UI Response**:
```dart
if (state is HomeLoading) {
  return Center(
    child: CircularProgressIndicator(),
  );
}
```

#### 3. HomeLoaded

**Purpose**: Data successfully loaded

```dart
class HomeLoaded extends HomeState {
  final MarketOverview marketOverview;
  final List<TrendingCoinEntity> trendingCoins;
  final List<TopGainerEntity> topGainers;
  final PortfolioBalance portfolioBalance;

  const HomeLoaded({
    required this.marketOverview,
    required this.trendingCoins,
    required this.topGainers,
    required this.portfolioBalance,
  });

  @override
  List<Object?> get props => [
    marketOverview,
    trendingCoins,
    topGainers,
    portfolioBalance,
  ];
}
```

**When emitted**:
- After all API calls succeed
- All data is valid and ready

**UI Response**:
```dart
if (state is HomeLoaded) {
  return Column(
    children: [
      BalanceCard(state.portfolioBalance),
      MarketOverviewGrid(state.marketOverview),
      TrendingList(state.trendingCoins),
      TopGainersList(state.topGainers),
    ],
  );
}
```

**Equatable Props**:
- State changes only if any data field changes
- Prevents unnecessary UI rebuilds
- Efficient widget updates

#### 4. HomeError

**Purpose**: Data loading failed

```dart
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

**When emitted**:
- Any API call fails
- Network error
- Parsing error

**UI Response**:
```dart
if (state is HomeError) {
  return Column(
    children: [
      Text('Error: ${state.message}'),
      ElevatedButton(
        onPressed: () => cubit.refreshHomeData(),
        child: Text('Retry'),
      ),
    ],
  );
}
```

---

### Cubit Implementation

**Location**: `lib/features/home/presentation/cubit/home_cubit.dart`

```dart
class HomeCubit extends Cubit<HomeState> {
  final GetMarketOverviewUseCase getMarketOverviewUseCase;
  final GetTrendingCoinsUseCase getTrendingCoinsUseCase;
  final GetTopGainersUseCase getTopGainersUseCase;
  final GetPortfolioBalanceUseCase getPortfolioBalanceUseCase;

  HomeCubit({
    required this.getMarketOverviewUseCase,
    required this.getTrendingCoinsUseCase,
    required this.getTopGainersUseCase,
    required this.getPortfolioBalanceUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // Execute all use cases in parallel
    final results = await Future.wait([
      getMarketOverviewUseCase(),
      getTrendingCoinsUseCase(),
      getTopGainersUseCase(),
      getPortfolioBalanceUseCase(),
    ]);

    // Extract results
    final marketOverviewResult = results[0];
    final trendingCoinsResult = results[1];
    final topGainersResult = results[2];
    final portfolioBalanceResult = results[3];

    // Handle results with fold pattern
    marketOverviewResult.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (marketOverview) {
        trendingCoinsResult.fold(
          (failure) => emit(HomeError(message: failure.message)),
          (trendingCoins) {
            topGainersResult.fold(
              (failure) => emit(HomeError(message: failure.message)),
              (topGainers) {
                portfolioBalanceResult.fold(
                  (failure) => emit(HomeError(message: failure.message)),
                  (portfolioBalance) {
                    emit(HomeLoaded(
                      marketOverview: marketOverview,
                      trendingCoins: trendingCoins,
                      topGainers: topGainers,
                      portfolioBalance: portfolioBalance,
                    ));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
```

**Key Methods**:

1. **`loadHomeData()`**
   - Emits `HomeLoading`
   - Executes 4 use cases in parallel
   - Checks results sequentially
   - Emits `HomeLoaded` or `HomeError`

2. **`refreshHomeData()`**
   - Called by pull-to-refresh
   - Delegates to `loadHomeData()`

---

## State Flow Diagrams

### Normal Flow (Success)

```
┌─────────────┐
│ HomeInitial │ (Constructor)
└─────────────┘
       ↓
  loadHomeData()
       ↓
┌─────────────┐
│ HomeLoading │ (emit)
└─────────────┘
       ↓
  API Calls (parallel)
       ↓
  All Succeed
       ↓
┌─────────────┐
│ HomeLoaded  │ (emit with data)
└─────────────┘
```

### Error Flow

```
┌─────────────┐
│ HomeInitial │
└─────────────┘
       ↓
  loadHomeData()
       ↓
┌─────────────┐
│ HomeLoading │
└─────────────┘
       ↓
  API Calls (parallel)
       ↓
  Any Fails
       ↓
┌─────────────┐
│  HomeError  │ (emit with message)
└─────────────┘
```

### Refresh Flow

```
┌─────────────┐
│ HomeLoaded  │ (current state)
└─────────────┘
       ↓
  refreshHomeData()
       ↓
┌─────────────┐
│ HomeLoading │ (emit - shows refresh indicator)
└─────────────┘
       ↓
  API Calls (parallel)
       ↓
┌─────────────┐
│ HomeLoaded  │ (emit with new data)
└─────────────┘
```

---

## Widget Integration

### BlocProvider

**Purpose**: Provides Cubit to widget tree

**Usage in HomeScreen**:
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const HomeScreenContent(),
    );
  }
}
```

**What happens**:
1. `sl<HomeCubit>()` - Gets Cubit instance from GetIt
2. `..loadHomeData()` - Immediately starts loading
3. Cubit is provided to all descendant widgets

### BlocBuilder

**Purpose**: Rebuilds UI when state changes

**Usage**:
```dart
class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeCubit>().refreshHomeData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is HomeLoaded) {
          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BalanceCard(
                    totalBalance: state.portfolioBalance.totalBalance,
                    weeklyChangePercentage: state.portfolioBalance.weeklyChangePercentage,
                  ),
                  MarketOverviewGrid(marketOverview: state.marketOverview),
                  TrendingNowList(trendingCoins: state.trendingCoins),
                  TopGainersList(topGainers: state.topGainers),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
```

**How it works**:
1. BlocBuilder listens to Cubit
2. When state changes, `builder` is called
3. Returns appropriate widget for current state
4. Only rebuilds this widget (efficient)

### context.read vs context.watch

**`context.read<HomeCubit>()`**:
- Get Cubit instance
- Does NOT listen to changes
- Use for calling methods

```dart
ElevatedButton(
  onPressed: () {
    context.read<HomeCubit>().refreshHomeData(); // Call method
  },
  child: Text('Refresh'),
)
```

**`context.watch<HomeCubit>()`**:
- Get Cubit instance
- LISTENS to state changes
- Widget rebuilds when state changes
- Use in `build()` method

```dart
@override
Widget build(BuildContext context) {
  final state = context.watch<HomeCubit>().state; // Listens
  // Widget rebuilds when state changes
}
```

**BlocBuilder is preferred** over `context.watch` for better control

---

## Best Practices

### 1. Keep States Immutable

✅ **Good**:
```dart
class HomeLoaded extends HomeState {
  final MarketOverview marketOverview; // final = immutable

  const HomeLoaded({required this.marketOverview});
}
```

❌ **Bad**:
```dart
class HomeLoaded extends HomeState {
  MarketOverview marketOverview; // mutable

  HomeLoaded({required this.marketOverview});
}
```

**Why?**
- Predictable state transitions
- Easier to debug
- Equatable works correctly

### 2. Use Equatable for States

✅ **Good**:
```dart
class HomeLoaded extends Equatable {
  final MarketOverview marketOverview;

  @override
  List<Object?> get props => [marketOverview];
}
```

**Why?**
- Prevents unnecessary rebuilds
- State comparison based on values
- Efficient performance

### 3. Don't Emit State in Constructors

❌ **Bad**:
```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    loadHomeData(); // ❌ Don't do this
  }
}
```

✅ **Good**:
```dart
BlocProvider(
  create: (_) => HomeCubit()..loadHomeData(), // ✅ Call after creation
  child: HomeScreen(),
)
```

### 4. Handle All State Cases in UI

✅ **Good**:
```dart
if (state is HomeLoading) return LoadingWidget();
if (state is HomeError) return ErrorWidget();
if (state is HomeLoaded) return DataWidget();
return SizedBox.shrink(); // ✅ Default case
```

❌ **Bad**:
```dart
if (state is HomeLoaded) return DataWidget();
// ❌ No handling for other states
```

### 5. Use context.read for Methods

✅ **Good**:
```dart
onPressed: () => context.read<HomeCubit>().refreshHomeData()
```

❌ **Bad**:
```dart
onPressed: () => context.watch<HomeCubit>().refreshHomeData()
// ❌ watch causes unnecessary rebuilds
```

### 6. Keep Cubit Methods Simple

✅ **Good**:
```dart
class HomeCubit {
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    final result = await useCase();
    result.fold(
      (error) => emit(HomeError(error.message)),
      (data) => emit(HomeLoaded(data)),
    );
  }
}
```

**Why?**
- Easy to test
- Clear logic flow
- Use cases handle complexity

---

## Testing Cubit

### Unit Testing

```dart
void main() {
  late HomeCubit cubit;
  late MockGetMarketOverviewUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetMarketOverviewUseCase();
    cubit = HomeCubit(
      getMarketOverviewUseCase: mockUseCase,
      // ... other mocked use cases
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is HomeInitial', () {
    expect(cubit.state, HomeInitial());
  });

  blocTest<HomeCubit, HomeState>(
    'emits [HomeLoading, HomeLoaded] when data loads successfully',
    build: () {
      when(() => mockUseCase())
          .thenAnswer((_) async => Right(mockMarketOverview));
      return cubit;
    },
    act: (cubit) => cubit.loadHomeData(),
    expect: () => [
      HomeLoading(),
      HomeLoaded(
        marketOverview: mockMarketOverview,
        // ...
      ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'emits [HomeLoading, HomeError] when data loading fails',
    build: () {
      when(() => mockUseCase())
          .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
      return cubit;
    },
    act: (cubit) => cubit.loadHomeData(),
    expect: () => [
      HomeLoading(),
      HomeError(message: 'Error'),
    ],
  );
}
```

---

## Summary

**State Management Pattern**: Cubit (Bloc package)

**Why Cubit?**
- ✅ Separation of UI and business logic
- ✅ Testable
- ✅ Predictable state transitions
- ✅ Efficient rebuilds
- ✅ Simple to understand

**States**: 4 total
1. HomeInitial
2. HomeLoading
3. HomeLoaded (with data)
4. HomeError (with message)

**Key Widgets**:
- BlocProvider - Provides Cubit
- BlocBuilder - Rebuilds on state changes

**Best Practices**:
- Immutable states
- Use Equatable
- Handle all state cases
- Keep Cubit methods simple
- Test thoroughly
