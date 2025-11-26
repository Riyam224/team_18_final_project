import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/crypto_price_display.dart';
import 'package:team_18_final_project/features/market/presentation/widget/determine_color_for_button_state.dart';

class CryptoPriceChart extends StatefulWidget {
  const CryptoPriceChart({super.key});

  @override
  State<CryptoPriceChart> createState() => _CryptoPriceChartState();
}

class _CryptoPriceChartState extends State<CryptoPriceChart> {
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    spots = _generateWave();
  }

  List<FlSpot> _generateWave() {
    Random random = Random();
    List<FlSpot> newSpots = [];
    for (int i = 0; i <= 24; i += 2) {
      double y = random.nextDouble() * 50 + 30;
      newSpots.add(FlSpot(i.toDouble(), y));
    }
    return newSpots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark()
            ? AppColors.darkBackground
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16).r,
      ),
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16).r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CryptoPriceDisplay(),
          AppSpacing.vertical(12),
          AppSpacing.vertical(
            180,
            child: GestureDetector(
              onHorizontalDragUpdate: (_) {
                setState(() {
                  spots = _generateWave();
                });
              },
              child: LineChart(
                LineChartData(
                  lineTouchData: lineTouchDataWidget(context),
                  minX: 0,
                  maxX: 24,
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 12,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.gray4,
                      strokeWidth: 0.7,
                      dashArray: [9, 9],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: bottomTitlesWidget(context),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _lineChartBarDataWidget(context),
                  ],
                ),
              ),
            ),
          ),
          AppSpacing.vertical(16),
          DetermineColorForButtonState()
        ],
      ),
    );
  }

  LineTouchData lineTouchDataWidget(BuildContext context) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBorderRadius: BorderRadius.circular(10.r),
        getTooltipColor: (spot) => Theme.of(context).colorScheme.secondary,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            return LineTooltipItem(
              '\$${touchedSpot.y.toStringAsFixed(5)}',
              TextStyle(
                color: touchedSpot.bar.gradient != null
                    ? touchedSpot.bar.gradient!.colors.first
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  AxisTitles bottomTitlesWidget(BuildContext context) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 25,
        interval: 4,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            space: 8,
            fitInside: SideTitleFitInsideData(
                enabled: true,
                axisPosition: meta.axisPosition,
                parentAxisSize: meta.parentAxisSize,
                distanceFromEdge: 0),
            meta: meta,
            child: Row(
              children: [
                Text(
                  '${value.toInt().toString().padLeft(2, '0')}.00',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: AppColors.gray2, fontSize: 9.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  LineChartBarData _lineChartBarDataWidget(BuildContext context) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2.0,
      color: context.isDark() ? AppColors.lightSurface : AppColors.primary,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 35, 35, 86),
            const Color(0xff001133).withOpacity(0.5),
            Colors.transparent
          ],
        ),
      ),
    );
  }
}
