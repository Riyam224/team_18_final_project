import 'package:flutter/material.dart';

class CustomIconWithBg extends StatelessWidget {
  final Color? backgroundColor;
  final String iconImg;
  final Color? iconColor;
  final double? size;

  final void Function()? onTap;

  const CustomIconWithBg({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size,
    required this.iconImg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(iconImg, width: 25, height: 25),
        ),
      ),
    );
  }
}
