import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BillingPaymentScreen extends StatelessWidget {
  const BillingPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: PrimaryAppBar(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: isDark ? AppColors.textWhite : AppColors.primary,
          onPressed: () => context.go(AppRoutes.settings),
        ),
        title: Text(
          AppStrings.billingPayment,
          style: AppTextStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.textWhite : AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: AppSpacing.paddingHV(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.paymentMethods,
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? AppColors.textWhite : AppColors.textBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapH16,
            _PaymentCardTile(
              title: AppStrings.primaryCard,
              subtitle: '${AppStrings.cardNumberHidden}3456',
              badge: AppStrings.cardVisa,
              asset: AppAssets.visaLogo,
              isDark: isDark,
            ),
            AppSpacing.gapH12,
            _PaymentCardTile(
              title: AppStrings.backupCard,
              subtitle: '${AppStrings.cardNumberHidden}9801',
              badge: AppStrings.cardMastercard,
              asset: AppAssets.mastercardLogo,
              isDark: isDark,
            ),
            AppSpacing.gapH28,
            Text(
              AppStrings.billing,
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? AppColors.textWhite : AppColors.textBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapH16,
            _ActionTile(
              icon: Icons.receipt_long_outlined,
              label: AppStrings.viewInvoices,
              onTap: () {},
              isDark: isDark,
            ),
            _ActionTile(
              icon: Icons.add_card_outlined,
              label: AppStrings.addNewPaymentMethod,
              onTap: () {},
              isDark: isDark,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.lightSurface : AppColors.primary,
                  foregroundColor:
                      isDark ? AppColors.textDark : AppColors.textWhite,
                  padding: AppSpacing.paddingHV(horizontal: 12, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  AppStrings.managePaymentDetails,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isDark ? AppColors.textDark : AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String asset;
  final bool isDark;

  const _PaymentCardTile({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.asset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingH16V14,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48.r,
            width: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                asset,
                height: 22.r,
              ),
            ),
          ),
          AppSpacing.horizontal(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.textWhite : AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapH6,
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDark ? AppColors.textGrayLight : AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: AppSpacing.paddingHV(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(isDark ? 0.25 : 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              badge,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark ? AppColors.textWhite : AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 44.r,
        width: 44.r,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primary.withOpacity(0.25)
              : AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: isDark ? AppColors.textWhite : AppColors.primary,
          size: 22.r,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.titleMedium.copyWith(
          color: isDark ? AppColors.textWhite : AppColors.textBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18.r,
        color: isDark ? AppColors.textGrayLight : AppColors.primary,
      ),
      onTap: onTap,
    );
  }
}
