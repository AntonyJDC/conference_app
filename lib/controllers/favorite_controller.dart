import 'package:conference_app/data/models/event_model.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <EventModel>[].obs;

  void toggleFavorite(EventModel event) {
    if (favorites.contains(event)) {
      favorites.remove(event);
    } else {
      favorites.add(event);
    }
  }

  bool isFavorite(EventModel event) {
    return favorites.contains(event);
  }
}
