import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class UpdateEventUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(EventModel updatedEvent) async {
    await _db.updateEvent(updatedEvent);
  }
}
