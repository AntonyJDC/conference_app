import 'package:conference_app/controllers/favorite_controller.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    late EventModel event;
    try {
      event = Get.arguments as EventModel;
    } catch (e) {
      print('Error al obtener los argumentos: $e');
      return Scaffold(
        body: Center(
          child: Text('Error al cargar el evento.'),
        ),
      );
    }

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final favoriteController = Get.find<FavoriteController>();

    final double imageHeight = size.height * 0.35;
    final double overlap = imageHeight * 0.15;

    // Calcula el porcentaje disponible
    double percentage =
        (event.spotsLeft ?? 0) / (event.capacity ?? 1); // Evita división por 0
    // Define el color dinámico según el porcentaje
    Color spotColor;
    if (percentage < 0.25) {
      spotColor = Colors.red;
    } else if (percentage < 0.5) {
      spotColor = Colors.amber;
    } else {
      spotColor = Colors.green;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Contenido scrolleable
          ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              // Imagen (ya no contiene botones)
              Image.asset(
                event.imageUrl,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Contenido
              Transform.translate(
                offset: Offset(0, -overlap),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        event.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      // Descripción
                      Text(
                        event.description ??
                            "Sin descripción", // Manejo de valores nulos
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Fecha y Hora
                      Row(
                        children: [
                          _buildIcon(context, Icons.calendar_today),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${DateFormat('EEEE', 'en_US').format(DateTime.parse(event.date))}, de ${event.startTime ?? 'N/A'} a ${event.endTime ?? 'N/A'}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 📍 Ubicación
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Centra verticalmente
                        children: [
                          _buildIcon(context, Icons.location_on),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Ubicación",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Capacidad y Spots Left
                      Row(
                        children: [
                          _buildIcon(context, Icons.people),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${event.capacity ?? 'N/A'} personas',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Capacidad",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Texto descriptivo a la izquierda
                            Row(
                              children: [
                                Icon(
                                  Icons.chair,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cupos disponibles',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Spots restantes a la derecha con color dinámico
                            Text(
                              '${event.spotsLeft ?? 0}',
                              style: TextStyle(
                                color: spotColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // About Event
                      const Text("About Event",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                          "Annex Fridays\n2 DJs\nConfetti Blast\nCash Bar\nHookah",
                          style: TextStyle(height: 1.6)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botón fijo en el bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (event.spotsLeft ?? 0) > 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: (event.spotsLeft ?? 0) > 0
                      ? () {
                          // Acción de reserva
                        }
                      : null,
                  child: Text(
                    (event.spotsLeft ?? 0) > 0 ? "Suscribirme" : "Agotado",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),

          // 🔒 Botón de regreso y favoritos Fijos sobre todo
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Obx(() {
              bool isFav = favoriteController.isFavorite(event);
              return GestureDetector(
                onTap: () => favoriteController.toggleFavorite(event),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
    );
  }
}
