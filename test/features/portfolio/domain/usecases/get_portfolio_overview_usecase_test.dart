import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import '../../../../helpers/fake_portfolio_repository.dart';
import '../../../../helpers/test_portfolio_data.dart';

void main() {
  group('GetPortfolioOverviewUseCase', () {
    late FakePortfolioRepository repository;
    late GetPortfolioOverviewUseCase useCase;

    setUp(() {
      repository = FakePortfolioRepository();
      useCase = GetPortfolioOverviewUseCase(repository: repository);
    });

    test('returns portfolio overview when repository succeeds', () async {
      repository.setResponse(Right(TestPortfolioData.overview()));

      final result = await useCase();

      expect(result, isA<Right>());
      expect(repository.callCount, 1);
      expect(repository.lastDays, isNull);
    });

    test('bubbles up failure from repository', () async {
      const failure = ServerFailure(message: 'server down');
      repository.setResponse(const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      expect(repository.callCount, 1);
    });

    test('passes through days parameter for history', () async {
      await useCase(days: 90);

      expect(repository.lastDays, 90);
    });
  });
}
