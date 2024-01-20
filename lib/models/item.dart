import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Item {
  Item({
    this.id,
    required this.title,
    this.subTitle,
    required this.text,
    required this.dictionaryId,
  });

  final int? id;
  final String title;
  final String? subTitle;
  final String text;
  final int dictionaryId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'text': text,
      'dictionaryId': dictionaryId,
    };
  }

  static Future<Database> initializeDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'item_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING NOT NULL, subTitle STRING, text TEXT NOT NULL, dictionaryId INTEGER NOT NULL, FOREIGN KEY (dictionaryId) REFERENCES dictionaries (id))",
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
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'dictionaryId = ?',
      whereArgs: [dictionaryId],
      orderBy: 'title COLLATE NOCASE',
    );
    return List.generate(maps.length, (index) {
      return Item(
        id: maps[index]['id'],
        title: maps[index]['title'],
        subTitle: maps[index]['subTitle'],
        text: maps[index]['text'],
        dictionaryId: maps[index]['dictionaryId'],
      );
    });
  }

  static Future<Item?> findById(int id) async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> map =
        await db.query('items', where: 'id = ?', whereArgs: [id]);

    if (map.isEmpty) {
      return null;
    } else {
      return Item(
        id: map[0]['id'],
        title: map[0]['title'],
        subTitle: map[0]['subTitle'],
        text: map[0]['text'],
        dictionaryId: map[0]['dictionaryId'],
      );
    }
  }

  static Future<Item?> findByTitle(String title) async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db
        .query('items', where: 'title = ? OR subtitle = ?', whereArgs: [title]);

    if (maps.isEmpty) {
      return null;
    } else {}
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
