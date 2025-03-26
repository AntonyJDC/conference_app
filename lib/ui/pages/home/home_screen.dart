import 'dart:async';
import 'package:conference_app/data/local/events_data.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/event/event_list_page.dart';
import 'package:conference_app/ui/pages/home/widgets/category_list.dart';
import 'package:conference_app/ui/pages/home/widgets/event_horizontal_list.dart';
import 'package:conference_app/ui/pages/home/widgets/home_header.dart.dart';
import 'package:conference_app/ui/pages/home/widgets/section_title.dart';
import 'package:conference_app/ui/pages/home/widgets/nearby_event_card.dart';
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
  late List<EventModel> sortedEvents;
  late DateFormat dateFormat;
  late tz.Location _colombiaTZ;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _colombiaTZ = tz.getLocation('America/Bogota');

    dateFormat = DateFormat.yMMMMd('es_CO');
    sortedEvents = List.from(dummyEvents)
      ..sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // ✅ Timer para actualización automática
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = tz.TZDateTime.now(_colombiaTZ);

    List<EventModel> nearbyEvents = sortedEvents.where((event) {
      final eventDate = DateTime.parse(event.date);
      final endParts = event.endTime.split(':');

      final eventEnd = tz.TZDateTime(
        _colombiaTZ,
        eventDate.year,
        eventDate.month,
        eventDate.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      return eventEnd.isAfter(now);
    }).toList();

    final limitedNearbyEvents = nearbyEvents.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const HomeHeader(),
          const SizedBox(height: 16),

          // 🔹 Eventos Cercanos
          SectionTitle(
            title: "Eventos Cercanos",
            onTap: () {
              Get.to(() => EventListPage(
                    title: 'Eventos Cercanos',
                    emptyMessage: 'No hay eventos cercanos disponibles.',
                    events: limitedNearbyEvents,
                  ));
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: size.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: limitedNearbyEvents.length,
              itemBuilder: (context, index) {
                final event = limitedNearbyEvents[index];
                final eventDate = DateTime.parse(event.date);
                final startParts = event.startTime.split(':');
                final endParts = event.endTime.split(':');

                final eventStart = tz.TZDateTime(
                    _colombiaTZ,
                    eventDate.year,
                    eventDate.month,
                    eventDate.day,
                    int.parse(startParts[0]),
                    int.parse(startParts[1]));
                final eventEnd = tz.TZDateTime(
                    _colombiaTZ,
                    eventDate.year,
                    eventDate.month,
                    eventDate.day,
                    int.parse(endParts[0]),
                    int.parse(endParts[1]));

                String timeLeftText;
                Color timeColor = Colors.black87;

                if (eventStart.isAfter(now)) {
                  final difference = eventStart.difference(now);
                  if (difference.inDays > 0) {
                    timeLeftText = '${difference.inDays} días restantes';
                    if (difference.inDays <= 30) timeColor = Colors.orange;
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
                    right: index == limitedNearbyEvents.length - 1 ? 14 : 0,
                  ),
                  child: NearbyEventCard(
                    event: event,
                    timeLeftText: timeLeftText,
                    timeColor: timeColor,
                  ),
                );
              },
            ),
          ),

          // 🔹 Categorías
          const SizedBox(height: 22),
          SectionTitle(title: "Categorías"),
          const SizedBox(height: 16),
          const CategoryList(),

          // 🔹 Eventos Próximos
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
      ),
    );
  }
}
