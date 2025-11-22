import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class ViewAll extends StatelessWidget {
  final String title;

  const ViewAll({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
        letterSpacing: 0.24.w,
        color: theme.brightness == Brightness.dark
            ? AppColors.viewAll
            : AppColors.primary,
      ),
    );
  }
}
