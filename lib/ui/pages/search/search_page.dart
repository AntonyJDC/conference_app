import 'package:flutter/material.dart';
import 'package:conference_app/data/local/events_data.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List dummyFiltered = dummyEvents;

  void filterEvents(String query) {
    setState(() {
      dummyFiltered = dummyEvents.where((event) {
        final titleMatch =
            event.title.toLowerCase().contains(query.toLowerCase());
        final locationMatch =
            event.location.toLowerCase().contains(query.toLowerCase());
        return titleMatch || locationMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = groupBy(dummyFiltered, (e) => e.date);

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SizedBox(
              height: 55,
              child: TextField(
                controller: searchController,
                onChanged: filterEvents,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o ubicación',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary, size: 20),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primary,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: groupedEvents.keys.length,
              itemBuilder: (context, index) {
                final dateKey = groupedEvents.keys.elementAt(index);
                final eventsForDate = groupedEvents[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fecha como separador
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.parse(dateKey)),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),

                    // Lista de eventos de esa fecha
                    ...eventsForDate.map((event) => Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    event.imageUrl,
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ),
                        ))
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
