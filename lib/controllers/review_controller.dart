import 'package:conference_app/data/models/review_model.dart';
import 'package:conference_app/domain/use_case/reviews/get_reviews_by_event_use_case.dart';
import 'package:conference_app/domain/use_case/reviews/has_reviewed_use_case.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  // Mapa de reseñas por evento
  final RxMap<String, List<ReviewModel>> _reviewsByEvent =
      <String, List<ReviewModel>>{}.obs;

  final _getReviewsUseCase = GetReviewsByEventUseCase();
  final _hasReviewedUseCase = HasReviewedUseCase();

  // Getter para obtener todas las reseñas propias (una por evento)
  List<ReviewModel> get reviews {
    return _reviewsByEvent.values.expand((list) => list).toList();
  }

  // Cargar reseñas de un evento
  Future<void> loadReviews(String eventId) async {
    final data = await _getReviewsUseCase.execute(eventId);
    _reviewsByEvent[eventId] = data;
    _reviewsByEvent.refresh();
  }

  // Agregar una reseña (si ya existe, la reemplaza)
  Future<void> addReview(ReviewModel review) async {
    final eventId = review.eventId;

    final currentList = _reviewsByEvent[eventId] ?? [];
    final index = currentList.indexWhere((r) => r.id == review.id);

    if (index != -1) {
      currentList[index] = review;
    } else {
      currentList.add(review);
    }

    _reviewsByEvent[eventId] = currentList;
    _reviewsByEvent.refresh();
  }

  // Verificar si ya se ha hecho una reseña para un evento
  Future<bool> hasReviewed(String eventId) async {
    return await _hasReviewedUseCase.execute(eventId);
  }

  // Obtener reseñas de un evento específico
  List<ReviewModel> getReviewsForEvent(String eventId) {
    return _reviewsByEvent[eventId] ?? [];
  }

  // Obtener solo mi reseña para un evento (una sola)
  ReviewModel? getMyReviewForEvent(String eventId) {
    final reviews = _reviewsByEvent[eventId];
    if (reviews == null || reviews.isEmpty) return null;
    return reviews.first;
  }

  // Obtener promedio actualizado de un evento
  double getAverageForEvent(String eventId) {
    final reviews = getReviewsForEvent(eventId);
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    return double.parse((total / reviews.length).toStringAsFixed(1));
  }

  // Obtener número total de reseñas de un evento
  int getReviewCountForEvent(String eventId) {
    return getReviewsForEvent(eventId).length;
  }
} 
