class TransactionRecord {
  final String id;
  final String type; // e.g., buy, sell, transfer
  final double amount;
  final String asset; // currency or token symbol
  final DateTime timestamp;
  final String? note;

  const TransactionRecord({
    required this.id,
    required this.type,
    required this.amount,
    required this.asset,
    required this.timestamp,
    this.note,
  });

  TransactionRecord copyWith({
    String? id,
    String? type,
    double? amount,
    String? asset,
    DateTime? timestamp,
    String? note,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      asset: asset ?? this.asset,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'asset': asset,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };

  factory TransactionRecord.fromMap(Map<String, dynamic> map) {
    return TransactionRecord(
      id: (map['id'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      amount: (map['amount'] ?? 0).toDouble(),
      asset: (map['asset'] ?? '') as String,
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(),
      note: map['note'] as String?,
    );
  }
}
