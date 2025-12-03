# Architecture Documentation

## Clean Architecture Overview

This project implements **Clean Architecture** (also known as Onion Architecture or Hexagonal Architecture) to ensure separation of concerns, testability, and maintainability.

## The Three Layers

### 1. Presentation Layer (Outermost)

**Location**: `lib/features/home/presentation/`

**Responsibility**: User interface and user interaction

**Components**:
- **Screens** - Full-screen widgets (e.g., `HomeScreen`)
- **Widgets** - Reusable UI components (e.g., `BalanceCard`, `TopGainerTile`)
- **Cubit** - State management using flutter_bloc
- **States** - Immutable state classes

**Key Principles**:
- Depends on Domain layer only (never on Data layer)
- Contains no business logic
- Reacts to state changes
- Emits user actions to Cubit

**Example Flow**:
```dart
User Action → Widget → Cubit → Use Case → Repository (interface)
                ↑                              ↓
            State Update ← Cubit ← Response ← Repository
```

### 2. Domain Layer (Core/Middle)

**Location**: `lib/features/home/domain/`

**Responsibility**: Business logic and rules

**Components**:
- **Entities** - Pure business objects (e.g., `MarketOverview`, `TrendingCoinEntity`)
- **Use Cases** - Single business actions (e.g., `GetMarketOverviewUseCase`)
- **Repository Interfaces** - Contracts for data access

**Key Principles**:
- Contains pure Dart code (no Flutter dependencies)
- Independent of frameworks, UI, and databases
- Defines business rules
- Uses abstractions (interfaces) for dependencies

**Why Pure Dart?**
- Can be tested without Flutter
- Can be reused across platforms
- Business logic is framework-agnostic

### 3. Data Layer (Outermost)

**Location**: `lib/features/home/data/`

**Responsibility**: Data retrieval and storage

**Components**:
- **Models** - Data transfer objects (DTOs) with JSON serialization
- **Data Sources** - API services (e.g., `HomeApiService`)
- **Repository Implementations** - Concrete implementations of domain interfaces

**Key Principles**:
- Implements repository interfaces from Domain
- Handles data mapping (Model → Entity)
- Manages API calls, caching, error handling
- Never exposes implementation details to Domain

---

## Dependency Rule

**The Golden Rule**: Dependencies always point inward

```
Presentation → Domain ← Data
    (UI)      (Logic)  (Sources)
```

- **Presentation** depends on **Domain**
- **Data** depends on **Domain**
- **Domain** depends on nothing (pure Dart)

This means:
- Domain layer defines interfaces (e.g., `HomeRepository`)
- Data layer implements those interfaces (e.g., `HomeRepositoryImpl`)
- Presentation layer uses domain interfaces (via dependency injection)

---

## Design Patterns in Detail

### 1. Repository Pattern

**Purpose**: Abstract data sources from business logic

**Implementation**:

```dart
// Domain - Abstract contract
abstract class HomeRepository {
  Future<Either<Failure, MarketOverview>> getMarketOverview();
}

// Data - Concrete implementation
class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _apiService;

  @override
  Future<Either<Failure, MarketOverview>> getMarketOverview() async {
    // Fetch from API, map to entity, handle errors
  }
}
```

**Benefits**:
- Swap data sources without changing business logic
- Easy to mock for testing
- Single source of truth for data access

### 2. Use Case Pattern (Interactor)

**Purpose**: Encapsulate a single business action

**Implementation**:

```dart
class GetMarketOverviewUseCase {
  final HomeRepository repository;

  GetMarketOverviewUseCase(this.repository);

  Future<Either<Failure, MarketOverview>> call() async {
    return await repository.getMarketOverview();
  }
}
```

**Benefits**:
- Single Responsibility Principle (SRP)
- Reusable across different UI components
- Easy to test in isolation
- Clear business intent

**Why "call()" method?**
- Allows using the class instance as a function
- `useCase()` instead of `useCase.execute()`

### 3. Bloc/Cubit Pattern

