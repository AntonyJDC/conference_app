import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/favorites_db.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <EventModel>[].obs;
  final dbHelper = FavoritesDB();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await dbHelper.getFavorites();
    favorites.assignAll(data);
  }

  void toggleFavorite(EventModel event) async {
    if (isFavorite(event)) {
      favorites.removeWhere((e) => e.id == event.id);
      await dbHelper.deleteFavorite(event.id);
    } else {
      favorites.add(event);
      await dbHelper.insertFavorite(event);
    }
  }

  bool isFavorite(EventModel event) {
    return favorites.any((e) => e.id == event.id);
  }
}
