import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class GetMyReviewsUseCase {
  final EventsDB _db = EventsDB();

  Future<List<ReviewModel>> execute() async {
    return await _db.getMyReviews();
  }
}
