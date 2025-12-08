import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_cubit.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_state.dart';

class MockGetMarketOverviewUseCase extends Mock implements GetMarketOverviewUseCase {}
class MockGetTrendingCoinsUseCase extends Mock implements GetTrendingCoinsUseCase {}
class MockGetTopGainersUseCase extends Mock implements GetTopGainersUseCase {}
class MockGetPortfolioBalanceUseCase extends Mock implements GetPortfolioBalanceUseCase {}

void main() {
  late HomeCubit cubit;
  late MockGetMarketOverviewUseCase mockGetMarketOverviewUseCase;
  late MockGetTrendingCoinsUseCase mockGetTrendingCoinsUseCase;
  late MockGetTopGainersUseCase mockGetTopGainersUseCase;
  late MockGetPortfolioBalanceUseCase mockGetPortfolioBalanceUseCase;

  setUp(() {
    mockGetMarketOverviewUseCase = MockGetMarketOverviewUseCase();
    mockGetTrendingCoinsUseCase = MockGetTrendingCoinsUseCase();
    mockGetTopGainersUseCase = MockGetTopGainersUseCase();
    mockGetPortfolioBalanceUseCase = MockGetPortfolioBalanceUseCase();

    cubit = HomeCubit(
      getMarketOverviewUseCase: mockGetMarketOverviewUseCase,
      getTrendingCoinsUseCase: mockGetTrendingCoinsUseCase,
      getTopGainersUseCase: mockGetTopGainersUseCase,
      getPortfolioBalanceUseCase: mockGetPortfolioBalanceUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tMarketOverview = MarketOverview(
    marketCap: '\$2.1T',
    volume24h: '\$98.5B',
    btcDominance: '45.5%',
    activeCoins: 10000,
    marketCapChangePercentage: 2.5,
  );

  const tTrendingCoins = [
    TrendingCoinEntity(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      imageUrl: 'https://example.com/bitcoin.png',
      price: '\$45,123.45',
      priceChangePercentage24h: 5.2,
    ),
  ];

  const tTopGainers = [
    TopGainerEntity(
      id: 'ethereum',
      name: 'Ethereum',
      symbol: 'ETH',
      imageUrl: 'https://example.com/ethereum.png',
      currentPrice: 2000.0,
      priceChangePercentage24h: 10.5,
    ),
  ];

  const tPortfolioBalance = PortfolioBalance(
    totalBalance: 50000.0,
    weeklyChangePercentage: 2.5,
  );

  group('loadHomeData', () {
    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeLoaded] when all data is loaded successfully',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => const Right(tMarketOverview));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeLoaded(
          marketOverview: tMarketOverview,
          trendingCoins: tTrendingCoins,
          topGainers: tTopGainers,
          portfolioBalance: tPortfolioBalance,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when market overview fails',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Failed to load market overview')));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'Failed to load market overview'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when trending coins fails',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => const Right(tMarketOverview));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Failed to load trending coins')));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'Failed to load trending coins'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when top gainers fails',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => const Right(tMarketOverview));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Failed to load top gainers')));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'Failed to load top gainers'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when portfolio balance fails',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => const Right(tMarketOverview));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Failed to load portfolio balance')));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'Failed to load portfolio balance'),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when unexpected error occurs',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenThrow(Exception('Unexpected error'));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeError(message: 'An unexpected error occurred: Exception: Unexpected error'),
      ],
    );
  });

  group('refreshHomeData', () {
    blocTest<HomeCubit, HomeState>(
      'should call loadHomeData when refreshHomeData is called',
      build: () {
        when(() => mockGetMarketOverviewUseCase())
            .thenAnswer((_) async => const Right(tMarketOverview));
        when(() => mockGetTrendingCoinsUseCase())
            .thenAnswer((_) async => const Right(tTrendingCoins));
        when(() => mockGetTopGainersUseCase())
            .thenAnswer((_) async => const Right(tTopGainers));
        when(() => mockGetPortfolioBalanceUseCase())
            .thenAnswer((_) async => const Right(tPortfolioBalance));
        return cubit;
      },
      act: (cubit) => cubit.refreshHomeData(),
      expect: () => [
        HomeLoading(),
        const HomeLoaded(
          marketOverview: tMarketOverview,
          trendingCoins: tTrendingCoins,
          topGainers: tTopGainers,
          portfolioBalance: tPortfolioBalance,
        ),
      ],
    );
  });
}
