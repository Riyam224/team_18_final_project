import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/chart_point.dart';

class CoinChartModel extends Equatable {
  final List<ChartPoint> points;

  const CoinChartModel({required this.points});

  @override
  List<Object?> get props => [points];

  factory CoinChartModel.fromJson(Map<String, dynamic> json) {
    final List pricesRaw = json['prices'] ?? [];

    // Normalize timestamps so x-values start at 0 to avoid extremely large
    // axis ranges (which were locking up the chart with thousands of labels).
    int? firstTimestampMs;
    final List<ChartPoint> parsed = pricesRaw.map((point) {
      final timestampMs = (point[0] as num?)?.toInt() ?? 0;
      firstTimestampMs ??= timestampMs;
      final hoursSinceStart =
          (timestampMs - firstTimestampMs!) / 3600000; // ms -> hours delta

      final double price = (point[1] as num?)?.toDouble() ?? 0;
      return ChartPoint(x: hoursSinceStart.toDouble(), y: price);
    }).toList();

    return CoinChartModel(points: parsed);
  }

  List<ChartPoint> toPoints() => points;
}
