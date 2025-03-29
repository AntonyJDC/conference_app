import 'package:conference_app/data/services/events_db.dart';

class UnsubscribeEventUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(String id) async {
    await _db.unbookEvent(id);
  }
}
