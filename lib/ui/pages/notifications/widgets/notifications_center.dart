import 'package:conference_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.body,
    required this.date,
  });
}

void showNotificationCenter(BuildContext context, NotificationsController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withOpacity(0.95),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final events = controller.notifications;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text(
                'Notificaciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              if (events.isEmpty)
                Text('No tienes eventos próximos', style: TextStyle(color: Colors.white54))
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event.title, style: TextStyle(color: Colors.white)),
                        subtitle: Text(event.date.toString(), style: TextStyle(color: Colors.white70)),
                        trailing: Icon(Icons.event, color: Colors.white60),
                        onTap: () {
                          // Puedes agregar navegación a los detalles del evento aquí
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      );
    },
  );
}