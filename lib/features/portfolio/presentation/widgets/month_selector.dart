import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const MonthSelector({
    super.key,
    required this.months,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < widget.months.length; i++)
          _MonthChip(
            label: widget.months[i],
            isSelected: i == _selected,
            onTap: () {
              setState(() => _selected = i);
              widget.onChanged?.call(i);
            },
          ),
      ],
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MonthChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark();
    final selectedBg = isDark ? Colors.white.withOpacity(0.08) : Colors.white;
    final borderColor =
        isSelected ? (isDark ? Colors.white70 : AppColors.primary) : Colors.transparent;
    final textColor =
        isSelected ? (isDark ? Colors.white : AppColors.primary) : (isDark ? AppColors.textWhiteSoft : AppColors.gray2);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingH12V8,
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizing.radius12),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
