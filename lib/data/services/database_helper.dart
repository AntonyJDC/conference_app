import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:conference_app/data/models/event_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE favorites (
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

  Future<void> insertFavorite(EventModel event) async {
    final db = await database;
    await db.insert(
      'favorites',
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

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }

  Future<List<EventModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

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
        categories: [], // Si quieres manejar categorías, ajusta aquí
      );
    });
  }
}
