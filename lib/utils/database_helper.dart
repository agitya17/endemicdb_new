// database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:endemicdb_new/models/bird_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('endemikdb_new.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE birds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        scientific_name TEXT,
        image_url TEXT,
        description TEXT,
        habitat TEXT,
        conservation_status TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insert(Bird bird) async {
    final db = await database;
    return await db.insert('birds', bird.toMap());
  }

  Future<List<Bird>> getAllBirds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('birds');
    return List.generate(maps.length, (i) {
      return Bird.fromMap(maps[i]);
    });
  }

  Future<void> toggleFavorite(int id) async {
    final db = await database;
    final bird = await db.query('birds', where: 'id = ?', whereArgs: [id]);
    final isFavorite = bird.isNotEmpty && bird.first['is_favorite'] == 1;
    await db.update(
      'birds',
      {'is_favorite': isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}