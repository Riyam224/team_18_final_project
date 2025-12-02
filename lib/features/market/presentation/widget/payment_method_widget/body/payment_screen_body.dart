import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/check_credit_card_state.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/receipt_email_switch.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_data/google_card_data.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_shape/google_card_background.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/credit_card/credit_card_options_row.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/credit_card/credit_card_widget.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/custom_expansion_title.dart';

class PaymentScreenBody extends StatelessWidget {
  const PaymentScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CustomExpansionTitle(title: AppStrings.creditCard, children: [
            CreditCardOptionsRow(
              checkCreditCardState: CheckCreditCardState(),
            ),
            // AppSpacing.vertical(24),
          ]),
        ),
        SliverToBoxAdapter(
          child: CustomExpansionTitle(title: AppStrings.googlePay, children: [
            CreditCardWidget(
                onTap: () {},
                colorBegin: AppColors.gray5,
                colorEnd: AppColors.gray5,
                creditCardBackground:
                    GoogleCardBackground(creditCardContent: GoogleCardData()))
          ]),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const CustomExpansionTitle(
                  title: AppStrings.mobileBanking, children: []),
              ReceiptEmailSwitch()
            ],
          ),
        ),
      ],
    );
  }
}
