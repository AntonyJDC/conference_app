import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/favorites_db.dart';

class FavoritesUseCase {
  final FavoritesDB _db = FavoritesDB();

  Future<void> addFavorite(EventModel event) => _db.insertFavorite(event);

  Future<void> removeFavorite(String id) => _db.deleteFavorite(id);

  Future<List<EventModel>> getFavorites() => _db.getFavorites();

  Future<bool> isFavorite(String id) => _db.isFavorite(id);
}
