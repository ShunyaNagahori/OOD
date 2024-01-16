import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dictionary {
  Dictionary({this.id, required this.title, this.category});

  final int? id;
  final String title;
  final String? category;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
    };
  }

  static Future<Database> initializeDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'dictionary_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dictionaries(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING NOT NULL, category STRING)",
        );
      },
      version: 1,
    );

    return database;
  }

  static Future<void> saveDictionary(Dictionary dictionary) async {
    final Database db = await initializeDatabase();
    await db.insert(
      'dictionaries',
      dictionary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Dictionary>> getAllDictionaries() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('dictionaries');
    return List.generate(maps.length, (index) {
      return Dictionary(
        id: maps[index]['id'],
        title: maps[index]['title'],
        category: maps[index]['category'],
      );
    });
  }

  static Future<Dictionary?> findById(int id) async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> map = await db.query(
      'dictionaries',
      where: "id = ?",
      whereArgs: [id],
    );

    if (map.isEmpty) {
      return null;
    } else {
      return Dictionary(
        id: map[0]['id'],
        title: map[0]['title'],
        category: map[0]['category'],
      );
    }
  }

  static Future<void> updateDictionary(Dictionary dictionary) async {
    final Database db = await initializeDatabase();
    await db.update(
      'dictionaries',
      dictionary.toMap(),
      where: 'id = ?',
      whereArgs: [dictionary.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteDictionary(int id) async {
    final Database db = await initializeDatabase();
    await db.delete(
      'dictionaries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
