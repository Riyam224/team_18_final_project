import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final IconData? icon;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 45,
      height: size ?? 45,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed ??
            () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              }
            },
        icon: Icon(
          icon ?? Icons.arrow_back,
          color: iconColor ?? Colors.black87,
          size: 24,
        ),
      ),
    );
  }
}
