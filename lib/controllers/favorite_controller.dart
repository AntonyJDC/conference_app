import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/favorites_use_case.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <EventModel>[].obs;
  final _useCase = FavoritesUseCase();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await _useCase.getFavorites();
    favorites.assignAll(data);
  }

  Future<void> toggleFavorite(EventModel event) async {
    if (isFavorite(event)) {
      favorites.removeWhere((e) => e.id == event.id);
      await _useCase.removeFavorite(event.id);
    } else {
      favorites.add(event);
      await _useCase.addFavorite(event);
    }
  }

  bool isFavorite(EventModel event) {
    return favorites.any((e) => e.id == event.id);
  }
}
