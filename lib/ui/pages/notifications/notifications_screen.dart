import 'package:conference_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final controller = Get.find<NotificationsController>();
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: iconColor),
            onPressed: () => _showSettingsModal(context),
          ),
        ],
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Obx(() {
        final notifs = controller.notifications;
        if (notifs.isEmpty) {
          return const Center(child: Text('No hay notificaciones por ahora.'));
        }
        return ListView.separated(
          itemCount: notifs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final item = notifs[index];
            return ListTile(
              leading: Icon(Icons.notifications_active, color: iconColor),
              title: Text(item.title, style: TextStyle(color: iconColor)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.body,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(item.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Obx(() {
          return Container(
            padding: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Activar notificaciones'),
                  value: controller.notify1DayBefore.value ||
                      controller.notify1HourBefore.value ||
                      controller.notify10MinBefore.value,
                  onChanged: (value) {
                    controller.notify1DayBefore.value = value;
                    controller.notify1HourBefore.value = value;
                    controller.notify10MinBefore.value = value;
                    controller
                        .savePreferences();
                  },
                ),
                if (controller.notify1DayBefore.value ||
                    controller.notify1HourBefore.value ||
                    controller.notify10MinBefore.value)
                  Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('1 día antes'),
                        value: controller.notify1DayBefore.value,
                        onChanged: (val) {
                          controller.notify1DayBefore.value = val ?? false;
                          controller.savePreferences();
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('1 hora antes'),
                        value: controller.notify1HourBefore.value,
                        onChanged: (val) {
                          controller.notify1HourBefore.value = val ?? false;
                          controller.savePreferences();
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('10 minutos antes'),
                        value: controller.notify10MinBefore.value,
                        onChanged: (val) {
                          controller.notify10MinBefore.value = val ?? false;
                          controller.savePreferences();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        });
      },
    );
  }
}
