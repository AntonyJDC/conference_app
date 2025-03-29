import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class AddReviewUseCase {
  final EventsDB _db = EventsDB();

  Future<void> execute(ReviewModel review) async {
    await _db.insertReview(review);
  }
}
