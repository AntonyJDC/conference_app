import 'dart:async';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/get_all_events_use_case.dart';
import 'package:conference_app/domain/use_case/get_nearby_events_use_case.dart';
import 'package:conference_app/domain/use_case/get_upcoming_events_use_case.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text("BizEvents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay eventos disponibles"));
          }

          final sortedEvents = snapshot.data!;
          final nearbyEvents =
              GetNearbyEventsUseCase().execute(sortedEvents).take(10).toList();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const HomeHeader(),
              const SizedBox(height: 16),
              SectionTitle(
                title: "Eventos Cercanos",
                onTap: () {
                  Get.to(() => EventListPage(
                        title: 'Eventos Cercanos',
                        emptyMessage: 'No hay eventos cercanos disponibles.',
                        events: nearbyEvents,
                      ));
                },
              ),
              const SizedBox(height: 16),
              _buildNearbyList(context, nearbyEvents),
              const SizedBox(height: 22),
              const SectionTitle(title: "Categorías"),
              const SizedBox(height: 16),
              const CategoryList(),
              const SizedBox(height: 16),
              SectionTitle(
                title: "Eventos próximos",
                onTap: () {
                  Get.to(() => EventListPage(
                        title: 'Eventos Próximos',
                        emptyMessage: 'No hay eventos próximos disponibles.',
                        events: sortedEvents,
                      ));
                },
              ),
              const SizedBox(height: 16),
              EventHorizontalList(events: sortedEvents),
              const SizedBox(height: 16),
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
