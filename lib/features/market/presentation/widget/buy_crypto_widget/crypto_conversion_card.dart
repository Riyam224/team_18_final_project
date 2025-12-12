import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/app_rich_text.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/buy_crypto_widget/currency_selector_with_price.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CryptoConversionCard extends StatelessWidget {
  final String coinSymbol;
  final String? coinImageUrl;
  final double fiatAmount;
  final double cryptoAmount;
  final double exchangeRate;
  final String fiatCurrency;
  final Function(double) onFiatAmountChanged;
  final Function(double) onCryptoAmountChanged;

  const CryptoConversionCard({
    super.key,
    required this.coinSymbol,
    this.coinImageUrl,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.exchangeRate,
    this.fiatCurrency = 'USD',
    required this.onFiatAmountChanged,
    required this.onCryptoAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding:
          const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18).r,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencySelectorWithPrice(
            paymentTitle: 'You Pay',
            paymentPrice: '\$${fiatAmount.toStringAsFixed(2)}',
            iconData: Icons.attach_money,
            iconDataColor:
                isDark ? AppColors.lightSurface : AppColors.darkBackground,
            currency: fiatCurrency,
            onAmountChanged: onFiatAmountChanged,
          ),
          AppSpacing.vertical(20),
          Row(
            children: [
              Expanded(
                  child: Divider(
                color: AppColors.gray2,
              )),
              AppSpacing.horizontal(8),
              AppSvgWidget(
                assetsName: AppAssets.swap,
              ),
              AppSpacing.horizontal(8),
              Expanded(
                  child: Divider(
                color: AppColors.gray2,
              )),
            ],
          ),
          AppSpacing.vertical(20),
          CurrencySelectorWithPrice(
            paymentIcon: coinImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: coinImageUrl!,
                      width: 18.sp,
                      height: 18.sp,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.currency_bitcoin,
                        size: 18.sp,
                      ),
                    ),
                  )
                : AppSvgWidget(
                    assetsName: isDark ? AppAssets.ethDark : AppAssets.ethLight,
                  ),
            paymentPrice: cryptoAmount.toStringAsFixed(4),
            paymentTitle: 'You Receive',
            currency: coinSymbol,
            onAmountChanged: onCryptoAmountChanged,
          ),
          AppSpacing.vertical(16),
          Center(
              child: AppRichText(
                  horizontal: 5,
                  firstText: '1 $fiatCurrency = ${exchangeRate.toStringAsFixed(6)} $coinSymbol',
                  firstStyle: theme.textTheme.titleMedium
                      ?.copyWith(fontSize: 14.sp, color: AppColors.gray3),
                  lastStyle: theme.textTheme.titleMedium
                      ?.copyWith(fontSize: 14.sp, color: AppColors.secondary),
                  lastText: '●'))
        ],
      ),
    );
  }
}
