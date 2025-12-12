import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CurrencySelectorWithPrice extends StatefulWidget {
  final IconData? iconData;
  final Color? iconDataColor;
  final String paymentTitle;
  final String paymentPrice;
  final Widget? paymentIcon;
  final String currency;
  final Function(double)? onAmountChanged;

  const CurrencySelectorWithPrice({
    super.key,
    this.iconData,
    required this.paymentTitle,
    required this.paymentPrice,
    this.paymentIcon,
    this.iconDataColor,
    this.currency = 'USD',
    this.onAmountChanged,
  });

  @override
  State<CurrencySelectorWithPrice> createState() =>
      _CurrencySelectorWithPriceState();
}

class _CurrencySelectorWithPriceState extends State<CurrencySelectorWithPrice> {
  late TextEditingController _priceController;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currency;
    _priceController = TextEditingController(text: widget.paymentPrice);
  }

  @override
  void didUpdateWidget(CurrencySelectorWithPrice oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if price changed externally
    if (oldWidget.paymentPrice != widget.paymentPrice) {
      _priceController.text = widget.paymentPrice;
    }
    if (oldWidget.currency != widget.currency) {
      _selectedCurrency = widget.currency;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _onPriceChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    final numValue = double.tryParse(cleaned);
    if (numValue != null && widget.onAmountChanged != null) {
      widget.onAmountChanged!(numValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.paymentTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontSize: 11.sp, color: AppColors.gray3),
              ),
              TextField(
                controller: _priceController,
                style: theme.textTheme.headlineLarge,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: '0.00',
                  hintStyle: theme.textTheme.headlineLarge?.copyWith(
                    color: AppColors.gray3.withOpacity(0.5),
                  ),
                ),
                onChanged: _onPriceChanged,
              ),
            ],
          ),
        ),
        Row(
          children: [
            BottomActionButton(
              backgroundColor: isDark ? AppColors.gray9 : AppColors.gray6,
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
                color: isDark ? AppColors.gray2 : AppColors.gray4,
                assetsName: AppAssets.keyboardArrowDown,
              ),
              value: _selectedCurrency,
              isDense: true,
              underline: const SizedBox.shrink(),
              menuMaxHeight: 150.h,
              items: AppStrings.currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(
                    currency,
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textWhite : AppColors.primary,
                        fontSize: 13.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value ?? "USD";
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
