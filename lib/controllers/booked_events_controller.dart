import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/domain/use_case/booked_events/get_all_booked_events_use_case.dart';
import 'package:conference_app/domain/use_case/booked_events/is_event_booked_use_case.dart';
import 'package:conference_app/domain/use_case/booked_events/subscribe_event_use_case.dart';
import 'package:conference_app/domain/use_case/booked_events/unsubscribe_event_use_case.dart';
import 'package:get/get.dart';

class BookedEventsController extends GetxController {
  final tasks = <EventModel>[].obs;

  final _subscribeEvent = SubscribeEventUseCase();
  final _unsubscribeEvent = UnsubscribeEventUseCase();
  final _getAllBookedEvents = GetAllBookedEventsUseCase();
  final _isEventBooked = IsEventBookedUseCase();

  @override
  void onInit() {
    super.onInit();
    loadBookedEvents();
  }

  Future<void> loadBookedEvents() async {
    final data = await _getAllBookedEvents.execute();
    tasks.assignAll(data);
  }

  Future<void> addTask(EventModel event) async {
    final isAlreadyBooked = await _isEventBooked.execute(event.id);
    if (!isAlreadyBooked) {
      await _subscribeEvent.execute(event);
      tasks.add(event);
      tasks.refresh(); // 🔄 para asegurar que se muestre
    }
  }

  Future<void> removeTask(String id) async {
    await _unsubscribeEvent.execute(id);
    tasks.removeWhere((e) => e.id == id);
  }

  Future<bool> isEventBooked(String id) async {
    return await _isEventBooked.execute(id);
  }

  void updateEvent(EventModel updated) {
    final index = tasks.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      tasks[index] = updated;
      tasks.refresh(); // 🔄 actualiza la UI de GetX
    }
  }
}
