import 'package:flutter/material.dart';
import 'dart:math';

class CheckOrCancelPainter extends CustomPainter {
  final double progress;
  final bool isCheck;

  CheckOrCancelPainter({required this.progress, required this.isCheck});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCheck ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    if (isCheck) {
      _drawCheck(canvas, size, paint);
    } else {
      _drawCancel(canvas, size, paint);
    }
  }

  void _drawCheck(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double tickLength = min(size.width, size.height) * 0.4;
    final double startX = size.width * 0.2;
    final double startY = size.height * 0.5;
    final double midX = startX + tickLength;
    final double midY = startY + tickLength;
    final double endX = midX + tickLength;
    final double endY = startY - tickLength;

    if (progress < 0.5) {
      path.moveTo(startX, startY);
      path.lineTo(startX + (midX - startX) * (progress * 2),
          startY + (midY - startY) * (progress * 2));
    } else {
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.lineTo(midX + (endX - midX) * ((progress - 0.5) * 2),
          midY + (endY - midY) * ((progress - 0.5) * 2));
    }

    canvas.drawPath(path, paint);
  }

  void _drawCancel(Canvas canvas, Size size, Paint paint) {
    final path1 = Path();
    final path2 = Path();

    final startX = size.width * 0.2;
    final endX = size.width * 0.8;
    final startY = size.height * 0.2;
    final endY = size.height * 0.8;

    path1.moveTo(startX, startY);
    path2.moveTo(startX, endY);

    path1.lineTo(startX + (endX - startX) * progress,
        startY + (endY - startY) * progress);
    path2.lineTo(
        startX + (endX - startX) * progress, endY - (endY - startY) * progress);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
