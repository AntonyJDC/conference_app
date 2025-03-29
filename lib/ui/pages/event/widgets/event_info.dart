import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/check_event_status_use_case.dart';
import 'package:conference_app/ui/pages/event/widgets/detail_icon.dart';
import 'package:conference_app/ui/pages/event/widgets/event_category_tags.dart';
import 'package:conference_app/ui/pages/reviews/widgets/reviews_carousel.dart';
import 'package:conference_app/ui/widgets/event_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatelessWidget {
  final Rx<EventModel> event;
  final VoidCallback? onTap;

  const EventInfo({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final overlap = size.height * 0.35 * 0.15;
    return Obx(() {
      final e = event.value;
      final percentage = e.spotsLeft / e.capacity;

      final spotColor = percentage < 0.25
          ? Colors.red
          : percentage < 0.5
              ? Colors.amber
              : Colors.green;

      final isPastEvent = CheckEventStatusUseCase().execute(e);
      final eventDate = DateTime.tryParse(e.date);

      return Transform.translate(
        offset: Offset(0, -overlap),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8), // nuevo
              EventRatingStars(
                event: event.value,
                textColor: theme.primary,
              ),
              const SizedBox(height: 24),
              if (!isPastEvent)
                _spotsAvailable(context, e.spotsLeft, spotColor, theme),
              const SizedBox(height: 24),
              const Text("Descripción del evento",
                  style:
                      TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(e.description, style: TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              Divider(
                thickness: 1,
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(
                    alpha: 0.3), // o usa Theme.of(context).dividerColor
              ),
              const SizedBox(height: 24),
              const Text("Acerca del evento",
                  style:
                      TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DetailIcon(
                icon: Icons.calendar_today,
                title: e.date,
                subtitle: isPastEvent
                    ? 'Este evento ya finalizó'
                    : '${DateFormat('EEEE', 'es_CO').format(eventDate!)}, de ${e.startTime} a ${e.endTime}',
                subtitleStyle: TextStyle(
                  color: isPastEvent ? Colors.red : Colors.grey,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 16),
              DetailIcon(
                icon: Icons.location_on,
                title: e.location,
                subtitle: "Ubicación",
                subtitleStyle: null,
              ),
              const SizedBox(height: 16),
              DetailIcon(
                icon: Icons.people,
                title: "${e.capacity} personas",
                subtitle: "Capacidad",
                subtitleStyle: null,
              ),
              const SizedBox(height: 24),
              EventCategoryTags(event: e),
              const SizedBox(height: 12),
              Divider(
                thickness: 1,
                height: 1,
                color: theme.outline.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Reseñas",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => onTap?.call(), // Navigate to reviews page
                    child: Text("Ver todas",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ReviewsCarousel(event: event.value),
            ],
          ),
        ),
      );
    });
  }

  Widget _spotsAvailable(
      BuildContext context, int spotsLeft, Color color, dynamic theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.outline,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.chair, color: theme.primary),
              const SizedBox(width: 12),
              const Text('Cupos disponibles',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Text('$spotsLeft',
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