**Purpose**: Manage UI state reactively

**Cubit vs Bloc**:
- **Cubit**: Simple state management with methods
- **Bloc**: Event-driven state management with streams

**This project uses Cubit** for simplicity:

```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(/* use cases */) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    // Execute use cases
    emit(HomeLoaded(/* data */));
  }
}
```

**State Classes**:
```dart
abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState { /* data */ }
class HomeError extends HomeState { /* message */ }
```

**UI Reaction**:
```dart
BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    if (state is HomeLoading) return LoadingWidget();
    if (state is HomeLoaded) return DataWidget(state.data);
    if (state is HomeError) return ErrorWidget(state.message);
    return InitialWidget();
  },
)
```

### 4. Either Pattern (Functional Error Handling)

**Purpose**: Handle success and failure without exceptions

**Using Dartz Library**:

```dart
// Either<Left, Right>
// Left = Failure, Right = Success
Either<Failure, MarketOverview> result = await repository.getMarketOverview();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Success: ${data.marketCap}'),
);
```

**Benefits**:
- Explicit error handling
- Type-safe
- Functional programming style
- Forces developers to handle errors

### 5. Dependency Injection with GetIt

**Purpose**: Manage dependencies and enable loose coupling

**Setup** (`lib/core/di/di.dart`):

```dart
final sl = GetIt.instance; // Service Locator

void setupDependencyInjection() {
  // Register API service
  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiService(sl<Dio>())
  );

  // Register repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeApiService>())
  );

  // Register use cases
  sl.registerLazySingleton(
    () => GetMarketOverviewUseCase(sl<HomeRepository>())
  );

  // Register Cubit (factory - new instance each time)
  sl.registerFactory(
    () => HomeCubit(
      getMarketOverviewUseCase: sl(),
      getTrendingCoinsUseCase: sl(),
      // ...
    )
  );
}
```

**Usage**:
```dart
// In widget
BlocProvider(
  create: (context) => sl<HomeCubit>()..loadHomeData(),
  child: HomeScreenContent(),
)
```

**Benefits**:
- Centralized dependency management
- Easy to swap implementations
- Testable (inject mocks)
- Singleton and factory patterns

---

## Data Flow Example

Let's trace a complete request for market overview data:

### Step-by-Step Flow

1. **User Opens App**
   ```dart
   // main.dart
   HomeScreen() // Created
   ```

2. **Widget Creates Cubit**
   ```dart
   // home_screen.dart
   BlocProvider(
     create: (context) => sl<HomeCubit>()..loadHomeData(),
   )
   ```

3. **Cubit Executes Use Cases**
   ```dart
   // home_cubit.dart
   Future<void> loadHomeData() async {
     emit(HomeLoading());
     final result = await getMarketOverviewUseCase();
     // Handle result...
   }
   ```

4. **Use Case Calls Repository**
   ```dart
   // get_market_overview_usecase.dart
   Future<Either<Failure, MarketOverview>> call() async {
     return await repository.getMarketOverview();
   }
   ```

5. **Repository Fetches from API**
   ```dart
   // home_repository_impl.dart
   Future<Either<Failure, MarketOverview>> getMarketOverview() async {
     try {
       final data = await _apiService.getGlobalData();
       final entity = _mapToEntity(data);
       return Right(entity);
     } catch (e) {
       return Left(ServerFailure(message: e.toString()));
     }
   }
   ```

6. **API Service Makes HTTP Request**
   ```dart
   // home_api_service.dart (generated by Retrofit)
   @GET('/global')
   Future<GlobalDataModel> getGlobalData();
   ```

7. **Response Flows Back**
   ```
   API → Model → Repository → Entity → Use Case → Cubit → State
   ```

8. **UI Rebuilds**
   ```dart
   // home_screen.dart
   BlocBuilder<HomeCubit, HomeState>(
     builder: (context, state) {
       if (state is HomeLoaded) {
         return MarketOverviewGrid(
           marketOverview: state.marketOverview
         );
       }
     }
   )
   ```

