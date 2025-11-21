import 'package:flutter/material.dart';

class BuySellScreen extends StatelessWidget {
  final String coinId;

  const BuySellScreen({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Buy / Sell Screen for ID: $coinId')),
    );
  }
}
