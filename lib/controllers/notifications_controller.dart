import 'dart:async';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/controllers/booked_events_controller.dart';
import 'package:conference_app/ui/pages/notifications/local_notifications.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final BookedEventsController bookedEventsController =
      Get.find<BookedEventsController>();
  final notifications = <EventModel>[].obs;

  final notify1DayBefore = true.obs;
  final notify1HourBefore = true.obs;
  final notify10MinBefore = true.obs;

  final _notifiedEvents = <String>{}; // para evitar notificaciones duplicadas
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _filterUpcomingEvents();
    ever(bookedEventsController.tasks, (_) => _filterUpcomingEvents());

    // 🕐 Revisión cada minuto
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      _checkForImmediateNotifications();
    });

    // Primera revisión inmediata al iniciar
    Future.delayed(Duration(seconds: 2), _checkForImmediateNotifications);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _filterUpcomingEvents() {
    final now = DateTime.now();
    final oneDayFromNow = now.add(const Duration(days: 1));

    notifications.value = bookedEventsController.tasks.where((event) {
      final eventDate = DateTime.tryParse('${event.date} ${event.startTime}');
      if (eventDate == null) return false;
      return eventDate.isAfter(now) && eventDate.isBefore(oneDayFromNow);
    }).toList();
  }

  void _checkForImmediateNotifications() {
    final now = DateTime.now();

    for (var event in notifications) {
      final eventDate = DateTime.tryParse('${event.date} ${event.startTime}');
      if (eventDate == null) continue;

      final diff = eventDate.difference(now);

      if (notify1DayBefore.value &&
          diff.inMinutes <= 1440 &&
          diff.inMinutes > 1439 &&
          !_notifiedEvents.contains('${event.id}_1d')) {
        _show(event, '1d', 'Falta 1 día para ${event.title}', 'Prepárate para el evento.');
      }

      if (notify1HourBefore.value &&
          diff.inMinutes <= 60 &&
          diff.inMinutes > 59 &&
          !_notifiedEvents.contains('${event.id}_1h')) {
        _show(event, '1h', 'Falta 1 hora para ${event.title}', '¡Se acerca tu evento!');
      }

      if (notify10MinBefore.value &&
          diff.inMinutes <= 10 &&
          diff.inMinutes > 9 &&
          !_notifiedEvents.contains('${event.id}_10m')) {
        _show(event, '10m', 'Faltan 10 minutos para ${event.title}', 'Es hora de alistarte.');
      }
    }
  }

  void _show(EventModel event, String key, String title, String body) {
    final id = '${event.id}_$key'.hashCode;
    LocalNotificationService.showInstantNotification(
      id: id,
      title: title,
      body: body,
    );
    _notifiedEvents.add('${event.id}_$key');
  }
}