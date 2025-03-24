import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/event_image.dart';
import 'widgets/event_info.dart';
import 'widgets/subscribe_button.dart';
import 'package:conference_app/controllers/favorite_controller.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    late EventModel event;
    try {
      event = Get.arguments as EventModel;
    } catch (e) {
      return const Scaffold(
          body: Center(child: Text('Error al cargar el evento.')));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              EventImage(event: event),
              EventInfo(event: event),
            ],
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
          SubscribeButton(event: event),
        ],
      ),
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
