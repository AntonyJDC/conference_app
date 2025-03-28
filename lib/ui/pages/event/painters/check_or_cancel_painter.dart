import 'package:flutter/material.dart';
import 'dart:ui';

class CheckOrCancelPainter extends CustomPainter {
  final double progress;
  final bool isCheck;

  CheckOrCancelPainter({required this.progress, required this.isCheck});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isCheck ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final double width = size.width;
    final double height = size.height;

    if (isCheck) {
      // ✅ Dibujar el check (como en PayPal)
      final path = Path();
      path.moveTo(width * 0.2, height * 0.5);
      path.lineTo(width * 0.4, height * 0.75);
      path.lineTo(width * 0.8, height * 0.3);

      final PathMetrics pathMetrics = path.computeMetrics();
      final Path extractPath = Path();

      for (final metric in pathMetrics) {
        extractPath.addPath(
          metric.extractPath(0, metric.length * progress),
          Offset.zero,
        );
      }

      canvas.drawPath(extractPath, paint);
    } else {
      // ❌ Dibujar la X (cancelación)
      final path = Path();
      path.moveTo(width * 0.2, height * 0.2);
      path.lineTo(width * 0.8, height * 0.8);
      path.moveTo(width * 0.8, height * 0.2);
      path.lineTo(width * 0.2, height * 0.8);

      final PathMetrics pathMetrics = path.computeMetrics();
      final Path extractPath = Path();

      for (final metric in pathMetrics) {
        extractPath.addPath(
          metric.extractPath(0, metric.length * progress),
          Offset.zero,
        );
      }

      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CheckOrCancelPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}