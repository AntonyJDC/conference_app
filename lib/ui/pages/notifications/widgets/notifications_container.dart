import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/notifications_controller.dart';

class NotificationsContainer extends StatelessWidget {
  final NotificationsController controller = Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.upcomingEvents.isEmpty) {
        return Center(
          child: Text('No notifications available'),
        );
      }
      return ListView.builder(
        itemCount: controller.upcomingEvents.length,
        itemBuilder: (context, index) {
          final notification = controller.upcomingEvents[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(''),
              subtitle: Text("El evento '${notification.title}' empieza en 24 horas"),
              trailing: Text(notification.date),
            ),
          );
        },
      );
    });
  }
}