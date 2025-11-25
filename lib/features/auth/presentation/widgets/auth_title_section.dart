import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 40.h), // required for biometric screens
      ],
    );
  }
}
