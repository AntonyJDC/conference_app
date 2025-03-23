import 'package:conference_app/data/local/events_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

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
        return titleMatch || locationMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Agrupar eventos por fecha
    final groupedEvents = groupBy(filteredEvents, (e) => e.date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Buscar Eventos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔎 Barra de búsqueda
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SizedBox(
              height: 55,
              child: TextField(
                controller: searchController,
                onChanged: filterEvents,
                cursorColor: theme.colorScheme.onPrimary,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar eventos',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: theme.colorScheme.onPrimary, size: 20),
                  filled: true,
                  fillColor: theme.colorScheme.primary,
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

          // 🔥 Lista de eventos
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
                    // 📅 Fecha como separador
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 20),
                      child: Text(
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.parse(dateKey)),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                    // 🔥 Tarjetas de eventos
                    ...eventsForDate.map((event) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: 50), // Espacio real entre eventos
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Imagen del evento
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  event.imageUrl,
                                  width: double.infinity,
                                  height: screenWidth * 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // Contenido que se sobrepone a la imagen (-30 lo saca)
                              Positioned(
                                bottom:
                                    -30, // Mitad dentro de la imagen y mitad fuera
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on,
                                                    size: 12,
                                                    color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    event.location,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month_rounded,
                                                  size: 12,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '${event.date} - ${event.startTime} - ${event.endTime}',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 12),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Get.toNamed(
                                              '/detail',
                                              arguments: event),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),
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
