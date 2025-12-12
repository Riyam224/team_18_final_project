import 'package:equatable/equatable.dart';

/// Represents a single point on the price chart.
/// `x` is the timestamp converted to hours, `y` is the price value.
class ChartPoint extends Equatable {
  final double x;
  final double y;

  const ChartPoint({required this.x, required this.y});

  @override
  List<Object?> get props => [x, y];
}
