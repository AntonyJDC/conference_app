import 'package:conference_app/data/local/events_data.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/widgets/event_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibimos la categoría seleccionada como argumento
    final String category = Get.arguments as String;

    // Filtramos los eventos que contienen la categoría seleccionada
    final List<EventModel> filteredEvents = dummyEvents
        .where((event) => event.categories
            .map((e) => e.toLowerCase())
            .contains(category.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text('No hay eventos en esta categoría')),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return EventCard(
                    event: event,
                  );
                },
              ),
            ),
    );
  }
}
