import 'package:flutter/material.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Coin Details Screen for ID: $coinId')),
    );
  }
}
