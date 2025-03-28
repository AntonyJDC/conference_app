import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetAllEventsUseCase {
  final EventsDB _db = EventsDB();

  Future<List<EventModel>> execute() async {
    return await _db.getAllEvents();
  }
}
