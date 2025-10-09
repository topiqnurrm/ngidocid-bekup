import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static const _dbName = 'makanku.db';
  static const _dbVersion = 1;
  static const table = 'favorites';

  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        city TEXT,
        address TEXT,
        pictureId TEXT,
        rating REAL,
        menus TEXT,
        customerReviews TEXT
      )
    ''');
  }

  Future<void> insertFavorite(Restaurant r) async {
    final db = await database;
    await db.insert(table, r.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(table);
    return maps.map((m) => Restaurant.fromJson(Map<String, dynamic>.from(m))).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return maps.isNotEmpty;
  }
}
