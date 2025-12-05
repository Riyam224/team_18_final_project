import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/presentation/screens/portfolio_screen.dart';
import '../../../helpers/fake_portfolio_repository.dart';
import '../../../helpers/mock_svg.dart';
import '../../../helpers/test_di_initializer.dart';
import '../../../helpers/test_portfolio_data.dart';

void main() {
  late FakePortfolioRepository repository;

  setUpAll(() async {
    await registerSvgMock();
  });

  setUp(() async {
    repository = FakePortfolioRepository();
    await setupTestDi(portfolioRepository: repository);
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          home: PortfolioScreen(),
        );
      },
    );
  }

  group('PortfolioScreen', () {
    testWidgets('displays loading initially', (WidgetTester tester) async {
      repository.setResponse(Right(TestPortfolioData.overview()));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays portfolio data when loaded', (WidgetTester tester) async {
      repository.setResponse(Right(TestPortfolioData.overview()));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('\$31,000.00'), findsWidgets);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });

    testWidgets('displays error message on failure', (WidgetTester tester) async {
      repository.setResponse(Left(ServerFailure(message: 'Connection error')));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Connection error'), findsOneWidget);
    });

    testWidgets('displays holdings with correct data', (WidgetTester tester) async {
      repository.setResponse(Right(TestPortfolioData.overview()));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('My Holdings'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
    });
  });
}
