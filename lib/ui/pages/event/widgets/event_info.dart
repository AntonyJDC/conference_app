import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/check_event_status_use_case.dart';
import 'package:conference_app/ui/pages/event/widgets/detail_icon.dart';
import 'package:conference_app/ui/pages/event/widgets/event_category_tags.dart';
import 'package:conference_app/ui/pages/reviews/widgets/reviews_carousel.dart';
import 'package:conference_app/ui/widgets/event_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatefulWidget {
  final Rx<EventModel> event;
  final VoidCallback? onTap;
  final int? totalReviews;

  const EventInfo({
    super.key,
    required this.event,
    this.onTap,
    this.totalReviews,
  });

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  final RxDouble averageRating = 0.0.obs;
  final RxInt reviewCount = 0.obs;

  @override
  void initState() {
    super.initState();
    averageRating.value = widget.event.value.averageRating ?? 0.0;
    reviewCount.value = widget.totalReviews ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final overlap = size.height * 0.35 * 0.15;

    return Obx(() {
      final e = widget.event.value;
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
              Text(
                e.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              /// ✅ Esta es la línea que ahora sí se actualizará correctamente
              Obx(() => EventRatingStars(
                    event: e,
                    average: averageRating.value,
                    showReviewCount: false,
                    textColor: theme.primary,
                    
                  )),

              const SizedBox(height: 24),
              if (!isPastEvent) ...[
                _spotsAvailable(context, e.spotsLeft, spotColor, theme),
                const SizedBox(height: 24),
              ],

              const Text("Descripción del evento",
                  style: TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(e.description, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              Divider(thickness: 1, height: 1, color: theme.outline.withAlpha(75)),
              const SizedBox(height: 24),

              const Text("Acerca del evento",
                  style: TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.bold)),
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
              Divider(thickness: 1, height: 1, color: theme.outline.withAlpha(75)),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Reseñas",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Obx(() {
                    if (reviewCount.value > 5) {
                      return GestureDetector(
                        onTap: () => widget.onTap?.call(),
                        child: Text("Ver todas",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.primary)),
                      );
                    }
                    return const SizedBox();
                  }),
                ],
              ),
              const SizedBox(height: 16),

              /// ✅ Callback para sincronizar promedio con este widget
              ReviewsCarousel(
                event: widget.event.value,
                onDataLoaded: (avg, count) {
                  averageRating.value = avg;
                  reviewCount.value = count;
                },
              ),
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
        color: theme.tertiary,
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
