import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteAnimationWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final Offset targetPosition;

  const FavoriteAnimationWidget({
    Key? key,
    required this.onComplete,
    required this.targetPosition,
  }) : super(key: key);

  @override
  _FavoriteAnimationWidgetState createState() =>
      _FavoriteAnimationWidgetState();
}

class _FavoriteAnimationWidgetState extends State<FavoriteAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.8), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(widget.targetPosition.dx - Get.width / 2,
          widget.targetPosition.dy - Get.height / 2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().whenComplete(() => widget.onComplete());
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
        return Positioned(
          left: Get.width / 2 + _positionAnimation.value.dx,
          top: Get.height / 2 + _positionAnimation.value.dy,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(Icons.favorite, color: Colors.red, size: 100),
            ),
          ),
        );
      },
    );
  }
}