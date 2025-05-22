import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/repository/review_repository.dart';

class UpdateAverageRatingUseCase {
  final EventsDB _db = EventsDB();
  final ReviewRepository _repository = ReviewRepository();

  Future<void> execute(String eventId) async {
    final reviews = await _repository.getReviewsByEvent(eventId);

    if (reviews.isEmpty) return;

    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final average = total / reviews.length;

    final EventModel? event = await _db.getEventById(eventId);
    if (event == null) return;

    final updatedEvent = event.copyWith(averageRating: average);
    await _db.updateEvent(updatedEvent);
  }
}
