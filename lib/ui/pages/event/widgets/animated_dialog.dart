import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedDialog extends StatefulWidget {
  final IconData icon;
  final String message;
  final VoidCallback onConfirm;
  final bool isCancellation; // Indica si es una cancelación (para animaciones distintas)

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _dismissDialog() async {
    if (widget.isCancellation) {
      // Simulación del efecto de apagado de TV para cancelación
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
              Icon(widget.icon, color: Colors.blue, size: 60),
              const SizedBox(height: 15),
              Text(
                widget.message,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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