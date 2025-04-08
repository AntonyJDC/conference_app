import 'dart:ui';

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

    return Obx(() => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsedHeight =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                final isCollapsed = constraints.maxHeight <= collapsedHeight;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Fondo con efecto de difuminado
                    if (isCollapsed)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            color: theme.colorScheme.surface.withOpacity(0.1),
                          ),
                        ),
                      ),
                    // Título y botones visibles siempre
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: colorScheme.onBackground),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: IconButton(
                        icon: Icon(Icons.more_vert,
                            color: colorScheme.onBackground),
                        onPressed: () => _showOptions(context),
                      ),
                    ),
                    // Título centrado
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 50,
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Align(
                        alignment: isCollapsed
                            ? Alignment.bottomCenter
                            : Alignment.bottomLeft,
                        child: Text(
                          "Notificaciones",
                          style: TextStyle(
                            fontSize: isCollapsed ? 16 : 22,
                            fontWeight: FontWeight.bold,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final grouped = _groupByDate(controller.notifications);
                final group = grouped[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0), // Aquí agregas el padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.label,
                        style: theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
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
                                        await controller
                                            .saveNotificationHistory();
                                      },
                                      icon: Icons.delete,
                                      label: 'Eliminar',
                                      backgroundColor: Colors.red,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 0,
                                  color: theme.colorScheme.tertiary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(item.title),
                                    subtitle: Text(item.body),
                                    trailing: Text(
                                      DateFormat('HH:mm').format(DateTime.now()),
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
                  ),
                );
              },
              childCount: _groupByDate(controller.notifications).length,
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() => controller.notifications.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => controller.clearNotificationHistory(),
              icon: const Icon(Icons.delete_sweep),
              label: const Text("Limpiar todo"),
            )
          : const SizedBox.shrink()),
    ));
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Obx(() {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(
                  FocusNode()); // Dismiss keyboard when tapping outside
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Línea superior para indicar deslizar
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // SwitchListTile para Notificaciones activadas
                    SwitchListTile(
                      title: const Text('Notificaciones activadas'),
                      value: controller.notificationsEnabled.value,
                      onChanged: (val) =>
                          controller.notificationsEnabled.value = val,
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
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
                ),
              ),
            ),
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
