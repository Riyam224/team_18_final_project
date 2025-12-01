import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';

// Mock class
class MockGetPortfolioOverviewUseCase extends Mock
    implements GetPortfolioOverviewUseCase {}

void main() {
  late PortfolioCubit cubit;
  late MockGetPortfolioOverviewUseCase mockGetPortfolioOverview;

  setUp(() {
    mockGetPortfolioOverview = MockGetPortfolioOverviewUseCase();
    cubit = PortfolioCubit(getPortfolioOverview: mockGetPortfolioOverview);
  });

  tearDown(() {
    cubit.close();
  });

  group('PortfolioCubit Tests', () {
    final tPortfolioOverview = PortfolioOverview(
      holdings: [
        const PortfolioHolding(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 0.5,
          priceUsd: 50000.0,
          changePercent24h: 5.0,
          icon: Icons.currency_bitcoin,
          iconColor: Colors.orange,
        ),
        const PortfolioHolding(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          amount: 2.0,
          priceUsd: 3000.0,
          changePercent24h: -2.0,
          icon: Icons.currency_exchange,
          iconColor: Colors.blue,
        ),
      ],
    );

    test('initial state should be loading', () {
      // assert
      expect(cubit.state.isLoading, true);
      expect(cubit.state.error, null);
      expect(cubit.state.totalValue, '');
      expect(cubit.state.holdings, isEmpty);
      expect(cubit.state.allocations, isEmpty);
    });

    group('load()', () {
      blocTest<PortfolioCubit, PortfolioState>(
        'should emit [loading, loaded] when data is fetched successfully',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          predicate<PortfolioState>((state) => state.isLoading == true),
          predicate<PortfolioState>((state) {
            return state.isLoading == false &&
                state.error == null &&
                state.totalValue == '\$31,000.00' &&
                state.holdings.length == 2 &&
                state.allocations.length == 2;
          }),
        ],
        verify: (_) {
          verify(() => mockGetPortfolioOverview()).called(1);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should emit [loading, error] when fetching data fails',
        build: () {
          when(() => mockGetPortfolioOverview()).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Server error')),
          );
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          predicate<PortfolioState>((state) => state.isLoading == true),
          predicate<PortfolioState>((state) {
            return state.isLoading == false && state.error == 'Server error';
          }),
        ],
        verify: (_) {
          verify(() => mockGetPortfolioOverview()).called(1);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should format total value correctly',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.totalValue, '\$31,000.00');
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should calculate change label correctly with positive change',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          // totalValue = $31,000
          // totalChange = $1,130
          // changePercent = ($1,130 / $31,000) * 100 = 3.6%
          expect(state.changeLabel, contains('+3.6%'));
          expect(state.changeLabel, contains('\$1,130.00'));
          expect(state.changeLabel, contains('Today'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should calculate change label with negative change',
        build: () {
          final negativeOverview = PortfolioOverview(
            holdings: [
              const PortfolioHolding(
                id: 'bitcoin',
                name: 'Bitcoin',
                symbol: 'BTC',
                amount: 1.0,
                priceUsd: 50000.0,
                changePercent24h: -5.0,
                icon: Icons.currency_bitcoin,
                iconColor: Colors.orange,
              ),
            ],
          );
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(negativeOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.changeLabel, contains('-5.0%'));
          expect(state.changeLabel, contains('-\$2,500.00'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should create correct allocation segments',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.allocations.length, 2);

          final btcAllocation = state.allocations[0];
          expect(btcAllocation.value, 25000.0);
          expect(btcAllocation.color, Colors.orange);
          expect(btcAllocation.label, contains('\$25,000.00'));
          expect(btcAllocation.label, contains('BTC'));

          final ethAllocation = state.allocations[1];
          expect(ethAllocation.value, 6000.0);
          expect(ethAllocation.color, Colors.blue);
          expect(ethAllocation.label, contains('\$6,000.00'));
          expect(ethAllocation.label, contains('ETH'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should create correct holding view data with percentage',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.holdings.length, 2);

          final btcHolding = state.holdings[0];
          expect(btcHolding.name, 'Bitcoin');
          expect(btcHolding.symbol, 'BTC');
          // BTC is 25000/31000 = ~80.6%
          expect(btcHolding.percentage, closeTo(80.6, 0.1));
          expect(btcHolding.amount, '0.5 BTC');
          expect(btcHolding.value, '\$25,000.00');
          expect(btcHolding.change, '\$1,250.00');
          expect(btcHolding.changePercent, '+5.00%');

          final ethHolding = state.holdings[1];
          expect(ethHolding.name, 'Ethereum');
          expect(ethHolding.symbol, 'ETH');
          // ETH is 6000/31000 = ~19.4%
          expect(ethHolding.percentage, closeTo(19.4, 0.1));
          expect(ethHolding.amount, '2.0 ETH');
          expect(ethHolding.value, '\$6,000.00');
          expect(ethHolding.change, '-\$120.00');
          expect(ethHolding.changePercent, '-2.00%');
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle empty portfolio',
        build: () {
          const emptyOverview = PortfolioOverview(holdings: []);
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => const Right(emptyOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.isLoading, false);
          expect(state.error, null);
          expect(state.totalValue, '\$0.00');
          expect(state.changeLabel, contains('0.0%'));
          expect(state.changeLabel, contains('\$0.00'));
          expect(state.holdings, isEmpty);
          expect(state.allocations, isEmpty);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle single holding',
        build: () {
          final singleOverview = PortfolioOverview(
            holdings: [
              const PortfolioHolding(
                id: 'bitcoin',
                name: 'Bitcoin',
                symbol: 'BTC',
                amount: 1.0,
                priceUsd: 50000.0,
                changePercent24h: 5.0,
                icon: Icons.currency_bitcoin,
                iconColor: Colors.orange,
              ),
            ],
          );
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(singleOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.holdings.length, 1);
          expect(state.allocations.length, 1);
          // Single holding should be 100%
          expect(state.holdings[0].percentage, 100.0);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle zero total value without division by zero',
        build: () {
          final zeroOverview = PortfolioOverview(
            holdings: [
              const PortfolioHolding(
                id: 'zero',
                name: 'Zero',
                symbol: 'ZRO',
                amount: 0,
                priceUsd: 0,
                changePercent24h: 0,
                icon: Icons.money,
                iconColor: Colors.grey,
              ),
            ],
          );
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(zeroOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.isLoading, false);
          expect(state.error, null);
          expect(state.totalValue, '\$0.00');
          expect(state.holdings[0].percentage, 0.0);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle network failure',
        build: () {
          when(() => mockGetPortfolioOverview()).thenAnswer(
            (_) async =>
                Left(NetworkFailure(message: 'No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          predicate<PortfolioState>((state) => state.isLoading == true),
          predicate<PortfolioState>((state) {
            return state.isLoading == false &&
                state.error == 'No internet connection';
          }),
        ],
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle cache failure',
        build: () {
          when(() => mockGetPortfolioOverview()).thenAnswer(
            (_) async => Left(CacheFailure(message: 'Cache error')),
          );
          return cubit;
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          predicate<PortfolioState>((state) => state.isLoading == true),
          predicate<PortfolioState>((state) {
            return state.isLoading == false && state.error == 'Cache error';
          }),
        ],
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle multiple consecutive loads',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) async {
          await cubit.load();
          await cubit.load();
          await cubit.load();
        },
        verify: (_) {
          verify(() => mockGetPortfolioOverview()).called(3);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should format large values with proper separators',
        build: () {
          final largeOverview = PortfolioOverview(
            holdings: [
              const PortfolioHolding(
                id: 'bitcoin',
                name: 'Bitcoin',
                symbol: 'BTC',
                amount: 100.0,
                priceUsd: 50000.0,
                changePercent24h: 5.0,
                icon: Icons.currency_bitcoin,
                iconColor: Colors.orange,
              ),
            ],
          );
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(largeOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          // Should format 5,000,000 with commas
          expect(state.totalValue, contains('5,000,000'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should handle many holdings efficiently',
        build: () {
          final manyHoldings = List.generate(
            50,
            (i) => PortfolioHolding(
              id: 'coin$i',
              name: 'Coin $i',
              symbol: 'C$i',
              amount: 1.0,
              priceUsd: 100.0,
              changePercent24h: 1.0,
              icon: Icons.monetization_on,
              iconColor: Colors.green,
            ),
          );
          final manyOverview = PortfolioOverview(holdings: manyHoldings);

          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(manyOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.holdings.length, 50);
          expect(state.allocations.length, 50);
          // Each holding should have equal 2% allocation
          for (final holding in state.holdings) {
            expect(holding.percentage, 2.0);
          }
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should preserve icon data in holdings',
        build: () {
          when(() => mockGetPortfolioOverview())
              .thenAnswer((_) async => Right(tPortfolioOverview));
          return cubit;
        },
        act: (cubit) => cubit.load(),
        verify: (_) {
          final state = cubit.state;
          expect(state.holdings[0].icon, Icons.currency_bitcoin);
          expect(state.holdings[0].iconColor, Colors.orange);
          expect(state.holdings[1].icon, Icons.currency_exchange);
          expect(state.holdings[1].iconColor, Colors.blue);
        },
      );
    });
  });
}
