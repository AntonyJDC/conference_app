import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/repository/review_api_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddReviewUseCase {
  final EventsDB _db = EventsDB();
  final ReviewApiProvider _api = ReviewApiProvider();

  Future<void> execute(ReviewModel review) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      try {
        await _api.postReview(review);
        await _db.insertReview(review, synced: true, isMine: true);
      } catch (e) {
        await _db.insertReview(review, synced: false, isMine: true);
      }
    } else {
      await _db.insertReview(review, synced: false, isMine: true);
    }
  }
}
