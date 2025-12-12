import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/crypto_price_display.dart';
import 'package:team_18_final_project/features/market/presentation/widget/determine_color_for_button_state.dart';

class CryptoPriceChart extends StatefulWidget {
  final List<FlSpot> chartData;
  final double currentPrice;
  final double changePercentage;
  final Function(String period) onPeriodChanged;

  const CryptoPriceChart({
    super.key,
    required this.chartData,   
    required this.currentPrice, 
    required this.changePercentage, 
    required this.onPeriodChanged,  
  });

  @override
  State<CryptoPriceChart> createState() => _CryptoPriceChartState();
}

class _CryptoPriceChartState extends State<CryptoPriceChart> {

  String selectedPeriod = '1d'; 

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final double minY = widget.chartData.isNotEmpty 
        ? widget.chartData.map((e) => e.y).reduce(min) * 0.95 
        : 0;
    final double maxY = widget.chartData.isNotEmpty 
        ? widget.chartData.map((e) => e.y).reduce(max) * 1.05 
        : 100;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16).r,
      ),
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16).r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CryptoPriceDisplay(
            currentPrice: widget.currentPrice,
            changePercentage: widget.changePercentage,
          ),
          AppSpacing.vertical(12),
          AppSpacing.vertical(
            180,
            child: LineChart(
              LineChartData(
                lineTouchData: lineTouchDataWidget(context),
                minX: 0,
                maxX: widget.chartData.isNotEmpty 
                    ? widget.chartData.last.x 
                    : 24, 
                minY: minY, 
                maxY: maxY, 
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 5, 
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.gray4,
                    strokeWidth: 0.7,
                    dashArray: [9, 9],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: bottomTitlesWidget(context),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _lineChartBarDataWidget(context, widget.chartData), 
                ],
              ),
            ),
          ),
          AppSpacing.vertical(16),
          DetermineColorForButtonState(
            onPeriodSelected: (period) {
              setState(() {
                selectedPeriod = period; 
              });
              widget.onPeriodChanged(period); 
            },
            selectedPeriod: selectedPeriod,
          )
        ],
      ),
    );
  }
  
  LineChartBarData _lineChartBarDataWidget(BuildContext context, List<FlSpot> spots) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LineChartBarData(
      spots: spots,   
      isCurved: true,
      barWidth: 2.0,
      color: isDark ? AppColors.lightSurface : AppColors.primary,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.chartBackground,
            AppColors.chartBackground.withOpacity(0.5),
            Colors.transparent
          ],
        ),
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
              '\$${touchedSpot.y.toStringAsFixed(2)}',    
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
}