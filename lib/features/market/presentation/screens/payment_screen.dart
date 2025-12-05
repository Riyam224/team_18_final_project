import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/payment_action_button.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/body/payment_screen_body.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
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
              color: _isDark ? AppColors.textWhite : AppColors.primary,
              size: 23,
            ),
          ),
          title: Text(AppStrings.paymentMethod,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 22.sp,
                    color: _isDark ? AppColors.textWhite : AppColors.primary,
                  )),
        ),
        body: const PaymentScreenBody(),
        bottomNavigationBar: const PaymentActionButton());
  }
}
