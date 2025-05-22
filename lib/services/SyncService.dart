import 'dart:async';
import 'package:conference_app/domain/use_case/reviews/sync_pending_reviews_use_case.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Timer? _timer;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) async {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity != ConnectivityResult.none) {
        await SyncPendingReviewsUseCase().execute();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
