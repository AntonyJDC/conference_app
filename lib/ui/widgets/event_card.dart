import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool showFavorite, showDate;

  const EventCard(
      {super.key,
      required this.event,
      this.showFavorite = false,
      this.showDate = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.parse(event.date);
    final now = DateTime.now();
    final isPastEvent = date.isBefore(now);
    final favoriteController = Get.find<FavoriteController>();

    // Color del banderín
    final banderinColor =
        isPastEvent ? theme.colorScheme.errorContainer : Colors.green;

    final banderinTextColor = isPastEvent
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimary;

    final day = DateFormat('dd').format(date);
    final month = DateFormat('MMM', 'es_CO').format(date).toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 📸 Imagen del evento
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              event.imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.cover,
            ),
          ),

          // 📌 Banderín de la fecha
          if (showDate)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                width: 44,
                height: 54,
                decoration: BoxDecoration(
                  color: banderinColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                          color: banderinTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      month,
                      style: TextStyle(
                          color: banderinTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

          // ❤️ Favorito dinámico
          if (showFavorite)
            Positioned(
              top: 12,
              right: 12,
              child: Obx(() {
                final isFavorite = favoriteController.isFavorite(event);
                return GestureDetector(
                  onTap: () => favoriteController.toggleFavorite(event),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? const Color.fromARGB(255, 255, 17, 0)
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                );
              }),
            ),

          // 📄 Contenido sobre la imagen
          Positioned(
            bottom: -30,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 📃 Info del evento
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.timer,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: isPastEvent
                                  ? const Text(
                                      'Evento finalizado',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    )
                                  : Text(
                                      '${event.startTime} - ${event.endTime}',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔗 Botón Ver Detalle
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.toNamed('/detail', arguments: event),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
