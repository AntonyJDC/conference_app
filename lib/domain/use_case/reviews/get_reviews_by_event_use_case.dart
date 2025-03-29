import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetReviewsByEventUseCase {
  final EventsDB _db = EventsDB();

  Future<List<ReviewModel>> execute(String eventId) async {
    return await _db.getReviewsByEventId(eventId);
  }
}
