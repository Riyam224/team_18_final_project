import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
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
        return MaterialApp(
          home: const PortfolioScreen(),
        );
      },
    );
  }

  group('PortfolioScreen Integration Tests', () {
    final tPortfolioOverview = TestPortfolioData.overview();

    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display portfolio data when loaded successfully',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('\$31,000.00'), findsWidgets);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });

    testWidgets('should display total value card', (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Total Value'), findsOneWidget);
      expect(find.text('\$31,000.00'), findsWidgets);
      expect(find.textContaining('+3.6%'), findsOneWidget);
    });

    testWidgets('should display month selector', (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Dec'), findsOneWidget);
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
    });

    testWidgets('should display allocation chart', (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('\$25,000.00 BTC'), findsOneWidget);
      expect(find.text('\$6,000.00 ETH'), findsOneWidget);
    });

    testWidgets('should display holdings section', (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('My Holdings'), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
    });

    testWidgets('should display holding percentages correctly',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('81%'), findsOneWidget);
      expect(find.text('19%'), findsOneWidget);
    });

    testWidgets('should display holding values and changes',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('0.5 BTC'), findsOneWidget);
      expect(find.text('\$25,000.00'), findsOneWidget);
      expect(find.text('\$1,250.00'), findsOneWidget);
      expect(find.text('+5.00%'), findsOneWidget);

      expect(find.text('2.0 ETH'), findsOneWidget);
      expect(find.text('\$6,000.00'), findsOneWidget);
      expect(find.text('-\$120.00'), findsOneWidget);
      expect(find.text('-2.00%'), findsOneWidget);
    });

    testWidgets('should display recent transactions section',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.textContaining('Buy Bitcoin'), findsOneWidget);
      expect(find.textContaining('Sell Ethereum'), findsOneWidget);
    });

    testWidgets('should display error message when loading fails',
        (WidgetTester tester) async {
      repository.setResponse(
        Left(ServerFailure(message: 'Server error')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('should display network error message',
        (WidgetTester tester) async {
      repository.setResponse(
        Left(NetworkFailure(message: 'No internet connection')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('should handle empty portfolio gracefully',
        (WidgetTester tester) async {
      repository.setResponse(
        const Right(PortfolioOverview(holdings: [])),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('\$0.00'), findsWidgets);
      expect(find.text('My Holdings'), findsOneWidget);
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final scrollableFinder = find.byType(SingleChildScrollView);
      expect(scrollableFinder, findsOneWidget);

      await tester.drag(scrollableFinder, const Offset(0, -200));
      await tester.pumpAndSettle();
    });

    testWidgets('should display correct number of holdings',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });

    testWidgets('should maintain state when scrolling',
        (WidgetTester tester) async {
      repository.setResponse(Right(tPortfolioOverview));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('\$31,000.00'), findsWidgets);

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(find.text('\$31,000.00'), findsWidgets);
    });
  });
}
