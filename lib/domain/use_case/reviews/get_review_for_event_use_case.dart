import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetReviewForEventUseCase {
  final EventsDB _eventsDB = EventsDB();

  Future<ReviewModel?> execute(String eventId) async {
    List<ReviewModel> reviews = await _eventsDB.getReviewsByEventId(eventId);
    if (reviews.isNotEmpty) {
      return reviews.first;
    }
    return null;
  }
}
