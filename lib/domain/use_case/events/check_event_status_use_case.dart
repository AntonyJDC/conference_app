import 'package:conference_app/data/models/event_model.dart';
import 'package:timezone/timezone.dart' as tz;

class CheckEventStatusUseCase {
  final tz.Location _colombiaTZ;

  CheckEventStatusUseCase() : _colombiaTZ = tz.getLocation('America/Bogota');

  bool execute(EventModel event) {
    final eventDate = DateTime.tryParse(event.date);
    if (eventDate == null) return false;

    final endParts = event.endTime.split(':');
    final eventEnd = tz.TZDateTime(
      _colombiaTZ,
      eventDate.year,
      eventDate.month,
      eventDate.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    return tz.TZDateTime.now(_colombiaTZ)
        .isAfter(eventEnd.subtract(const Duration(seconds: 2)));
  }
}
