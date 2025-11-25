import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'auth_header.dart';

class AuthTitleSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthTitleSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthHeader(title: title, subtitle: subtitle),
        AppSpacing.vSpace40, // required for biometric screens
      ],
    );
  }
}
