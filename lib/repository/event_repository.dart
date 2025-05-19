import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/repository/event_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class EventRepository {
  final EventApiProvider _api = EventApiProvider();
  final EventsDB _db = EventsDB();
  final SharedPreferences prefs;

  EventRepository(this.prefs);

  static const versionKey = 'events';

  Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<List<EventModel>> getAllEvents() async {
    if (await hasConnection()) {
      try {
        final remoteEvents = await _api.fetchRemoteEvents();
        await _db.clearEvents();
        for (final event in remoteEvents) {
          await _db.insertEvent(event);
        }
        return remoteEvents;
      } catch (e) {
        // Si hay red pero error, usar local como fallback
        return await _db.getAllEvents();
      }
    } else {
      return await _db.getAllEvents();
    }
  }

  Future<void> syncEventsIfNeeded() async {
    try {
      final remoteVersion = await _api.fetchRemoteVersion();
      final localVersion = prefs.getInt(versionKey) ?? 0;

      final localEvents = await _db.getAllEvents();
      if (remoteVersion > localVersion || localEvents.isEmpty) {
        final events = await _api.fetchRemoteEvents();
        await _db.clearEvents();
        for (final event in events) {
          await _db.insertEvent(event);
        }
        prefs.setInt(versionKey, remoteVersion);
      }
    } catch (_) {
      // Fallo de red: ignorar
    }
  }
}
