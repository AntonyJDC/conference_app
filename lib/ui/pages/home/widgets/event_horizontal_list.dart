import 'package:conference_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventHorizontalList extends StatelessWidget {
  final List<EventModel> events;

  const EventHorizontalList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/detail', arguments: event),
            child: Container(
              width: size.width * 0.6,
              margin: EdgeInsets.only(
                left: index == 0 ? 14 : 0,
                right: index == events.length - 1 ? 14 : 8,
              ),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(event.imageUrl,
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
                                    fontWeight: FontWeight.w700, fontSize: 12),
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
                                            color: Colors.grey, fontSize: 10),
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const Spacer(),
                            const Divider(height: 1, color: Color(0xFFE0E0E0)),
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
    );
  }
}
