import 'package:conference_app/data/services/events_db.dart';

class IsEventBookedUseCase {
  final EventsDB _db = EventsDB();

  Future<bool> execute(String id) async {
    return await _db.isEventBooked(id);
  }
}
