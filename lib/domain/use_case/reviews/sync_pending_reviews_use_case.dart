import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/repository/review_api_provider.dart';

class SyncPendingReviewsUseCase {
  final EventsDB _db = EventsDB();
  final ReviewApiProvider _api = ReviewApiProvider();

  Future<void> execute() async {
    final pending = await _db.getPendingReviews();

    for (final review in pending) {
      try {
        await _api.postReview(review);
        await _db.markReviewAsSynced(review.id!);
      } catch (_) {
        // Si falla, lo dejamos en cola para el próximo intento
      }
    }
  }
}
