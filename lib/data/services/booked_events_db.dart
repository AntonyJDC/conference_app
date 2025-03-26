import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:conference_app/data/models/event_model.dart';

class BookedEventsDB {
  static final BookedEventsDB _instance = BookedEventsDB._internal();
  factory BookedEventsDB() => _instance;
  BookedEventsDB._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'booked_events.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE booked_events (
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
    });
  }

  Future<void> insertEvent(EventModel event) async {
    final db = await database;
    await db.insert(
      'booked_events',
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

  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete('booked_events', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearEvents() async {
    final db = await database;
    await db.delete('booked_events');
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('booked_events');

    return List.generate(maps.length, (i) {
      return EventModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        date: maps[i]['date'],
        startTime: maps[i]['startTime'],
        endTime: maps[i]['endTime'],
        location: maps[i]['location'],
        capacity: maps[i]['capacity'],
        spotsLeft: maps[i]['spotsLeft'],
        categories: [],
      );
    });
  }

  Future<bool> isBooked(String id) async {
    final db = await database;
    final result =
        await db.query('booked_events', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
