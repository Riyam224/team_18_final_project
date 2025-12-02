import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_colors.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../../../helpers/fake_portfolio_repository.dart';
import '../../../../helpers/test_portfolio_data.dart';

void main() {
  late FakePortfolioRepository repository;
  late GetPortfolioOverviewUseCase useCase;
  late PortfolioCubit cubit;

  setUp(() {
    repository = FakePortfolioRepository();
    useCase = GetPortfolioOverviewUseCase(repository: repository);
    cubit = PortfolioCubit(getPortfolioOverview: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('PortfolioCubit Tests', () {
    final tPortfolioOverview = TestPortfolioData.overview();

    test('initial state should be loading', () {
      expect(cubit.state.isLoading, true);
      expect(cubit.state.error, null);
      expect(cubit.state.totalValue, '');
      expect(cubit.state.holdings, isEmpty);
      expect(cubit.state.allocations, isEmpty);
    });

    group('load()', () {
      blocTest<PortfolioCubit, PortfolioState>(
        'should emit [loading, loaded] when data is fetched successfully',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(Right(tPortfolioOverview));
          return cubit.load();
        },
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
          expect(repository.callCount, 1);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should emit [loading, error] when fetching data fails',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(
            Left(ServerFailure(message: 'Server error')),
          );
          return cubit.load();
        },
        expect: () => [
          predicate<PortfolioState>((state) => state.isLoading == true),
          predicate<PortfolioState>((state) {
            return state.isLoading == false && state.error == 'Server error';
          }),
        ],
        verify: (_) {
          expect(repository.callCount, 1);
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should format total value correctly',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(Right(tPortfolioOverview));
          return cubit.load();
        },
        verify: (_) {
          final state = cubit.state;
          expect(state.totalValue, '\$31,000.00');
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should calculate change label correctly with positive change',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(Right(tPortfolioOverview));
          return cubit.load();
        },
        verify: (_) {
          final state = cubit.state;
          expect(state.changeLabel, contains('+3.6%'));
          expect(state.changeLabel, contains('\$1,130.00'));
          expect(state.changeLabel, contains('Today'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should calculate change label with negative change',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(
            Right(
              TestPortfolioData.overview(
                holdings: [
                  TestPortfolioData.btc(
                    amount: 1.0,
                    changePercent24h: -5.0,
                  ),
                ],
              ),
            ),
          );
          return cubit.load();
        },
        verify: (_) {
          final state = cubit.state;
          expect(state.changeLabel, contains('-5.0%'));
          expect(state.changeLabel, contains('-\$2,500.00'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should create correct allocation segments',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(Right(tPortfolioOverview));
          return cubit.load();
        },
        verify: (_) {
          final state = cubit.state;
          expect(state.allocations.length, 2);

          final btcAllocation = state.allocations[0];
          expect(btcAllocation.value, 25000.0);
          expect(btcAllocation.color, AppPortfolioColors.bitcoin);
          expect(btcAllocation.label, contains('\$25,000.00'));
          expect(btcAllocation.label, contains('BTC'));

          final ethAllocation = state.allocations[1];
          expect(ethAllocation.value, 6000.0);
          expect(ethAllocation.color, AppPortfolioColors.ethereum);
          expect(ethAllocation.label, contains('\$6,000.00'));
          expect(ethAllocation.label, contains('ETH'));
        },
      );

      blocTest<PortfolioCubit, PortfolioState>(
        'should create correct holding view data with percentage',
        build: () => cubit,
        act: (cubit) {
          repository.setResponse(Right(tPortfolioOverview));
          return cubit.load();
        },
        verify: (_) {
          final state = cubit.state;
          expect(state.holdings.length, 2);

          final btcHolding = state.holdings[0];
          expect(btcHolding.name, 'Bitcoin');
          expect(btcHolding.symbol, 'BTC');
          expect(btcHolding.percentage, closeTo(80.6, 0.1));
          expect(btcHolding.amount, '0.5 BTC');
          expect(btcHolding.value, '\$25,000.00');
          expect(btcHolding.change, '\$1,250.00');
          expect(btcHolding.changePercent, '+5.00%');
          expect(btcHolding.iconColor, AppPortfolioColors.bitcoin);

          final ethHolding = state.holdings[1];
          expect(ethHolding.name, 'Ethereum');
          expect(ethHolding.symbol, 'ETH');
          expect(ethHolding.percentage, closeTo(19.4, 0.1));
          expect(ethHolding.amount, '2.0 ETH');
          expect(ethHolding.value, '\$6,000.00');
          expect(ethHolding.change, '-\$120.00');
          expect(ethHolding.changePercent, '-2.00%');
          expect(ethHolding.iconColor, AppPortfolioColors.ethereum);
        },
      );
    });

    group('loadForMonth()', () {
      blocTest<PortfolioCubit, PortfolioState>(
        'should pass days parameter based on month index',
        build: () => cubit,
        act: (cubit) async {
          repository.setResponse(Right(tPortfolioOverview));
          await cubit.loadForMonth(2);
        },
        verify: (_) {
          expect(repository.lastDays, 90);
        },
      );
    });
  });
}
