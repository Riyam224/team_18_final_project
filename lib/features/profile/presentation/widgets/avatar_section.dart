import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AvatarSection extends StatelessWidget {
  const AvatarSection({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.email,
    required this.onUpload,
  });

  final String? avatarUrl;
  final String displayName;
  final String email;
  final VoidCallback onUpload;

  ImageProvider _resolveAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('assets/')) {
        return AssetImage(avatarUrl!);
      }
      if (avatarUrl!.startsWith('http')) {
        return NetworkImage(avatarUrl!);
      }
    }
    return const AssetImage(AppAssets.profileGirl);
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = _resolveAvatar();

    return Column(
      children: [
        GestureDetector(
          onTap: onUpload,
          child: CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            backgroundImage: imageProvider,
          ),
        ),
        AppSpacing.gapH12,
        Text(
          displayName.isNotEmpty ? displayName : AppStrings.myAccount,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.gapH4,
        Text(
          email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
