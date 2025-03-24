import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventImage extends StatelessWidget {
  final EventModel event;
  const EventImage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.35;

    return Stack(
      children: [
        Image.asset(
          event.imageUrl,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 40,
          left: 16,
          child: _circleButton(() => Get.back(), Icons.arrow_back),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: Obx(() {
            bool isFav = favoriteController.isFavorite(event);
            return _circleButton(
              () => favoriteController.toggleFavorite(event),
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            );
          }),
        ),
      ],
    );
  }

  Widget _circleButton(VoidCallback onTap, IconData icon,
      {Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
