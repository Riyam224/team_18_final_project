import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppPortfolioColors {
  AppPortfolioColors._();

  static Color get bitcoin => AppColors.accentPurple;
  static Color get ethereum => AppColors.accentCyan;
  static Color get litecoin => AppColors.accentCoral;
  static Color get cardano => AppColors.cryptoCardano;
  static Color get ripple => AppColors.cryptoRipple;
  static Color get polkadot => AppColors.cryptoPolkadot;
  static Color get binanceCoin => AppColors.cryptoBinance;
  static Color get solana => AppColors.cryptoSolana;
  static Color get dogecoin => AppColors.cryptoDogecoin;
  static Color get polygon => AppColors.cryptoPolygon;

  static Color getCryptoColor(String cryptoId) {
    switch (cryptoId.toLowerCase()) {
      case 'bitcoin':
      case 'btc':
        return bitcoin;
      case 'ethereum':
      case 'eth':
        return ethereum;
      case 'litecoin':
      case 'ltc':
        return litecoin;
      case 'cardano':
      case 'ada':
        return cardano;
      case 'ripple':
      case 'xrp':
        return ripple;
      case 'polkadot':
      case 'dot':
        return polkadot;
      case 'binancecoin':
      case 'bnb':
        return binanceCoin;
      case 'solana':
      case 'sol':
        return solana;
      case 'dogecoin':
      case 'doge':
        return dogecoin;
      case 'matic-network':
      case 'matic':
      case 'polygon':
        return polygon;
      default:
        return AppColors.cryptoDefault;
    }
  }

  static IconData getCryptoIcon(String cryptoId) {
    switch (cryptoId.toLowerCase()) {
      case 'bitcoin':
      case 'btc':
        return Icons.currency_bitcoin;
      case 'ethereum':
      case 'eth':
        return Icons.token;
      case 'litecoin':
      case 'ltc':
        return Icons.currency_exchange;
      case 'cardano':
      case 'ada':
        return Icons.account_balance_wallet;
      case 'ripple':
      case 'xrp':
        return Icons.waves;
      case 'polkadot':
      case 'dot':
        return Icons.circle_outlined;
      case 'binancecoin':
      case 'bnb':
        return Icons.paid;
      case 'solana':
      case 'sol':
        return Icons.flash_on;
      case 'dogecoin':
      case 'doge':
        return Icons.pets;
      case 'matic-network':
      case 'matic':
      case 'polygon':
        return Icons.hexagon_outlined;
      default:
        return Icons.monetization_on;
    }
  }
}
