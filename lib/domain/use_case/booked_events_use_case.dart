import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class BookedEventsUseCase {
  final db = EventsDB();

  /// Agrega el ID del evento a la tabla booked_events
  Future<void> subscribe(EventModel event) async {
    await db.bookEvent(event.id);
  }

  /// Elimina el ID del evento de la tabla booked_events
  Future<void> unsubscribe(String id) async {
    await db.unbookEvent(id);
  }

  /// Devuelve la lista completa de eventos suscritos
  Future<List<EventModel>> getAllBookedEvents() async {
    return await db.getBookedEvents();
  }

  /// Verifica si el evento está suscrito
  Future<bool> isBooked(String id) async {
    return await db.isEventBooked(id);
  }
}
