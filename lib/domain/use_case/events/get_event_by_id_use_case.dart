import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';
import 'package:collection/collection.dart';

class GetEventByIdUseCase {
  final _db = EventsDB();

  Future<EventModel?> execute(String id) async {
    final all = await _db.getAllEvents();
    return all.firstWhereOrNull((e) => e.id == id);
  }
}
