import 'dart:ui';

import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/get_all_events_use_case.dart';
import 'package:conference_app/ui/widgets/event_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await GetAllEventsUseCase().execute();
    setState(() {
      allEvents = events;
      filteredEvents = events;
    });
  }

  void filterEvents(String query) {
    setState(() {
      filteredEvents = allEvents.where((event) {
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

    // Agrupar eventos por fecha
    filteredEvents.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    final groupedEvents = groupBy(filteredEvents, (e) => e.date);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            centerTitle: true,
            expandedHeight: 100,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsedHeight =
                    64.0 + MediaQuery.of(context).padding.top;
                final bool isCollapsed =
                    constraints.maxHeight <= collapsedHeight;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isCollapsed)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
                          child: Container(
                            color:
                                theme.colorScheme.shadow.withValues(alpha: 0.1),
                          ),
                        ),
                      ),

                    // Título
                    Padding(
                      padding: EdgeInsets.only(
                        left: isCollapsed ? 0 : 16,
                        bottom: 10,
                      ),
                      child: Align(
                        alignment: isCollapsed
                            ? Alignment.bottomCenter
                            : Alignment.bottomLeft,
                        child: Text(
                          "Buscar eventos",
                          style: TextStyle(
                            fontSize: isCollapsed ? 14 : 22,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 🔍 Barra de búsqueda
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: filterEvents,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar eventos',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search),
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

          // 📅 Lista de eventos agrupados por fecha
          if (groupedEvents.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No se encontraron eventos.')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final dateKey = groupedEvents.keys.elementAt(index);
                  final eventsForDate = groupedEvents[dateKey]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
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
                    ),
                  );
                },
                childCount: groupedEvents.keys.length,
              ),
            ),
        ],
      ),
    );
  }
}
