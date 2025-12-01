import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedBg = isDark ? Colors.white.withOpacity(0.08) : Colors.white;
    final borderColor =
        isSelected ? (isDark ? Colors.white70 : AppColors.primary) : Colors.transparent;
    final textColor =
        isSelected ? (isDark ? Colors.white : AppColors.primary) : (isDark ? AppColors.textWhiteSoft : AppColors.gray2);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
