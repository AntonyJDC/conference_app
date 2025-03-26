import 'dart:async';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/event/widgets/detail_icon.dart';
import 'package:conference_app/ui/pages/event/widgets/event_category_tags.dart';
import 'package:conference_app/ui/pages/reviews/widgets/reviews_carousel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class EventInfo extends StatefulWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventInfo({super.key, required this.event, this.onTap});

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  late Timer _timer;
  late tz.Location _colombiaTZ;
  bool isPastEvent = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _colombiaTZ = tz.getLocation('America/Bogota');
    _checkEventStatus();

    // 🔄 Actualiza cada minuto por si el evento finaliza
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) _checkEventStatus();
    });
  }

  void _checkEventStatus() {
    final eventDate = DateTime.tryParse(widget.event.date);
    if (eventDate != null) {
      final endParts = widget.event.endTime.split(':');
      final eventEnd = tz.TZDateTime(
        _colombiaTZ,
        eventDate.year,
        eventDate.month,
        eventDate.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      setState(() {
        isPastEvent = tz.TZDateTime.now(_colombiaTZ)
            .isAfter(eventEnd.subtract(const Duration(seconds: 2)));
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final overlap = size.height * 0.35 * 0.15;

    final double percentage = widget.event.spotsLeft / widget.event.capacity;
    Color spotColor = percentage < 0.25
        ? Colors.red
        : percentage < 0.5
            ? Colors.amber
            : Colors.green;

    final eventDate = DateTime.tryParse(widget.event.date);

    return Transform.translate(
      offset: Offset(0, -overlap),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(widget.event.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 25),

            // 📅 FECHA Y HORA o MENSAJE si finalizó
            DetailIcon(
              icon: Icons.calendar_today,
              title: widget.event.date,
              subtitle: isPastEvent
                  ? 'Este evento ya finalizó'
                  : '${DateFormat('EEEE', 'es_CO').format(eventDate!)}, de ${widget.event.startTime} a ${widget.event.endTime}',
              subtitleStyle: TextStyle(
                color: isPastEvent ? Colors.red : Colors.grey,
                fontSize: 10,
              ),
            ),

            const SizedBox(height: 16),
            DetailIcon(
              icon: Icons.location_on,
              title: widget.event.location,
              subtitle: "Ubicación",
              subtitleStyle: null,
            ),
            const SizedBox(height: 16),
            DetailIcon(
              icon: Icons.people,
              title: "${widget.event.capacity} personas",
              subtitle: "Capacidad",
              subtitleStyle: null,
            ),

            const SizedBox(height: 24),

            // ✅ Mostrar Cupos disponibles solo si el evento no ha pasado
            if (!isPastEvent)
              _spotsAvailable(context, widget.event.spotsLeft, spotColor),

            const SizedBox(height: 24),
            EventCategoryTags(event: widget.event),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Reseñas",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text("Ver todas",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ReviewsCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _spotsAvailable(BuildContext context, int spotsLeft, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.chair, color: Theme.of(context).colorScheme.primary),
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
