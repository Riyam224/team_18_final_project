import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CustomExpansionTitle extends StatefulWidget {
  final List<Widget>? children;
  final String title;
  final TextStyle? style;
  final double? fontSize;
  final Color? colorText;

  const CustomExpansionTitle({
    super.key,
    required this.children,
    required this.title,
    this.colorText,
    this.fontSize,
    this.style,
  });

  @override
  State<CustomExpansionTitle> createState() => _CustomExpansionTitleState();
}

class _CustomExpansionTitleState extends State<CustomExpansionTitle> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    Color _backgroundColor =
        _isDark ? AppColors.lightSurface : AppColors.darkBackground;
    return Theme(
        data: _theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).r,
          child: ExpansionTile(
            enableFeedback: true,
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            dense: true,
            minTileHeight: 56.h,
            tilePadding: EdgeInsets.symmetric(horizontal: 19).r,
            trailing: AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: Duration(milliseconds: 200),
                child: AppSvgWidget(
                  assetsName: _isExpanded == false
                      ? AppAssets.keyboardArrowLeft
                      : AppAssets.keyboardArrowUp,
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            collapsedIconColor: Colors.amber,
            iconColor: Colors.blue,
            collapsedBackgroundColor: _backgroundColor,
            backgroundColor: _backgroundColor,
            title: Text(
              widget.title,
              style: widget.style ??
                  AppTextStyles.headlineMedium.copyWith(
                    color: widget.colorText ??
                        (_isDark ? AppColors.textWhite : AppColors.primary),
                    fontSize: widget.fontSize ?? 16.sp,
                  ),
            ),
            children: widget.children ?? [],
          ),
        ));
  }
}
