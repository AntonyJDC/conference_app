import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/repository/event_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEventsByCategoryUseCase {
  Future<List<EventModel>> execute(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final repository = EventRepository(prefs);
    final events = await repository.getAllEvents();
    return events.where((e) => e.categories.contains(category)).toList();
  }
}
