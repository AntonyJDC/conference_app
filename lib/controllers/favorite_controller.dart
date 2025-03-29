import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/favorites/add_favorite_use_case.dart';
import 'package:conference_app/domain/use_case/favorites/get_favorite_events_use_case.dart';
import 'package:conference_app/domain/use_case/favorites/remove_favorite_use_case.dart';
import 'package:conference_app/domain/use_case/favorites/is_favorite_use_case.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <EventModel>[].obs;

  final _addFavoriteUseCase = AddFavoriteUseCase();
  final _removeFavoriteUseCase = RemoveFavoriteUseCase();
  final _getFavoritesUseCase = GetFavoriteEventsUseCase();
  final _isFavoriteUseCase = IsFavoriteUseCase();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await _getFavoritesUseCase.execute();
    favorites.assignAll(data);
  }

  Future<void> toggleFavorite(EventModel event) async {
    if (await _isFavoriteUseCase.execute(event.id)) {
      await _removeFavoriteUseCase.execute(event.id);
      favorites.removeWhere((e) => e.id == event.id);
    } else {
      await _addFavoriteUseCase.execute(event.id);
      favorites.add(event);
    }
  }

  bool isFavorite(EventModel event) {
    return favorites.any((e) => e.id == event.id);
  }
}
