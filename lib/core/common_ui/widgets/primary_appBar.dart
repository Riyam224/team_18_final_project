import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? title;
  final double? fromHeight;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final double? bottomOpacity;
  final Color? shadowColor;
  final bool? automaticallyImplyLeading;
  final double? titleSpacing;
  final EdgeInsetsGeometry? actionsPadding;
  final bool? centerTitle;
  final Widget? leading;

  const PrimaryAppBar({
    super.key,
    this.actions,
    this.title,
    this.fromHeight,
    this.backgroundColor,
    this.surfaceTintColor,
    this.elevation,
    this.bottomOpacity,
    this.shadowColor,
    this.automaticallyImplyLeading,
    this.titleSpacing,
    this.actionsPadding,
    this.centerTitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      surfaceTintColor:
          surfaceTintColor ?? Theme.of(context).appBarTheme.surfaceTintColor,
      elevation: elevation ?? 0.0,
      bottomOpacity: bottomOpacity ?? 1.0,
      titleSpacing: titleSpacing ?? 0.0,
      shadowColor: shadowColor ?? Theme.of(context).appBarTheme.shadowColor,
      title: title,
      actionsPadding: actionsPadding,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (fromHeight ?? 0).h);
}
