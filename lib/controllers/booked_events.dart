import 'package:get/get.dart';
import 'package:conference_app/data/models/event_model.dart';

class BookedEventsController extends GetxController {
  var tasks = <EventModel>[].obs; // Lista reactiva

  void addTask(EventModel event) {
    if (!tasks.any((e) => e.id == event.id)) {
      tasks.add(event);
    }
  }
}
