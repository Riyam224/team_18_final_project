import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
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
    return Scaffold(
        appBar: PrimaryAppBar(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: Icon(
            Icons.arrow_back_rounded,
            color: context.isDark() ? AppColors.textWhite : AppColors.primary,
            size: 23,
          ),
          title: Text(AppStrings.buyCrypto,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22.sp,
                    color: context.isDark()
                        ? AppColors.textWhite
                        : AppColors.primary,
                  )),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 32).r,
          child: Column(
            children: [
              const CryptoConversionCard(),
              AppSpacing.vertical(34),
              const FeeAndAmountRow(),
              const Spacer(),
              const ConfirmBuyButton()
            ],
          ),
        ));
  }
}
