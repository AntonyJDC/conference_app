import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/repository/review_api_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ReviewRepository {
  final _api = ReviewApiProvider();
  final _db = EventsDB();

  Future<List<ReviewModel>> getReviewsByEvent(String eventId) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      try {
        final reviews = await _api.getReviewsByEvent(eventId);

        // Guardar en caché local
        for (final review in reviews) {
          await _db.insertReview(review, synced: true, isMine: false);
        }

        return reviews;
      } catch (_) {
        // Si falla la API, usa SQLite como respaldo
        return await _db.getReviewsByEventId(eventId);
      }
    } else {
      return await _db.getReviewsByEventId(eventId);
    }
  }

  Future<void> syncPendingReviews() async {
    final pending = await _db.getPendingReviews();

    for (final review in pending) {
      try {
        await _api.postReview(review);
        await _db.markReviewAsSynced(review.id!);
      } catch (_) {
        // Sigue si falla alguna
      }
    }
  }
}
