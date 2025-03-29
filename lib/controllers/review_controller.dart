import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/domain/use_case/reviews/add_review_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/get_reviews_by_event_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/has_reviewed_use_case.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final _reviews = <ReviewModel>[].obs;
  List<ReviewModel> get reviews => _reviews;

  final _addReviewUseCase = AddReviewUseCase();
  final _getReviewsUseCase = GetReviewsByEventUseCase();
  final _hasReviewedUseCase = HasReviewedUseCase();

  Future<void> loadReviews(String eventId) async {
    final data = await _getReviewsUseCase.execute(eventId);
    _reviews.assignAll(data);
  }

  Future<void> addReview(ReviewModel review) async {
    await _addReviewUseCase.execute(review);
    await loadReviews(review.eventId);
  }

  Future<bool> hasReviewed(String eventId) async {
    return await _hasReviewedUseCase.execute(eventId);
  }
}
