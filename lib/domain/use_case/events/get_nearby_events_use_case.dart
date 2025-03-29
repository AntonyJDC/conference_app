import 'package:conference_app/data/models/event_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class GetNearbyEventsUseCase {
  GetNearbyEventsUseCase() {
    tz.initializeTimeZones();
  }

  List<EventModel> execute(List<EventModel> events) {
    final tz.Location location = tz.getLocation('America/Bogota');
    final now = tz.TZDateTime.now(location);

    return events.where((event) {
      final eventDate = DateTime.tryParse(event.date);
      if (eventDate == null) return false;

      final endParts = event.endTime.split(':');
      final eventEnd = tz.TZDateTime(
        location,
        eventDate.year,
        eventDate.month,
        eventDate.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      return eventEnd.isAfter(now);
    }).toList();
  }
}
