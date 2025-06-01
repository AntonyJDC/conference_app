import 'package:conference_app/data/models/event_model.dart';
import 'package:conference_app/data/services/events_db.dart';
import 'package:conference_app/repository/event_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EventRepository {
  final EventApiProvider _api = EventApiProvider();
  final EventsDB _db = EventsDB();
  final SharedPreferences prefs;

  EventRepository(this.prefs);

  void _downloadImageInBackground(EventModel event) async {
    final localPath =
        await downloadAndSaveImage(event.imageUrl, '${event.id}.jpg');
    final updated = event.copyWith(localImagePath: localPath);
    await _db.updateEvent(updated);
  }

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
          final localPath =
              await downloadAndSaveImage(event.imageUrl, '${event.id}.jpg');
          final localEvent = event.copyWith(localImagePath: localPath);
          await _db.insertEvent(localEvent);
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
          final eventWithPath = event.copyWith(localImagePath: null);
          await _db.insertEvent(eventWithPath); // primero guarda sin imagen
          _downloadImageInBackground(event); // luego descarga en fondo
        }

        prefs.setInt(versionKey, remoteVersion);
      }
    } catch (_) {}
  }

  Future<String> downloadAndSaveImage(String imageUrl, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    if (await file.exists()) {
      return filePath; // Ya está descargado
    }

    final response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }
}
