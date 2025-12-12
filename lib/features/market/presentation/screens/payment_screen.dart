import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/payment_action_button.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/payment_screen_body.dart';

class PaymentData {
  final String coinId;
  final String coinSymbol;
  final String coinName;
  final double cryptoAmount;
  final double fiatAmount;
  final double totalAmount;
  final double feeAmount;

  const PaymentData({
    required this.coinId,
    required this.coinSymbol,
    required this.coinName,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.totalAmount,
    required this.feeAmount,
  });
}

class PaymentScreen extends StatelessWidget {
  final PaymentData paymentData;

  const PaymentScreen({
    super.key,
    required this.paymentData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
        appBar: PrimaryAppBar(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textWhite : AppColors.primary,
              size: 23,
            ),
          ),
          title: Text(AppStrings.paymentMethod,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22.sp,
                    color: isDark ? AppColors.textWhite : AppColors.primary,
                  )),
        ),
        body: const PaymentScreenBody(),
        bottomNavigationBar: PaymentActionButton(paymentData: paymentData));
  }
}
