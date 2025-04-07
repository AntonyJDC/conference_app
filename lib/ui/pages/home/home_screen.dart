import 'dart:async';
import 'dart:ui';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/events/get_all_events_use_case.dart';
import 'package:conference_app/domain/use_case/events/get_nearby_events_use_case.dart';
import 'package:conference_app/domain/use_case/events/get_upcoming_events_use_case.dart';
import 'package:conference_app/routes/routes.dart';
import 'package:conference_app/ui/pages/event/event_list_page.dart';
import 'package:conference_app/ui/pages/home/widgets/category_list.dart';
import 'package:conference_app/ui/pages/home/widgets/event_horizontal_list.dart';
import 'package:conference_app/ui/pages/home/widgets/home_header.dart.dart';
import 'package:conference_app/ui/pages/home/widgets/nearby_event_card.dart';
import 'package:conference_app/ui/pages/home/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conference_app/ui/pages/home/widgets/theme_selector_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  late DateFormat dateFormat;
  late tz.Location _colombiaTZ;
  late Future<List<EventModel>> _futureEvents;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _colombiaTZ = tz.getLocation('America/Bogota');
    dateFormat = DateFormat.yMMMMd('es_CO');
    _futureEvents = _loadSortedEvents();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<List<EventModel>> _loadSortedEvents() async {
    final all = await GetAllEventsUseCase().execute();
    return GetUpcomingEventsUseCase().execute(all);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<List<EventModel>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          final sortedEvents = snapshot.data ?? [];
          final nearbyEvents =
              GetNearbyEventsUseCase().execute(sortedEvents).take(10).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor: theme.colorScheme.surface,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final collapsedHeight =
                        kToolbarHeight + MediaQuery.of(context).padding.top;
                    final isCollapsed =
                        constraints.maxHeight <= collapsedHeight;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (isCollapsed)
                          ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Container(
                                color:
                                    theme.colorScheme.surface.withOpacity(0.1),
                              ),
                            ),
                          ),

                        // Íconos parte superior derecha (siempre visibles)
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          right: 8,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications,
                                    color: theme.colorScheme.primary),
                                onPressed: () => Get.toNamed(AppRoutes.notifications),
                              ),
                              IconButton(
                                icon: Icon(Icons.settings,
                                    color: theme.colorScheme.primary),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    builder: (_) => const ThemeSelectorModal(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // Título y logo
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 16,
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Align(
                            alignment: isCollapsed
                                ? Alignment.bottomCenter
                                : Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: isCollapsed
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isCollapsed) ...[
                                  SvgPicture.asset(
                                    'assets/images/logo.svg',
                                    width: 32,
                                    height: 32,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  "BizEvents",
                                  style: TextStyle(
                                    fontSize: isCollapsed ? 15 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Si está cargando
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              // Si no hay eventos
              if (snapshot.connectionState == ConnectionState.done &&
                  sortedEvents.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(child: Text("No hay eventos disponibles")),
                  ),
                ),

              // Contenido si hay eventos
              if (sortedEvents.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: HomeHeader()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: "Eventos Cercanos",
                    onTap: () {
                      Get.to(() => EventListPage(
                            title: 'Eventos Cercanos',
                            emptyMessage:
                                'No hay eventos cercanos disponibles.',
                            events: nearbyEvents,
                          ));
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                    child: _buildNearbyList(context, nearbyEvents)),
                const SliverToBoxAdapter(child: SizedBox(height: 22)),
                const SliverToBoxAdapter(
                    child: SectionTitle(title: "Categorías")),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: CategoryList()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: "Eventos próximos",
                    onTap: () {
                      Get.to(() => EventListPage(
                            title: 'Eventos Próximos',
                            emptyMessage:
                                'No hay eventos próximos disponibles.',
                            events: sortedEvents,
                          ));
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                    child: EventHorizontalList(events: sortedEvents)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildNearbyList(BuildContext context, List<EventModel> events) {
    final size = MediaQuery.of(context).size;
    final now = tz.TZDateTime.now(_colombiaTZ);

    return SizedBox(
      height: size.height * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final eventDate = DateTime.parse(event.date);
          final startParts = event.startTime.split(':');
          final endParts = event.endTime.split(':');

          final eventStart = tz.TZDateTime(
            _colombiaTZ,
            eventDate.year,
            eventDate.month,
            eventDate.day,
            int.parse(startParts[0]),
            int.parse(startParts[1]),
          );

          final eventEnd = tz.TZDateTime(
            _colombiaTZ,
            eventDate.year,
            eventDate.month,
            eventDate.day,
            int.parse(endParts[0]),
            int.parse(endParts[1]),
          );

          String timeLeftText;
          Color timeColor;

          if (eventStart.isAfter(now)) {
            final difference = eventStart.difference(now);
            if (difference.inDays > 0) {
              timeLeftText = '${difference.inDays} días restantes';
              timeColor =
                  difference.inDays <= 30 ? Colors.orange : Colors.black87;
            } else if (difference.inHours > 0) {
              timeLeftText = '${difference.inHours} horas restantes';
              timeColor = Colors.red;
            } else if (difference.inMinutes > 0) {
              timeLeftText = '${difference.inMinutes} minutos restantes';
              timeColor = Colors.red;
            } else {
              timeLeftText = 'Pronto';
              timeColor = Colors.red;
            }
          } else if (now.isBefore(eventEnd)) {
            timeLeftText = 'Evento en curso';
            timeColor = Colors.green;
          } else {
            timeLeftText = 'Finalizado';
            timeColor = Colors.grey;
          }

          return Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 14 : 0,
              right: index == events.length - 1 ? 14 : 0,
            ),
            child: NearbyEventCard(
              event: event,
              timeLeftText: timeLeftText,
              timeColor: timeColor,
            ),
          );
        },
      ),
    );
  }
}
