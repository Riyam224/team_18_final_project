import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class FaqSupportScreen extends StatelessWidget {
  const FaqSupportScreen({super.key});

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
        title: Text(
          AppStrings.faqSupport,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.popularQuestions,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapH12,
              ..._faqs.map((faq) => _FaqTile(
                    question: faq.$1,
                    answer: faq.$2,
                    isDark: isDark,
                  )),
              AppSpacing.gapH24,
              Text(
                AppStrings.needMoreHelp,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapH12,
              _SupportCard(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

final List<(String, String)> _faqs = [
  (AppStrings.faqUpdateBillingQuestion, AppStrings.faqUpdateBillingAnswer),
  (AppStrings.faqExportInvoicesQuestion, AppStrings.faqExportInvoicesAnswer),
  (AppStrings.faqContactSupportQuestion, AppStrings.faqContactSupportAnswer),
];

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isDark;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.marginOnly(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
          tilePadding: AppSpacing.paddingHV(horizontal: 14, vertical: 6),
          childrenPadding: AppSpacing.paddingOnly(
            left: 14,
            right: 14,
            bottom: 12,
          ),
          iconColor: isDark ? AppColors.textWhite : AppColors.primary,
          collapsedIconColor:
              isDark ? AppColors.textGrayLight : AppColors.primary,
          title: Text(
            question,
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.textWhite : AppColors.textBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textGrayLight : AppColors.textGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final bool isDark;

  const _SupportCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44.r,
                width: 44.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withOpacity(0.25)
                      : AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.support_agent_outlined,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                  size: 22.r,
                ),
              ),
              AppSpacing.horizontal(12),
              Expanded(
                child: Text(
                  AppStrings.contactSupport,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.textWhite : AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH12,
          Text(
            AppStrings.supportResponseTime,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
          ),
          AppSpacing.gapH16,
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
                AppStrings.startChat,
                style: AppTextStyles.titleSmall.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.textWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
