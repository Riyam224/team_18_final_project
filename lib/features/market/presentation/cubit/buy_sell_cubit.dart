import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/market/domain/usecases/get_coin_details_usecase.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'buy_sell_state.dart';

/// Cubit for managing buy/sell screen state and business logic
/// Handles fetching coin details, calculating conversions, and processing transactions
class BuySellCubit extends Cubit<BuySellState> {
  final GetCoinDetailsUseCase getCoinDetailsUseCase;
  final AddTransactionUseCase addTransactionUseCase;

  /// Default fee percentage (0.05%)
  static const double defaultFeePercentage = 0.05;

  /// Default fiat amount ($1,800.00)
  static const double defaultFiatAmount = 1800.0;

  BuySellCubit({
    required this.getCoinDetailsUseCase,
    required this.addTransactionUseCase,
  }) : super(const BuySellInitial()) {
    debugPrint('[BuySellCubit] created');
  }

  /// Loads coin details and initializes conversion calculations
  Future<void> loadCoinDetails(String coinId) async {
    debugPrint('[BuySellCubit] loadCoinDetails: $coinId');
    emit(const BuySellLoading());

    try {
      final result = await getCoinDetailsUseCase(coinId);

      if (isClosed) return;

      result.fold(
        (failure) {
          debugPrint('[BuySellCubit] loadCoinDetails error: ${failure.message}');
          emit(BuySellError(message: failure.message));
        },
        (coinDetails) {
          debugPrint(
              '[BuySellCubit] loadCoinDetails success - ${coinDetails.name} at \$${coinDetails.currentPrice}');

          // Calculate initial conversion
          final exchangeRate = 1.0 / coinDetails.currentPrice;
          final cryptoAmount = defaultFiatAmount * exchangeRate;
          final feeAmount = defaultFiatAmount * (defaultFeePercentage / 100);
          final totalAmount = defaultFiatAmount + feeAmount;

          emit(BuySellLoaded(
            coin: coinDetails,
            fiatAmount: defaultFiatAmount,
            cryptoAmount: cryptoAmount,
            feePercentage: defaultFeePercentage,
            feeAmount: feeAmount,
            totalAmount: totalAmount,
            exchangeRate: exchangeRate,
          ));
        },
      );
    } catch (e) {
      if (!isClosed) {
        debugPrint('[BuySellCubit] loadCoinDetails unexpected error: $e');
        emit(BuySellError(message: 'An unexpected error occurred: $e'));
      }
    }
  }

  /// Updates fiat amount and recalculates crypto amount
  void updateFiatAmount(double newAmount) {
    final currentState = state;
    if (currentState is! BuySellLoaded) return;

    debugPrint('[BuySellCubit] updateFiatAmount: $newAmount');

    // Recalculate crypto amount based on new fiat amount
    final cryptoAmount = newAmount * currentState.exchangeRate;
    final feeAmount = newAmount * (currentState.feePercentage / 100);
    final totalAmount = newAmount + feeAmount;

    emit(currentState.copyWith(
      fiatAmount: newAmount,
      cryptoAmount: cryptoAmount,
      feeAmount: feeAmount,
      totalAmount: totalAmount,
    ));
  }

  /// Updates crypto amount and recalculates fiat amount
  void updateCryptoAmount(double newAmount) {
    final currentState = state;
    if (currentState is! BuySellLoaded) return;

    debugPrint('[BuySellCubit] updateCryptoAmount: $newAmount');

    // Recalculate fiat amount based on new crypto amount
    final fiatAmount = newAmount / currentState.exchangeRate;
    final feeAmount = fiatAmount * (currentState.feePercentage / 100);
    final totalAmount = fiatAmount + feeAmount;

    emit(currentState.copyWith(
      fiatAmount: fiatAmount,
      cryptoAmount: newAmount,
      feeAmount: feeAmount,
      totalAmount: totalAmount,
    ));
  }

  /// Swaps the entered amounts (fiat <-> crypto)
  void swapAmounts() {
    final currentState = state;
    if (currentState is! BuySellLoaded) return;

    debugPrint('[BuySellCubit] swapAmounts');

    // Just trigger a recalculation
    updateFiatAmount(currentState.fiatAmount);
  }

  /// Processes the buy transaction
  Future<void> processBuyTransaction() async {
    final currentState = state;
    if (currentState is! BuySellLoaded) return;

    debugPrint('[BuySellCubit] processBuyTransaction');
    emit(const BuySellProcessing());

    try {
      // Create transaction record
      final transaction = TransactionRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'buy',
        amount: currentState.cryptoAmount,
        asset: currentState.coin.symbol,
        timestamp: DateTime.now(),
        note: 'Bought ${currentState.cryptoAmount.toStringAsFixed(4)} ${currentState.coin.symbol} for \$${currentState.totalAmount.toStringAsFixed(2)}',
      );

      // Add transaction
      await addTransactionUseCase(transaction);

      if (isClosed) return;

      debugPrint('[BuySellCubit] processBuyTransaction success');
      emit(BuySellSuccess(
        transactionId: transaction.id,
        amount: currentState.cryptoAmount,
        coinSymbol: currentState.coin.symbol,
      ));
    } catch (e) {
      if (!isClosed) {
        debugPrint('[BuySellCubit] processBuyTransaction unexpected error: $e');
        emit(BuySellError(message: 'Transaction failed: $e'));
      }
    }
  }

  /// Refreshes coin price
  Future<void> refreshPrice() async {
    final currentState = state;
    if (currentState is! BuySellLoaded) return;

    debugPrint('[BuySellCubit] refreshPrice');
    await loadCoinDetails(currentState.coin.id);
  }
}
