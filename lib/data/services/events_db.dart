import 'package:conference_app/data/models/review_model.dart';
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
          spotsLeft INTEGER,
          categories TEXT,
          averageRating REAL
        )
      ''');

      await db.execute('''
        CREATE TABLE booked_events (
          id TEXT PRIMARY KEY
        )
      ''');

      await db.execute('''
        CREATE TABLE reviews (
          id TEXT PRIMARY KEY,
          eventId TEXT,
          rating INTEGER,
          comment TEXT,
          createdAt TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE favorites (
          id TEXT PRIMARY KEY
        )
      ''');
    });
  }

  Future<void> insertEvent(EventModel event) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> updateEvent(EventModel event) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        'events',
        event.toMap(),
        where: 'id = ?',
        whereArgs: [event.id],
      );
    });
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

  // ─── Booked Events ─────────────────────────

  Future<void> bookEvent(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'booked_events',
        {'id': id},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    });
  }

  Future<void> unbookEvent(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('booked_events', where: 'id = ?', whereArgs: [id]);
    });
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

  // ─── Reviews ─────────────────────────

  Future<void> insertReview(ReviewModel review) async {
    final db = await database;
    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReviewModel>> getReviewsByEventId(String eventId) async {
    final db = await database;
    final result = await db.query(
      'reviews',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return result.map((e) => ReviewModel.fromMap(e)).toList();
  }

  Future<bool> hasReviewed(String eventId) async {
    final db = await database;
    final result = await db.query(
      'reviews',
      where: 'eventId = ?',
      whereArgs: [eventId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<ReviewModel>> getMyReviews() async {
    final db = await database;
    final bookedEventIds = await getBookedEventIds();

    if (bookedEventIds.isEmpty) return [];

    final result = await db.query(
      'reviews',
      where:
          'eventId IN (${List.filled(bookedEventIds.length, '?').join(',')})',
      whereArgs: bookedEventIds,
    );

    return result.map((e) => ReviewModel.fromMap(e)).toList();
  }

  // ─── Favorites ─────────────────────────

  Future<void> addFavorite(String id) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'id': id},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<EventModel>> getFavoriteEvents() async {
    final db = await database;
    final result = await db.query('favorites');

    if (result.isEmpty) return [];

    final ids = result.map((e) => e['id'] as String).toList();
    final eventResults = await db.query(
      'events',
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    return eventResults.map((e) => EventModel.fromMap(e)).toList();
  }
}
