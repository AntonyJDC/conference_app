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

    // Convertir event en un observable para actualizar la UI al cambiar spotsLeft
    final event = (Get.arguments as EventModel).obs;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              EventImage(event: event()),
              EventInfo(event: event()),
              GestureDetector(
                onTap: () {
                  final nearbyEvents = [
                    EventModel(
                      id: '1',
                      title: 'Miami Carnival 2025',
                      imageUrl: 'https://example.com/miami.jpg',
                      date: '2025-10-01',
                      description: 'Un evento increíble en Miami.',
                      startTime: '10:00 AM',
                      endTime: '6:00 PM',
                      location: 'Miami Beach',
                      capacity: 500,
                      spotsLeft: 200,
                      categories: ['Carnaval', 'Música'],
                    ),
                    EventModel(
                      id: '2',
                      title: 'Meta Expo Singapore',
                      imageUrl: 'https://example.com/meta.jpg',
                      date: '2023-12-15',
                      description: 'Explora el futuro de la tecnología.',
                      startTime: '9:00 AM',
                      endTime: '5:00 PM',
                      location: 'Singapore Expo',
                      capacity: 1000,
                      spotsLeft: 800,
                      categories: ['Tecnología', 'Innovación'],
                    ),
                  ];

                  Get.toNamed('/nearby', arguments: nearbyEvents);
                },
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              bool isFav = favoriteController.isFavorite(event.value);
              return _circleButton(
                () => favoriteController.toggleFavorite(event.value),
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
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
