import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:conference_app/data/models/event_model.dart';

class EventsDB {
  static final EventsDB _instance = EventsDB._internal();
  factory EventsDB() => _instance;
  EventsDB._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'events.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE events (
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          imageUrl TEXT,
          date TEXT,
          startTime TEXT,
          endTime TEXT,
          location TEXT,
          capacity INTEGER,
          spotsLeft INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE booked_events (
          id TEXT PRIMARY KEY
        )
      ''');
    });
  }

  Future<void> insertEvent(EventModel event) async {
    final db = await database;
    await db.insert(
      'events',
      {
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'imageUrl': event.imageUrl,
        'date': event.date,
        'startTime': event.startTime,
        'endTime': event.endTime,
        'location': event.location,
        'capacity': event.capacity,
        'spotsLeft': event.spotsLeft,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(EventModel event) async {
    final db = await database;
    await db.update(
      'events',
      {
        'title': event.title,
        'description': event.description,
        'imageUrl': event.imageUrl,
        'date': event.date,
        'startTime': event.startTime,
        'endTime': event.endTime,
        'location': event.location,
        'capacity': event.capacity,
        'spotsLeft': event.spotsLeft,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events');
    return maps.map((map) => EventModel.fromMap(map)).toList();
  }

  Future<EventModel?> getEventById(String id) async {
    final db = await database;
    final result = await db.query('events', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return EventModel.fromMap(result.first);
    }
    return null;
  }

  // BOOKED EVENTS TABLE METHODS

  Future<void> bookEvent(String id) async {
    final db = await database;
    await db.insert('booked_events', {'id': id},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> unbookEvent(String id) async {
    final db = await database;
    await db.delete('booked_events', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isEventBooked(String id) async {
    final db = await database;
    final result =
        await db.query('booked_events', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<List<String>> getBookedEventIds() async {
    final db = await database;
    final result = await db.query('booked_events');
    return result.map((e) => e['id'] as String).toList();
  }

  Future<List<EventModel>> getBookedEvents() async {
    final db = await database;
    final ids = await getBookedEventIds();

    if (ids.isEmpty) return [];

    final result = await db.query(
      'events',
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    return result.map((map) => EventModel.fromMap(map)).toList();
  }
}
