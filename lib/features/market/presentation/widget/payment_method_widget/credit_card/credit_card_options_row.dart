import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/config/check_credit_card_state.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CreditCardOptionsRow extends StatefulWidget {
  final CheckCreditCardState checkCreditCardState;
  const CreditCardOptionsRow({super.key, required this.checkCreditCardState});

  @override
  State<CreditCardOptionsRow> createState() => _CreditCardOptionsRowState();
}

class _CreditCardOptionsRowState extends State<CreditCardOptionsRow> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Column(
      children: [
        AppSpacing.vertical(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(AppStrings.cards.length, (int index) {
            return BottomActionButton(
                backgroundColor:
                    (index == widget.checkCreditCardState.getSelectedCardIndex)
                        ? (_isDark ? AppColors.primary : AppColors.darkSurface)
                        : _isDark
                            ? AppColors.lightSurface
                            : AppColors.primary,
                borderRadiusGeometry: BorderRadius.circular(12).r,
                onPressed: () {
                  setState(() {
                    widget.checkCreditCardState.selectCardByIndex(index: index);
                  });
                },
                height: 36.h,
                width: 93.w,
                child: AppSvgWidget(
                  color: (index == 1)
                      ? null
                      : (index ==
                              widget.checkCreditCardState.getSelectedCardIndex)
                          ? (_isDark
                              ? AppColors.textWhite
                              : AppColors.textWhite)
                          : _isDark
                              ? AppColors.textDark
                              : AppColors.textWhite,
                  assetsName: AppStrings.cards[index],
                ));
          }),
        ),
        Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            maintainSemantics: true,
            maintainInteractivity: true,
            visible: widget.checkCreditCardState.getIsCreditCardVisible,
            child: widget.checkCreditCardState.getCardType
                .buildCardWidget(context: context))
      ],
    );
  }
}
