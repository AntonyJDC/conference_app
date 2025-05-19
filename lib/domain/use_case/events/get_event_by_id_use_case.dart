import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/repository/event_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEventByIdUseCase {
  Future<EventModel?> execute(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final repository = EventRepository(prefs);
    final allEvents = await repository.getAllEvents();
    try {
      return allEvents.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}
