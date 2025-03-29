import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/data/local/events_data.dart';

class InitializeEventsUseCase {
  final _db = EventsDB();

  Future<void> execute() async {
    final existing = await _db.getAllEvents();

    // Solo insertar si la BD está vacía
    if (existing.isEmpty) {
      for (final event in dummyEvents) {
        await _db.insertEvent(event);
      }
    }
  }
}
