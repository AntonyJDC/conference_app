import 'package:conference_app/data/local/events_data.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/ui/widgets/event_card.dart'; // Asegúrate de que esta importación sea válida

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
              child: Text(
                "No hay eventos disponibles para esta categoría.",
                style: const TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  // Reutilizamos el diseño de las tarjetas desde SearchPage
                  return EventCard(
                    event: event,
                    onTap: () {
                      debugPrint(
                          'Navegando a la categoría: $category'); // Depuración
                      Get.toNamed('/category', arguments: category);
                    },
                  );
                },
              ),
            ),
    );
  }
}
