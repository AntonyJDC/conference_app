import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/models/review_model.dart';

class UpdateAverageRatingUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(String eventId) async {
    final List<ReviewModel> reviews = await _db.getReviewsByEventId(eventId);

    if (reviews.isEmpty) return;

    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final average = total / reviews.length;

    final EventModel? event = await _db.getEventById(eventId);
    if (event == null) return;

    final updatedEvent = event.copyWith(averageRating: average);
    await _db.updateEvent(updatedEvent);
  }
}
