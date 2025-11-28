import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';

class AppRichText extends StatelessWidget {
  final String firstText;
  final String lastText;
  final void Function()? onTap;
  final TextStyle? firstStyle;
  final TextStyle? lastStyle;
  final double? horizontal;
  const AppRichText({
    super.key,
    required this.firstText,
    required this.lastText,
    this.onTap,
    this.firstStyle,
    this.lastStyle,
    this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: lastStyle,
            text: lastText,
          ),
          WidgetSpan(child: AppSpacing.horizontal(horizontal ?? 0)),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: firstStyle,
            text: firstText,
          ),
        ],
      ),
    );
  }
}
