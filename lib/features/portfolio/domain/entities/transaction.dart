import 'package:equatable/equatable.dart';

enum TransactionType { buy, sell }

class Transaction extends Equatable {
  final String id;
  final String cryptoName;
  final String cryptoSymbol;
  final TransactionType type;
  final double amount;
  final double valueUsd;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.cryptoName,
    required this.cryptoSymbol,
    required this.type,
    required this.amount,
    required this.valueUsd,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        cryptoName,
        cryptoSymbol,
        type,
        amount,
        valueUsd,
        timestamp,
      ];
}
