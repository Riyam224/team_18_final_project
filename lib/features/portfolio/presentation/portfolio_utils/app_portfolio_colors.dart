import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppPortfolioColors {
  AppPortfolioColors._();

  static const Color bitcoin = AppColors.accentPurple;
  static const Color ethereum = AppColors.accentCyan;
  static const Color litecoin = AppColors.accentCoral;
  static const Color cardano = AppColors.cryptoCardano;
  static const Color ripple = AppColors.cryptoRipple;
  static const Color polkadot = AppColors.cryptoPolkadot;
  static const Color binanceCoin = AppColors.cryptoBinance;
  static const Color solana = AppColors.cryptoSolana;
  static const Color dogecoin = AppColors.cryptoDogecoin;
  static const Color polygon = AppColors.cryptoPolygon;

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
