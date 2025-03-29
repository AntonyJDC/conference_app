import 'package:conference_app/data/services/events_db.dart';

class HasReviewedUseCase {
  final EventsDB _db = EventsDB();

  Future<bool> execute(String eventId) async {
    return await _db.hasReviewed(eventId);
  }
}
