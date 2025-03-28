import 'package:conference_app/data/models/event_model.dart';

class GetUpcomingEventsUseCase {
  List<EventModel> execute(List<EventModel> events) {
    List<EventModel> sortedEvents = List.from(events);
    sortedEvents.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    return sortedEvents;
  }
}
