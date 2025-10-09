import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static const _dbName = 'makanku.db';
  static const _dbVersion = 2;
  static const table = 'favorites';

  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    // FORCE DELETE DATABASE LAMA (Uncomment baris ini untuk reset)
    // await databaseFactory.deleteDatabase(path);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Cek apakah table sudah ada dengan struktur yang benar
        final tables = await db.rawQuery(
            "SELECT sql FROM sqlite_master WHERE type='table' AND name='$table'"
        );
        if (tables.isEmpty) {
          // Table belum ada, buat baru
          await _onCreate(db, _dbVersion);
        }
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old table and recreate with TEXT columns for menus and customerReviews
      await db.execute('DROP TABLE IF EXISTS $table');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
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
    await db.insert(table, r.toDatabase(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(table);
    return maps.map((m) => Restaurant.fromDatabase(Map<String, dynamic>.from(m))).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return maps.isNotEmpty;
  }

  // Method untuk menghapus database (gunakan untuk reset)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);
    await databaseFactory.deleteDatabase(path);
    _db = null;
  }
}