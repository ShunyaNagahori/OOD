import 'package:ood/models/db_helper.dart';
import 'package:ood/models/item.dart';
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

  static Future<void> saveDictionary(Dictionary dictionary) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.insert(
      'dictionaries',
      dictionary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Dictionary>> getAllDictionaries() async {
    final Database db = await DBHelper.initializeDatabase();
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
    final Database db = await DBHelper.initializeDatabase();
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
    final Database db = await DBHelper.initializeDatabase();
    await db.update(
      'dictionaries',
      dictionary.toMap(),
      where: 'id = ?',
      whereArgs: [dictionary.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteDictionary(int id) async {
    Item.deleteAllItems(id);
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'dictionaries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
