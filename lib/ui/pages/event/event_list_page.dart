import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<EventModel> events;

  const EventListPage({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: events.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_busy,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(emptyMessage),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    event: event,
                    showFavorite: false,
                    showDate: true,
                  );
                },
              ),
            ),
    );
  }
}
