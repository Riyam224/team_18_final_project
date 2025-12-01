import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';

// Mock class
class MockPortfolioRepository extends Mock implements PortfolioRepository {}

void main() {
  late GetPortfolioOverviewUseCase useCase;
  late MockPortfolioRepository mockRepository;

  setUp(() {
    mockRepository = MockPortfolioRepository();
    useCase = GetPortfolioOverviewUseCase(repository: mockRepository);
  });

  group('GetPortfolioOverviewUseCase Tests', () {
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

    test('should return portfolio overview from repository when successful',
        () async {
      // arrange
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(tPortfolioOverview));
      verify(() => mockRepository.fetchPortfolio()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.fetchPortfolio()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty portfolio when repository returns empty holdings',
        () async {
      // arrange
      const tEmptyOverview = PortfolioOverview(holdings: []);
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => const Right(tEmptyOverview));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tEmptyOverview));
      result.fold(
        (failure) => fail('Should not fail'),
        (overview) {
          expect(overview.holdings, isEmpty);
          expect(overview.totalValue, 0.0);
          expect(overview.totalChangeUsd, 0.0);
        },
      );
    });

    test('should propagate network failure from repository', () async {
      // arrange
      final tNetworkFailure =
          NetworkFailure(message: 'No internet connection');
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Left(tNetworkFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(tNetworkFailure));
      verify(() => mockRepository.fetchPortfolio()).called(1);
    });

    test('should propagate cache failure from repository', () async {
      // arrange
      final tCacheFailure = CacheFailure(message: 'Cache error');
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Left(tCacheFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(tCacheFailure));
      verify(() => mockRepository.fetchPortfolio()).called(1);
    });

    test('should handle multiple consecutive calls', () async {
      // arrange
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      final result1 = await useCase();
      final result2 = await useCase();
      final result3 = await useCase();

      // assert
      expect(result1, Right(tPortfolioOverview));
      expect(result2, Right(tPortfolioOverview));
      expect(result3, Right(tPortfolioOverview));
      verify(() => mockRepository.fetchPortfolio()).called(3);
    });

    test('should handle large portfolio with many holdings', () async {
      // arrange
      final manyHoldings = List.generate(
        100,
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
      final largeOverview = PortfolioOverview(holdings: manyHoldings);

      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(largeOverview));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(largeOverview));
      result.fold(
        (failure) => fail('Should not fail'),
        (overview) {
          expect(overview.holdings.length, 100);
          expect(overview.totalValue, 10000.0);
        },
      );
    });

    test('should return portfolio with single holding', () async {
      // arrange
      final singleHolding = PortfolioOverview(
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

      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(singleHolding));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(singleHolding));
      result.fold(
        (failure) => fail('Should not fail'),
        (overview) {
          expect(overview.holdings.length, 1);
          expect(overview.totalValue, 50000.0);
        },
      );
    });

    test('should handle repository throwing exception', () async {
      // arrange
      when(() => mockRepository.fetchPortfolio())
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });

    test('should work correctly when called through call method', () async {
      // arrange
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      final result = await useCase.call();

      // assert
      expect(result, Right(tPortfolioOverview));
      verify(() => mockRepository.fetchPortfolio()).called(1);
    });

    test('should work correctly when called as function', () async {
      // arrange
      when(() => mockRepository.fetchPortfolio())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(tPortfolioOverview));
      verify(() => mockRepository.fetchPortfolio()).called(1);
    });
  });
}
