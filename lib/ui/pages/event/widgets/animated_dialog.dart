import 'package:conference_app/ui/pages/event/painters/check_or_cancel_painter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void showAnimatedDialog(BuildContext context, String message,
    {required bool isCheck}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AnimatedDialog(message: message, isCheck: isCheck),
  );
}

class AnimatedDialog extends StatefulWidget {
  final String message;
  final bool isCheck;

  const AnimatedDialog({
    super.key,
    required this.message,
    required this.isCheck,
  });

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Cerrar automáticamente después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CheckOrCancelPainter(
                      progress: _animation.value,
                      isCheck: widget.isCheck,
                    ),
                    size: const Size(60, 60),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}