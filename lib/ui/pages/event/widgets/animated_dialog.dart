import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:conference_app/ui/pages/event/painters/check_or_cancel_painter.dart';

class AnimatedDialog extends StatefulWidget {
  final IconData icon;
  final String message;
  final VoidCallback onConfirm;
  final bool isCancellation;

  const AnimatedDialog({
    Key? key,
    required this.icon,
    required this.message,
    required this.onConfirm,
    this.isCancellation = false,
  }) : super(key: key);

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _dismissDialog() async {
    if (widget.isCancellation) {
      await _controller.reverse();
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(60, 60),
                    painter: CheckOrCancelPainter(
                      progress: _iconAnimation.value,
                      isCheck: !widget.isCancellation,
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Text(
                widget.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _dismissDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
