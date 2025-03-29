import 'dart:math';
import 'package:flutter/material.dart';

class ExplosionAnimationWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final Offset targetPosition;

  const ExplosionAnimationWidget({
    super.key,
    required this.onComplete,
    required this.targetPosition,
  });

  @override
  _ExplosionAnimationWidgetState createState() =>
      _ExplosionAnimationWidgetState();
}

class _ExplosionAnimationWidgetState extends State<ExplosionAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _moveAnimations;
  late List<Animation<double>> _rotateAnimations;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward().whenComplete(() => widget.onComplete());

    final random = Random();

    _moveAnimations = List.generate(6, (index) {
      final dx = (random.nextDouble() - 0.5) * 100;
      final dy = (random.nextDouble() - 0.5) * 100;
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(dx, dy),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    });

    _rotateAnimations = List.generate(6, (index) {
      final rotation = (random.nextDouble() - 0.5) * 2 * pi;
      return Tween<double>(begin: 0, end: rotation).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    });

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            return Positioned(
              left: widget.targetPosition.dx + _moveAnimations[index].value.dx,
              top: widget.targetPosition.dy + _moveAnimations[index].value.dy,
              child: Transform.rotate(
                angle: _rotateAnimations[index].value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _fadeAnimation.value,
                    child: CustomPaint(
                      size: const Size(20, 20),
                      painter: HeartFragmentPainter(index),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class HeartFragmentPainter extends CustomPainter {
  final int fragmentIndex;

  HeartFragmentPainter(this.fragmentIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final path = Path();
    switch (fragmentIndex % 3) {
      case 0:
        path.moveTo(size.width * 0.5, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case 1:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height * 0.5);
        path.lineTo(0, size.height);
        break;
      case 2:
        path.moveTo(size.width, 0);
        path.lineTo(size.width * 0.5, size.height);
        path.lineTo(0, 0);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