---

## Testing Strategy

### Unit Tests (Domain Layer)

Test use cases and entities in isolation:

```dart
test('GetMarketOverviewUseCase returns market data', () async {
  // Arrange
  final mockRepository = MockHomeRepository();
  when(() => mockRepository.getMarketOverview())
      .thenAnswer((_) async => Right(mockMarketOverview));

  final useCase = GetMarketOverviewUseCase(mockRepository);

  // Act
  final result = await useCase();

  // Assert
  expect(result, Right(mockMarketOverview));
});
```

### Bloc Tests (Presentation Layer)

Test state transitions:

```dart
blocTest<HomeCubit, HomeState>(
  'emits [HomeLoading, HomeLoaded] when data loads successfully',
  build: () {
    // Mock use cases
    return HomeCubit(/* mocked use cases */);
  },
  act: (cubit) => cubit.loadHomeData(),
  expect: () => [
    HomeLoading(),
    HomeLoaded(/* expected data */),
  ],
);
```

### Widget Tests (UI Layer)

Test UI components:

```dart
testWidgets('displays loading indicator', (tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => mockCubit..emit(HomeLoading()),
      child: HomeScreen(),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

## Benefits of This Architecture

### 1. **Separation of Concerns**
- Each layer has a single, well-defined responsibility
- Changes in one layer don't affect others

### 2. **Testability**
- Domain logic can be tested without UI or database
- Mock dependencies easily with interfaces
- High test coverage possible

### 3. **Maintainability**
- Code is organized and predictable
- Easy to locate and fix bugs
- Clear boundaries between components

### 4. **Scalability**
- Add new features without modifying existing code
- Parallel development on different layers
- Easy to extend functionality

### 5. **Framework Independence**
- Business logic doesn't depend on Flutter
- Can migrate to different UI frameworks
- Can reuse domain layer in web, desktop apps

### 6. **Flexibility**
- Swap data sources (REST API → GraphQL → Local DB)
- Change state management (Bloc → Riverpod)
- Update UI without touching business logic

---

## Common Questions

### Q: Why separate Models and Entities?

**Models** (Data layer):
- Match API response structure
- Include JSON serialization
- May have nullable fields
- Tightly coupled to external data source

**Entities** (Domain layer):
- Represent business concepts
- Pure Dart objects
- Non-nullable where appropriate
- Independent of data sources

**Example**:
```dart
// Model - matches API
class TopGainerModel {
  final String? image; // Nullable
  final double? price_change_percentage_24h; // Snake case
}

// Entity - business object
class TopGainerEntity {
  final String imageUrl; // Non-nullable, renamed
  final double priceChangePercentage24h; // Camel case
}
```

### Q: When to use Cubit vs Bloc?

**Use Cubit when**:
- Simple state changes
- Direct method calls
- Linear logic flow

**Use Bloc when**:
- Complex event handling
- Multiple events trigger same state
- Need event transformation

**This project uses Cubit** because state changes are straightforward.

### Q: Why dependency injection?

**Without DI**:
```dart
class HomeCubit {
  final useCase = GetMarketOverviewUseCase(
    HomeRepositoryImpl(
      HomeApiService(Dio())
    )
  );
}
```
- Hard to test (can't mock dependencies)
- Tightly coupled
- Hard to change implementations

**With DI**:
```dart
class HomeCubit {
  final GetMarketOverviewUseCase getMarketOverviewUseCase;

  HomeCubit({required this.getMarketOverviewUseCase});
}

// Inject during creation
sl<HomeCubit>(); // GetIt handles dependencies
```
- Easy to test (inject mocks)
- Loosely coupled
- Flexible

---

## Summary

This architecture provides:
- ✅ Clear separation of concerns
- ✅ Testable code at every layer
- ✅ Maintainable and scalable codebase
- ✅ Framework-independent business logic
- ✅ Flexible and adaptable design

The investment in proper architecture pays off as the project grows!
