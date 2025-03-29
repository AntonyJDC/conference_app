import 'package:conference_app/data/services/events_db.dart';

class IsFavoriteUseCase {
  final EventsDB _db = EventsDB();

  Future<bool> execute(String id) async {
    return await _db.isFavorite(id);
  }
}
