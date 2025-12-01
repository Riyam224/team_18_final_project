import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:team_18_final_project/features/portfolio/presentation/screens/portfolio_screen.dart';

// Mock class
class MockGetPortfolioOverviewUseCase extends Mock
    implements GetPortfolioOverviewUseCase {}

void main() {
  late MockGetPortfolioOverviewUseCase mockGetPortfolioOverview;

  setUp(() {
    mockGetPortfolioOverview = MockGetPortfolioOverviewUseCase();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => PortfolioCubit(
          getPortfolioOverview: mockGetPortfolioOverview,
        )..load(),
        child: const PortfolioScreen(),
      ),
    );
  }

  group('PortfolioScreen Integration Tests', () {
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

    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display portfolio data when loaded successfully',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('\$31,000.00'), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });

    testWidgets('should display total value card', (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Total Value'), findsOneWidget);
      expect(find.text('\$31,000.00'), findsOneWidget);
      expect(find.textContaining('+3.6%'), findsOneWidget);
    });

    testWidgets('should display month selector', (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Dec'), findsOneWidget);
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
    });

    testWidgets('should display allocation chart', (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('\$25,000.00 BTC'), findsOneWidget);
      expect(find.text('\$6,000.00 ETH'), findsOneWidget);
    });

    testWidgets('should display holdings section', (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('My Holdings'), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.text('ETH'), findsOneWidget);
    });

    testWidgets('should display holding percentages correctly',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('81%'), findsOneWidget); // BTC percentage
      expect(find.text('19%'), findsOneWidget); // ETH percentage
    });

    testWidgets('should display holding values and changes',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
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
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('Buy Bitcoin'), findsOneWidget);
      expect(find.text('Sell Ethereum'), findsOneWidget);
    });

    testWidgets('should display error message when loading fails',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview()).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Server error')),
      );

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('should display network error message',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview()).thenAnswer(
        (_) async => Left(NetworkFailure(message: 'No internet connection')),
      );

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('should handle empty portfolio gracefully',
        (WidgetTester tester) async {
      // arrange
      const emptyOverview = PortfolioOverview(holdings: []);
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => const Right(emptyOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('\$0.00'), findsWidgets);
      expect(find.text('My Holdings'), findsOneWidget);
      // Should still display sections even when empty
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      final scrollableFinder = find.byType(SingleChildScrollView);
      expect(scrollableFinder, findsOneWidget);

      // Verify can scroll
      await tester.drag(scrollableFinder, const Offset(0, -200));
      await tester.pumpAndSettle();
    });

    testWidgets('should tap on month selector chips',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on a month chip
      await tester.tap(find.text('Jan'));
      await tester.pumpAndSettle();

      // assert - should not crash
      expect(find.text('Jan'), findsOneWidget);
    });

    testWidgets('should display correct number of holdings',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      // Should have 2 holdings (Bitcoin and Ethereum)
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
    });

    testWidgets('should maintain state when scrolling',
        (WidgetTester tester) async {
      // arrange
      when(() => mockGetPortfolioOverview())
          .thenAnswer((_) async => Right(tPortfolioOverview));

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final initialValue = find.text('\$31,000.00');
      expect(initialValue, findsOneWidget);

      // Scroll
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Scroll back
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // assert - value should still be there
      expect(find.text('\$31,000.00'), findsOneWidget);
    });
  });
}
