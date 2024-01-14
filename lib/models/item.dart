import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Item {
  Item({
    this.id,
    required this.title,
    required this.text,
    required this.dictionaryId,
  });

  final int? id;
  final String title;
  final String text;
  final int dictionaryId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'dictionaryId': dictionaryId,
    };
  }

  static Future<Database> initializeDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'item_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, text TEXT, dictionaryId INTEGER NOT NULL, FOREIGN KEY (dictionaryId) REFERENCES dictionaries (id))",
        );
      },
      version: 1,
    );

    return database;
  }

  static Future<void> saveItem(Item item) async {
    final Database db = await initializeDatabase();
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Item>> getAllItems(int dictionaryId) async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db
        .query('items', where: 'dictionaryId = ?', whereArgs: [dictionaryId]);
    return List.generate(maps.length, (index) {
      return Item(
        id: maps[index]['id'],
        title: maps[index]['title'],
        text: maps[index]['text'],
        dictionaryId: maps[index]['dictionaryId'],
      );
    });
  }

  static Future<Item?> findByTitle(int id) async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: 'title = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    } else {}
    return null;
  }

  static Future<void> updateItem(Item item) async {
    final Database db = await initializeDatabase();
    await db.update(
      'items',
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteItem(int id) async {
    final Database db = await initializeDatabase();
    await db.delete(
      'items',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
