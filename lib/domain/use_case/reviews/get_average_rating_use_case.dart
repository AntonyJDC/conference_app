import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetAverageRatingUseCase {
  final EventsDB _db = EventsDB();

  Future<double?> execute(String eventId) async {
    final List<ReviewModel> reviews = await _db.getReviewsByEventId(eventId);

    if (reviews.isEmpty) return null;

    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final average = total / reviews.length;

    return double.parse(average.toStringAsFixed(1)); // ejemplo: 4.3
  }
}
