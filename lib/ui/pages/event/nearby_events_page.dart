import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/widgets/event_card.dart';

class NearbyEventsPage extends StatelessWidget {
  final List<EventModel> nearbyEvents;

  NearbyEventsPage({super.key}) : nearbyEvents = Get.arguments ?? [] {
    if (nearbyEvents.isEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos cercanos'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: nearbyEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No hay eventos cercanos disponibles.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: nearbyEvents.length,
                itemBuilder: (context, index) {
                  final event = nearbyEvents[index];
                  return EventCard(
                    event: event,
                  );
                },
              ),
            ),
    );
  }
}
