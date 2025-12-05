import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_state.dart';
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

  group('PortfolioCubit', () {
    test('initial state is loading', () {
      expect(cubit.state.isLoading, true);
    });

    blocTest<PortfolioCubit, PortfolioState>(
      'load() emits loaded state on success',
      build: () => cubit,
      act: (cubit) {
        repository.setResponse(Right(TestPortfolioData.overview()));
        return cubit.load();
      },
      expect: () => [
        predicate<PortfolioState>((state) => state.isLoading == true),
        predicate<PortfolioState>((state) {
          return state.isLoading == false &&
              state.error == null &&
              state.totalValue == '\$31,000.00' &&
              state.holdings.length == 2;
        }),
      ],
    );

    blocTest<PortfolioCubit, PortfolioState>(
      'load() emits error state on failure',
      build: () => cubit,
      act: (cubit) {
        repository.setResponse(
          Left(ServerFailure(message: 'Network error')),
        );
        return cubit.load();
      },
      expect: () => [
        predicate<PortfolioState>((state) => state.isLoading == true),
        predicate<PortfolioState>((state) {
          return state.isLoading == false && state.error == 'Network error';
        }),
      ],
    );

    blocTest<PortfolioCubit, PortfolioState>(
      'loadForMonth() passes correct days parameter',
      build: () => cubit,
      act: (cubit) async {
        repository.setResponse(Right(TestPortfolioData.overview()));
        await cubit.loadForMonth(2);
      },
      verify: (_) {
        expect(repository.lastDays, 90);
      },
    );
  });
}
