import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetEventsByCategoryUseCase {
  final EventsDB _db = EventsDB();

  Future<List<EventModel>> execute(String category) async {
    final allEvents = await _db.getAllEvents();

    // Filtramos eventos que contienen la categoría (case-insensitive)
    return allEvents.where((event) {
      return event.categories.any(
        (cat) => cat.toLowerCase() == category.toLowerCase(),
      );
    }).toList();
  }
}
