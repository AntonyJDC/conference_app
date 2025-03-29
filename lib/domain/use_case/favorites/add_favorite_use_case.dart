import 'package:conference_app/data/services/events_db.dart';

class AddFavoriteUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(String eventId) async {
    await _db.addFavorite(eventId);
  }
}
