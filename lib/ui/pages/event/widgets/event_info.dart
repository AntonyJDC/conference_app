import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/event/widgets/detail_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatelessWidget {
  final EventModel event;
  const EventInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final overlap = size.height * 0.35 * 0.15;
    final double percentage = event.spotsLeft / event.capacity;
    Color spotColor = percentage < 0.25
        ? Colors.red
        : percentage < 0.5
            ? Colors.amber
            : Colors.green;

    return Transform.translate(
      offset: Offset(0, -overlap),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(event.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 25),
            DetailIcon(
                icon: Icons.calendar_today,
                title: event.date,
                subtitle:
                    '${DateFormat('EEEE', 'en_US').format(DateTime.parse(event.date))}, de ${event.startTime} a ${event.endTime}'),
            const SizedBox(height: 16),
            DetailIcon(
                icon: Icons.location_on,
                title: event.location,
                subtitle: "Ubicación"),
            const SizedBox(height: 16),
            DetailIcon(
                icon: Icons.people,
                title: "${event.capacity} personas",
                subtitle: "Capacidad"),
            const SizedBox(height: 24),
            _spotsAvailable(context, event.spotsLeft, spotColor),
            const SizedBox(height: 24),
            const Text("About Event",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Annex Fridays\n2 DJs\nConfetti Blast\nCash Bar\nHookah",
                style: TextStyle(height: 1.6)),
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
