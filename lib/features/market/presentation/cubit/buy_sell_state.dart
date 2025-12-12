import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';

/// Base state for buy/sell screen
abstract class BuySellState extends Equatable {
  const BuySellState();

  @override
  List<Object?> get props => [];
}

/// Initial state when screen is first loaded
class BuySellInitial extends BuySellState {
  const BuySellInitial();
}

/// Loading state while fetching coin data
class BuySellLoading extends BuySellState {
  const BuySellLoading();
}

/// Loaded state with coin data and conversion calculations
class BuySellLoaded extends BuySellState {
  /// The coin being purchased
  final CoinDetailsEntity coin;

  /// Amount in fiat currency (USD) the user wants to pay
  final double fiatAmount;

  /// Amount in crypto the user will receive
  final double cryptoAmount;

  /// Selected fiat currency (default: USD)
  final String fiatCurrency;

  /// Exchange fee percentage (default: 0.05%)
  final double feePercentage;

  /// Calculated exchange fee in fiat currency
  final double feeAmount;

  /// Total amount including fee
  final double totalAmount;

  /// Exchange rate (1 USD = X crypto)
  final double exchangeRate;

  const BuySellLoaded({
    required this.coin,
    required this.fiatAmount,
    required this.cryptoAmount,
    this.fiatCurrency = 'USD',
    this.feePercentage = 0.05,
    required this.feeAmount,
    required this.totalAmount,
    required this.exchangeRate,
  });

  @override
  List<Object?> get props => [
        coin,
        fiatAmount,
        cryptoAmount,
        fiatCurrency,
        feePercentage,
        feeAmount,
        totalAmount,
        exchangeRate,
      ];

  /// Creates a copy of this state with updated values
  BuySellLoaded copyWith({
    CoinDetailsEntity? coin,
    double? fiatAmount,
    double? cryptoAmount,
    String? fiatCurrency,
    double? feePercentage,
    double? feeAmount,
    double? totalAmount,
    double? exchangeRate,
  }) {
    return BuySellLoaded(
      coin: coin ?? this.coin,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      cryptoAmount: cryptoAmount ?? this.cryptoAmount,
      fiatCurrency: fiatCurrency ?? this.fiatCurrency,
      feePercentage: feePercentage ?? this.feePercentage,
      feeAmount: feeAmount ?? this.feeAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }
}

/// Error state when something goes wrong
class BuySellError extends BuySellState {
  final String message;

  const BuySellError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Processing transaction state
class BuySellProcessing extends BuySellState {
  const BuySellProcessing();
}

/// Transaction completed successfully
class BuySellSuccess extends BuySellState {
  final String transactionId;
  final double amount;
  final String coinSymbol;

  const BuySellSuccess({
    required this.transactionId,
    required this.amount,
    required this.coinSymbol,
  });

  @override
  List<Object?> get props => [transactionId, amount, coinSymbol];
}
