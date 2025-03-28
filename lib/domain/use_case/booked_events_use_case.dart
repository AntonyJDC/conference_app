import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';

class BookedEventsUseCase {
  final db = EventsDB();

  /// Agrega el evento completo y su ID a la tabla de eventos suscritos
  Future<void> subscribe(EventModel event) async {
    await db.insertEvent(event); // Guarda toda la info del evento
    await db.bookEvent(event.id); // Registra que está suscrito
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

  /// Actualiza un evento ya existente (ej. para guardar comentarios o estrellas)
  Future<void> updateEvent(EventModel event) async {
    await db.updateEvent(event); // 🔁 importante para guardar feedback
  }
}
