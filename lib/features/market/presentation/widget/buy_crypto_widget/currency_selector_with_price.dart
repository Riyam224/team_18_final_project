import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CurrencySelectorWithPrice extends StatefulWidget {
  final IconData? iconData;
  final Color? iconDataColor;
  final String paymentTitle;
  final String? paymentPrice;
  final Widget? paymentIcon;
  const CurrencySelectorWithPrice(
      {super.key,
      this.iconData,
      required this.paymentTitle,
      this.paymentPrice,
      this.paymentIcon,
      this.iconDataColor});

  @override
  State<CurrencySelectorWithPrice> createState() =>
      _CurrencySelectorWithPriceState();
}

class _CurrencySelectorWithPriceState extends State<CurrencySelectorWithPrice> {
  String currency = "USD";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.paymentTitle,
              style: context.appTheme.textTheme.titleMedium
                  ?.copyWith(fontSize: 11.sp, color: AppColors.gray3),
            ),
            Text(widget.paymentPrice ?? AppStrings.paymentPriceYouPay,
                style: context.appTheme.textTheme.headlineLarge),
          ],
        ),
        Row(
          children: [
            BottomActionButton(
              backgroundColor:
                  context.islight() ? AppColors.gray6 : AppColors.gray9,
              borderRadiusGeometry: BorderRadius.circular(20),
              width: 31.w,
              height: 31.h,
              onPressed: () {},
              child: Center(
                child: widget.paymentIcon ??
                    Icon(
                      color: widget.iconDataColor,
                      widget.iconData,
                      size: 18.sp,
                    ),
              ),
            ),
            const SizedBox(width: 6),
            DropdownButton<String>(
              icon: AppSvgWidget(
                color: context.islight() ? AppColors.gray4 : AppColors.gray2,
                assetsName: AppAssets.keyboardArrowDown,
              ),
              value: currency,
              isDense: true,
              underline: SizedBox.shrink(),
              menuMaxHeight: 150.h,
              items: AppStrings.currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(
                    currency,
                    style: context.appTheme.textTheme.titleSmall?.copyWith(
                        color: context.islight()
                            ? AppColors.primary
                            : AppColors.textWhite,
                        fontSize: 13.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                currency = value ?? "USD";
                setState(() {});
              },
            )
          ],
        ),
      ],
    );
  }
}
