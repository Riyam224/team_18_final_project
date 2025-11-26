import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/app_rich_text.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/buy_crypto_widget/currency_selector_with_price.dart';

class CryptoConversionCard extends StatefulWidget {
  const CryptoConversionCard({super.key});

  @override
  State<CryptoConversionCard> createState() => _CryptoConversionCardState();
}

class _CryptoConversionCardState extends State<CryptoConversionCard> {
  String sss = "USD";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18).r,
      decoration: BoxDecoration(
        color: context.isDark()
            ? AppColors.darkBackground
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencySelectorWithPrice(
            paymentTitle: AppStrings.paymentTitleYouPay,
            iconData: Icons.attach_money,
            iconDataColor: context.isDark()
                ? AppColors.lightSurface
                : AppColors.darkBackground,
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
            paymentIcon: AppSvgWidget(
              assetsName:
                  context.islight() ? AppAssets.ethLight : AppAssets.ethDark,
            ),
            paymentPrice: AppStrings.paymentPriceYouReceive,
            paymentTitle: AppStrings.paymentTitleYouReceive,
          ),
          AppSpacing.vertical(16),
          Center(
              child: AppRichText(
                  horizontal: 5,
                  fristText: AppStrings.cryptoExchangeRate,
                  fristStyle: context.appTheme.textTheme.titleMedium
                      ?.copyWith(fontSize: 14.sp, color: AppColors.gray3),
                  lastStyle: context.appTheme.textTheme.titleMedium
                      ?.copyWith(fontSize: 14.sp, color: AppColors.secondary),
                  lastText: AppStrings.circle))
        ],
      ),
    );
  }
}
