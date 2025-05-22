import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/repository/review_repository.dart';

class GetReviewsByEventUseCase {
  final _repo = ReviewRepository();

  Future<List<ReviewModel>> execute(String eventId) async {
    return await _repo.getReviewsByEvent(eventId);
  }
}
