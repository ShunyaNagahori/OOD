import 'package:ood/models/db_helper.dart';
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

  static Future<int> saveItem(Item item) async {
    final Database db = await DBHelper.initializeDatabase();
    int itemId = await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return itemId;
  }

  static Future<List<Item>> getAllItems(int dictionaryId) async {
    final Database db = await DBHelper.initializeDatabase();
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
    final Database db = await DBHelper.initializeDatabase();
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

  static Future<List<Item>?> findByWord(String word) async {
    final Database db = await DBHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'title LIKE ? OR subtitle LIKE ? OR text LIKE ?',
      whereArgs: ['%$word%', '%$word%', '%$word%'],
    );

    if (maps.isEmpty) {
      return null;
    } else {
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
  }

  static Future<int> updateItem(Item item) async {
    final Database db = await DBHelper.initializeDatabase();
    int itemId = await db.update(
      'items',
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return itemId;
  }

  static Future<void> deleteItem(int id) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'items',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllItems(int dictionaryId) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'items',
      where: 'dictionaryId = ?',
      whereArgs: [dictionaryId],
    );
  }
}
