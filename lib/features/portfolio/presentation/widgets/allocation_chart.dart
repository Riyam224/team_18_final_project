import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

class AllocationSegment {
  final double value;
  final Color color;
  final String label;

  const AllocationSegment({
    required this.value,
    required this.color,
    required this.label,
  });
}

class AllocationChart extends StatelessWidget {
  final List<AllocationSegment> segments;
  final String centerLabel;

  const AllocationChart({
    super.key,
    required this.segments,
    required this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (sum, seg) => sum + seg.value);
    final isDark = context.isDark();
    final cardColor = isDark ? AppColors.darkBackground : Colors.white;
    final shadowColor =
        isDark ? Colors.black.withOpacity(0.25) : Colors.black.withOpacity(0.06);
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: AppSizing.shadowBlurMedium,
            offset: Offset(0, AppSizing.shadowOffsetMedium),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: AppSizing.h160,
                width: AppSizing.w160,
                child: CustomPaint(
                  painter: _DonutPainter(
                    segments: segments,
                    total: total,
                    isDark: isDark,
                  ),
                  child: Center(
                    child: Text(
                      centerLabel,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textWhite : AppColors.textGray,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: segments
                      .map(
                        (seg) => Padding(
                          padding: AppSpacing.paddingOnly(top: 6, bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                height: AppSizing.w12,
                                width: AppSizing.w12,
                                decoration: BoxDecoration(
                                  color: seg.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              AppSpacing.gapW8,
                              Expanded(
                                child: Text(
                                  seg.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isDark
                                            ? AppColors.textWhiteSoft
                                            : AppColors.textGray,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<AllocationSegment> segments;
  final double total;
  final bool isDark;

  _DonutPainter({
    required this.segments,
    required this.total,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = AppSizing.borderDonut;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth);
    var startAngle = -math.pi / 2;

    final background = Paint()
      ..color = isDark ? AppColors.darkSurface : AppColors.gray6
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, math.pi * 2, false, background);

    if (total <= 0) {
      return;
    }

    for (final seg in segments) {
      final sweep = (seg.value / total) * math.pi * 2;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.total != total;
  }
}
