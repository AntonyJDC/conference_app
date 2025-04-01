import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';

class EventCategoryTags extends StatelessWidget {
  final EventModel event;

  const EventCategoryTags({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mismo map de iconos de categorías
    final Map<String, IconData> categoryIcons = {
      'Música': Icons.music_note,
      'Tecnología': Icons.computer,
      'Deportes': Icons.sports_soccer,
      'Arte': Icons.color_lens,
      'Moda': Icons.checkroom,
      'Fiesta': Icons.wine_bar,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Categorías",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tags de categorías
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: event.categories.map((category) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      categoryIcons[category] ?? Icons.category,
                      size: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
