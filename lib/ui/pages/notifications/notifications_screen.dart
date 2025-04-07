import 'package:conference_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationsController controller =
      Get.find<NotificationsController>();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Notificaciones",
                style: TextStyle(color: colorScheme.onBackground))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onBackground),
            onPressed: () => _showOptions(context),
          ),
        ],
      ),
      body: Obx(() {
        final grouped = _groupByDate(controller.notifications);
        if (grouped.isEmpty) {
          return const Center(child: Text("Sin notificaciones por ahora."));
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: grouped.length,
            itemBuilder: (context, i) {
              final group = grouped[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.label,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...List.generate(group.items.length, (j) {
                    final item = group.items[j];
                    return AnimationConfiguration.staggeredList(
                      position: j,
                      duration: const Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 20.0,
                        child: FadeInAnimation(
                          child: Slidable(
                            key: ValueKey(item.date.toIso8601String()),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    controller.notifications.remove(item);
                                    await controller.saveNotificationHistory();
                                  },
                                  icon: Icons.delete,
                                  label: 'Eliminar',
                                  backgroundColor: Colors.red,
                                )
                              ],
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(item.title),
                                subtitle: Text(item.body),
                                trailing: Text(
                                  DateFormat('HH:mm').format(item.date),
                                  style: theme.textTheme.labelSmall,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      }),
      floatingActionButton: Obx(() => controller.notifications.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => controller.clearNotificationHistory(),
              icon: const Icon(Icons.delete_sweep),
              label: const Text("Limpiar todo"),
            )
          : const SizedBox.shrink()),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Notificaciones activadas'),
                value: controller.notificationsEnabled.value,
                onChanged: (val) => controller.notificationsEnabled.value = val,
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tiempos de notificación",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SwitchListTile(
                  title: const Text('Notificar 1 día antes'),
                  value: controller.notify1DayBefore.value,
                  onChanged: controller.notificationsEnabled.value
                      ? (val) => controller.notify1DayBefore.value = val
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SwitchListTile(
                  title: const Text('Notificar 1 hora antes'),
                  value: controller.notify1HourBefore.value,
                  onChanged: controller.notificationsEnabled.value
                      ? (val) => controller.notify1HourBefore.value = val
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SwitchListTile(
                  title: const Text('Notificar 10 minutos antes'),
                  value: controller.notify10MinBefore.value,
                  onChanged: controller.notificationsEnabled.value
                      ? (val) => controller.notify10MinBefore.value = val
                      : null,
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        });
      },
    );
  }

  List<_NotificationGroup> _groupByDate(List items) {
    final now = DateTime.now();
    Map<String, List<NotificationItem>> map = {};

    for (var item in items) {
      final date = item.date;
      final difference = now.difference(date).inDays;

      String label;
      if (difference == 0) {
        label = "Hoy";
      } else if (difference == 1) {
        label = "Ayer";
      } else {
        label = DateFormat.yMMMMd().format(date);
      }

      map.putIfAbsent(label, () => []).add(item);
    }

    return map.entries
        .map((e) => _NotificationGroup(label: e.key, items: e.value))
        .toList();
  }
}

class _NotificationGroup {
  final String label;
  final List<NotificationItem> items;

  _NotificationGroup({required this.label, required this.items});
}
