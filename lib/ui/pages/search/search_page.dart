import 'package:conference_app/data/local/events_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:conference_app/ui/widgets/event_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List filteredEvents = dummyEvents;

  void filterEvents(String query) {
    setState(() {
      filteredEvents = dummyEvents.where((event) {
        final titleMatch =
            event.title.toLowerCase().contains(query.toLowerCase());
        final locationMatch =
            event.location.toLowerCase().contains(query.toLowerCase());
        final dateMatch =
            event.date.toLowerCase().contains(query.toLowerCase());
        final tagsMatch = event.categories
            .map((tag) => tag.toLowerCase().contains(query.toLowerCase()))
            .contains(true);
        return titleMatch || locationMatch || dateMatch || tagsMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Ordenar los eventos por fecha antes de agrupar
    filteredEvents.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // Agrupar eventos por fecha
    final groupedEvents = groupBy(filteredEvents, (e) => e.date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Buscar Eventos',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔎 Barra de búsqueda
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: filterEvents,
                style: TextStyle(
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar eventos',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.outline,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          // 🔥 Lista de eventos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: groupedEvents.keys.length,
              itemBuilder: (context, index) {
                final dateKey = groupedEvents.keys.elementAt(index);
                final eventsForDate = groupedEvents[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📅 Fecha como separador
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 20),
                      child: Text(
                        DateFormat('dd MMMM yyyy', 'es_CO')
                            .format(DateTime.parse(dateKey)),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                    // 🔥 Tarjetas de eventos
                    ...eventsForDate.map((event) => EventCard(event: event))
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
