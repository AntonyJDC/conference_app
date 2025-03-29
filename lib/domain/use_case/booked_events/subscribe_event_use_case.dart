import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class SubscribeEventUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(EventModel event) async {
    await _db.bookEvent(event.id);
  }
}
