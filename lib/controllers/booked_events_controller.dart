import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/booked_events_use_case.dart';
import 'package:get/get.dart';

class BookedEventsController extends GetxController {
  final tasks = <EventModel>[].obs;
  final useCase = BookedEventsUseCase();

  @override
  void onInit() {
    super.onInit();
    loadBookedEvents();
  }

  Future<void> loadBookedEvents() async {
    final data = await useCase.getAllBookedEvents();
    tasks.assignAll(data);
  }

  Future<void> addTask(EventModel event) async {
    final isAlreadyBooked = await useCase.isBooked(event.id);
    if (!isAlreadyBooked) {
      await useCase.subscribe(event);
      tasks.add(event);
      tasks.refresh(); // 🔄 para asegurar que se muestre
    }
  }

  Future<void> removeTask(String id) async {
    await useCase.unsubscribe(id);
    tasks.removeWhere((e) => e.id == id);
  }

  Future<bool> isEventBooked(String id) async {
    return await useCase.isBooked(id);
  }

  void updateEvent(EventModel updated) {
    final index = tasks.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      tasks[index] = updated;
      tasks.refresh(); // 🔄 actualiza la UI de GetX
    }
  }
}
