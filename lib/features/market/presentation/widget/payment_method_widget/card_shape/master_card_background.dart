import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MasterCardBackground extends StatelessWidget {
  final Widget creditCardContent;
  const MasterCardBackground({super.key, required this.creditCardContent});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned(
          top: -40,
          right: -80,
          child: CustomPaint(
            size: Size(300.w, 250.h),
            painter: ArcPainter(
              color: _isDark
                  ? Color.fromARGB(255, 180, 180, 180).withOpacity(0.2)
                  : Color.fromARGB(255, 200, 200, 200).withOpacity(0.15),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: -60,
          child: CustomPaint(
            size: Size(280.w, 220.h),
            painter: ArcPainter(
              color: _isDark
                  ? Color.fromARGB(255, 200, 200, 200).withOpacity(0.18)
                  : Color.fromARGB(255, 220, 220, 220).withOpacity(0.12),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: HexagonalDotPatternPainter(
              color: _isDark
                  ? Color.fromARGB(255, 200, 200, 200).withOpacity(0.08)
                  : Color.fromARGB(255, 150, 150, 150).withOpacity(0.05),
            ),
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: 23, right: 23, top: 15, bottom: 15)
                    .r,
            child: creditCardContent),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final Color color;

  ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.4,
      size.width * 0.3,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.0,
      size.height * 0.9,
      -size.width * 0.3,
      size.height * 1.0,
    );
    path.lineTo(-size.width * 0.2, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonalDotPatternPainter extends CustomPainter {
  final Color color;

  HexagonalDotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 8.0;
    const double radius = 1.5;

    for (double y = 0; y < size.height; y += spacing * 1.5) {
      final offsetX = (y % (spacing * 2) == 0) ? 0.0 : spacing;
      for (double x = offsetX; x < size.width; x += spacing * 2) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
