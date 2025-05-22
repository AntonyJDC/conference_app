import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/repository/review_repository.dart';

class GetAverageRatingUseCase {
  final ReviewRepository _repository = ReviewRepository();

  Future<double?> execute(String eventId) async {
    final List<ReviewModel> reviews = await _repository.getReviewsByEvent(eventId);

    if (reviews.isEmpty) return null;

    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final average = total / reviews.length;

    return double.parse(average.toStringAsFixed(1));
  }
}
