import 'package:conference_app/data/local/events_data.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/ui/pages/event/event_list_page.dart';
import 'package:conference_app/ui/pages/home/widgets/category_list.dart';
import 'package:conference_app/ui/pages/home/widgets/home_header.dart.dart';
import 'package:conference_app/ui/pages/home/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<EventModel> sortedEvents = List.from(dummyEvents)
      ..sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    final now = DateTime.now();

    // Filtra los eventos cercanos que no hayan superado la fecha actual
    List<EventModel> nearbyEvents = sortedEvents.where((event) {
      final eventDate = DateTime.tryParse(event.date);
      if (eventDate == null) return false;
      return eventDate.isAfter(now.subtract(const Duration(days: 1)));
    }).toList();

    // Limita a 10 eventos
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
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.99),
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

          // 🔹 Eventos cercanos con navegación
          const SizedBox(height: 16),
          SectionTitle(
            title: "Eventos cercanos",
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
              physics: const BouncingScrollPhysics(),
              itemCount: limitedNearbyEvents.length,
              itemBuilder: (context, index) {
                final event = limitedNearbyEvents[index];
                final eventDate = DateTime.tryParse(event.date)!;
                final daysLeft = eventDate.difference(DateTime.now()).inDays;

                return GestureDetector(
                  onTap: () => Get.toNamed('/detail', arguments: event),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: index == 0 ? 14 : 0, right: 14),
                    child: Container(
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(event.imageUrl),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              if (daysLeft >= 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14,
                                          color: daysLeft <= 30
                                              ? Colors.red
                                              : Colors.black87),
                                      const SizedBox(width: 4),
                                      Text('$daysLeft días restantes',
                                          style: TextStyle(
                                              color: daysLeft <= 30
                                                  ? Colors.red
                                                  : Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

          // 🔹 Eventos próximos con navegación
          const SizedBox(height: 16),
          SectionTitle(
              title: "Eventos proximos",
              onTap: () {
                Get.to(() => EventListPage(
                      title: 'Eventos Próximos',
                      emptyMessage: 'No hay eventos próximos disponibles.',
                      events: sortedEvents,
                    ));
              }),

          const SizedBox(height: 16),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                return GestureDetector(
                  onTap: () => Get.toNamed('/detail', arguments: event),
                  child: Container(
                    width: size.width * 0.6,
                    margin: EdgeInsets.only(
                        left: index == 0 ? 14 : 0,
                        right: index == sortedEvents.length - 1 ? 14 : 8),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.asset(event.imageUrl,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                          child: Text(event.location,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Divider(
                                      height: 1, color: Color(0xFFE0E0E0)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(event.date,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
