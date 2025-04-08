import 'dart:async';
import 'dart:convert';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/ui/pages/notifications/service/notifications_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime date;
  final DateTime receivedAt = DateTime.now(); // Asignar la fecha actual al recibir la notificación

  NotificationItem({
    required this.title,
    required this.body,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'receivedAt': receivedAt.toIso8601String(),
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']), // Asignar la fecha actual al recibir la notificación
    );
  }
}

class NotificationsController extends GetxController {
  final BookedEventsController bookedEventsController =
      Get.find<BookedEventsController>();

  final notifications = <NotificationItem>[].obs;
  var notificationsEnabled = true.obs;

  final notify1DayBefore = true.obs;
  final notify1HourBefore = true.obs;
  final notify10MinBefore = true.obs;

  final _notifiedEvents = <String>{};
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    _loadNotificationHistory();
    _startMonitoring();

    ever(bookedEventsController.tasks, (_) => _startMonitoring());

    // Escucha cambios en las opciones de notificación individuales y guarda
    everAll(
      [notify1DayBefore, notify1HourBefore, notify10MinBefore],
      (_) => savePreferences(),
    );

    // Escucha el switch general de activación de notificaciones y guarda
    ever(notificationsEnabled, (value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', value);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkForImmediateNotifications();
    });
    Future.delayed(const Duration(seconds: 2), _checkForImmediateNotifications);
  }

  void _checkForImmediateNotifications() {
    final now = DateTime.now();
    final oneDayFromNow = now.add(const Duration(days: 1));

    final upcomingEvents = bookedEventsController.tasks.where((event) {
      final eventDate = DateTime.tryParse('${event.date} ${event.startTime}');
      if (eventDate == null) return false;
      return eventDate.isAfter(now) && eventDate.isBefore(oneDayFromNow);
    });

    for (var event in upcomingEvents) {
      final eventDate = DateTime.tryParse('${event.date} ${event.startTime}');
      if (eventDate == null) continue;

      final diff = eventDate.difference(now);

      if (notify1DayBefore.value &&
          diff.inMinutes <= 1440 &&
          diff.inMinutes > 1430 &&
          !_notifiedEvents.contains('${event.id}_1d')) {
        _show(event, eventDate, '1d', 'Falta 1 día para ${event.title}',
            'Prepárate para el evento.');
      }

      if (notify1HourBefore.value &&
          diff.inMinutes <= 60 &&
          diff.inMinutes > 59 &&
          !_notifiedEvents.contains('${event.id}_1h')) {
        _show(event, eventDate, '1h', 'Falta 1 hora para ${event.title}',
            '¡Se acerca tu evento!');
      }

      if (notify10MinBefore.value &&
          diff.inMinutes <= 10 &&
          diff.inMinutes > 9 &&
          !_notifiedEvents.contains('${event.id}_10m')) {
        _show(event, eventDate, '10m', 'Faltan 10 minutos para ${event.title}',
            'Es hora de alistarte.');
      }
    }
  }

  void _show(
      EventModel event, DateTime date, String key, String title, String body) {
    final id = '${event.id}_$key'.hashCode;

    LocalNotificationService.showInstantNotification(
      id: id,
      title: title,
      body: body,
    );

    _notifiedEvents.add('${event.id}_$key');

    final item = NotificationItem(title: title, body: body, date: date);
    notifications.add(item);
    saveNotificationHistory();
  }

  Future<void> saveNotificationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notifications
        .map((n) => {
              'title': n.title,
              'body': n.body,
              'date': n.receivedAt.toIso8601String(),
            })
        .toList());
    await prefs.setString('notification_history', encoded);
  }

  Future<void> _loadNotificationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('notification_history');
    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      notifications.value = decoded
          .map((item) => NotificationItem.fromJson(item))
          .toList(growable: false);
    } catch (e) {
      print("Error loading notification history: $e");
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? true;
    notify1DayBefore.value = prefs.getBool('notify1d') ?? true;
    notify1HourBefore.value = prefs.getBool('notify1h') ?? true;
    notify10MinBefore.value = prefs.getBool('notify10m') ?? true;
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify1d', notify1DayBefore.value);
    await prefs.setBool('notify1h', notify1HourBefore.value);
    await prefs.setBool('notify10m', notify10MinBefore.value);
  }

  Future<void> clearNotificationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(
        'notification_history'); // <-- usa esta misma clave que en _saveNotificationHistory
    notifications.clear();
  }
}
