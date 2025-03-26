import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/booked_events_db.dart';
import 'package:get/get.dart';

class BookedEventsController extends GetxController {
  final _db = BookedEventsDB();

  var tasks = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookedEvents();
  }

  Future<void> loadBookedEvents() async {
    final events = await _db.getAllEvents();
    tasks.assignAll(events);
  }

  Future<void> addTask(EventModel event) async {
    final alreadyExists = tasks.any((e) => e.id == event.id);
    if (!alreadyExists) {
      tasks.add(event);
      await _db.insertEvent(event);
    }
  }

  Future<void> removeTask(String id) async {
    tasks.removeWhere((e) => e.id == id);
    await _db.deleteEvent(id);
  }

  Future<void> clearTasks() async {
    tasks.clear();
    await _db.clearEvents();
  }

  bool isSubscribed(String id) {
    return tasks.any((e) => e.id == id);
  }

  EventModel? getById(String id) {
    return tasks.firstWhereOrNull((e) => e.id == id);
  }
}
