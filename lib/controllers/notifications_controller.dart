import 'package:conference_app/data/models/event_model.dart';
import 'package:get/get.dart';
import 'package:conference_app/controllers/booked_events_controller.dart';

class NotificationsController extends GetxController {
  final BookedEventsController bookedEventsController = Get.find<BookedEventsController>();
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _filterUpcomingEvents();
    ever(bookedEventsController.tasks, (_) => _filterUpcomingEvents());
  }

  void _filterUpcomingEvents() {
    final now = DateTime.now();
    final oneDayFromNow = now.add(const Duration(days: 1));

    upcomingEvents.value = bookedEventsController.tasks.where((event) {
      final eventDate = DateTime.tryParse(event.date);
      if (eventDate == null) return false;
      return eventDate.isAfter(now) && eventDate.isBefore(oneDayFromNow);
    }).toList();
  }
}