import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/buy_sell_cubit.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/buy_sell_state.dart';
import 'package:team_18_final_project/features/market/presentation/screens/payment_screen.dart';
import 'package:team_18_final_project/features/market/presentation/widget/buy_crypto_widget/confirm_buy_button.dart';
import 'package:team_18_final_project/features/market/presentation/widget/buy_crypto_widget/crypto_conversion_card.dart';
import 'package:team_18_final_project/features/market/presentation/widget/buy_crypto_widget/fee_and_amount_row.dart';

class BuySellScreen extends StatelessWidget {
  final String coinId;

  const BuySellScreen({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BuySellCubit>()..loadCoinDetails(coinId),
      child: BuySellScreenContent(coinId: coinId),
    );
  }
}

class BuySellScreenContent extends StatelessWidget {
  final String coinId;

  const BuySellScreenContent({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: PrimaryAppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).maybePop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.textWhite : AppColors.primary,
            size: 23,
          ),
        ),
        title: Text('Buy Crypto',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                )),
      ),
      body: BlocConsumer<BuySellCubit, BuySellState>(
        listener: (context, state) {
          if (state is BuySellSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Successfully bought ${state.amount.toStringAsFixed(4)} ${state.coinSymbol}'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back after a short delay
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pop();
              }
            });
          } else if (state is BuySellError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BuySellLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BuySellError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    AppSpacing.gapH16,
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? AppColors.textWhite : AppColors.textDark,
                      ),
                    ),
                    AppSpacing.gapH20,
                    ElevatedButton(
                      onPressed: () {
                        context.read<BuySellCubit>().loadCoinDetails(coinId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is BuySellLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 32).r,
              child: Column(
                children: [
                  CryptoConversionCard(
                    coinSymbol: state.coin.symbol,
                    coinImageUrl: state.coin.image,
                    fiatAmount: state.fiatAmount,
                    cryptoAmount: state.cryptoAmount,
                    exchangeRate: state.exchangeRate,
                    fiatCurrency: state.fiatCurrency,
                    onFiatAmountChanged: (newAmount) {
                      context.read<BuySellCubit>().updateFiatAmount(newAmount);
                    },
                    onCryptoAmountChanged: (newAmount) {
                      context.read<BuySellCubit>().updateCryptoAmount(newAmount);
                    },
                  ),
                  AppSpacing.vertical(34),
                  FeeAndAmountRow(
                    feePercentage: state.feePercentage,
                    feeAmount: state.feeAmount,
                  ),
                  const Spacer(),
                  ConfirmBuyButton(
                    onPressed: () {
                      // Create payment data
                      final paymentData = PaymentData(
                        coinId: state.coin.id,
                        coinSymbol: state.coin.symbol,
                        coinName: state.coin.name,
                        cryptoAmount: state.cryptoAmount,
                        fiatAmount: state.fiatAmount,
                        totalAmount: state.totalAmount,
                        feeAmount: state.feeAmount,
                      );

                      // Navigate to payment screen with data
                      context.push(AppRoutes.payment, extra: paymentData);
                    },
                    isLoading: false,
                  )
                ],
              ),
            );
          }

          if (state is BuySellProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
