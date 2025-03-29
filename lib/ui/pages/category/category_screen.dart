import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:conference_app/domain/use_case/events/get_events_by_category_use_case.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<EventModel>>(
        future: GetEventsByCategoryUseCase().execute(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No hay eventos en esta categoría'),
                  ),
                ],
              ),
            );
          }

          final filteredEvents = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: filteredEvents[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
