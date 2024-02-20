import 'package:ood/models/db_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Picture {
  Picture({this.id, required this.data, this.itemId});

  final int? id;
  final String data;
  final int? itemId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
    };
  }

  static Future<void> savePicture(Picture picture) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.insert(
      'pictures',
      picture.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Picture>> getAllPictures() async {
    final Database db = await DBHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('pictures');
    return List.generate(maps.length, (index) {
      return Picture(
        id: maps[index]['id'],
        data: maps[index]['data'],
        itemId: maps[index]['itemId'],
      );
    });
  }

  static Future<Picture?> findById(int id) async {
    final Database db = await DBHelper.initializeDatabase();
    final List<Map<String, dynamic>> map = await db.query(
      'pictures',
      where: "id = ?",
      whereArgs: [id],
    );

    if (map.isEmpty) {
      return null;
    } else {
      return Picture(
        id: map[0]['id'],
        data: map[0]['data'],
        itemId: map[0]['itemId'],
      );
    }
  }

  static Future<void> updatePicture(Picture picture) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.update(
      'pictures',
      picture.toMap(),
      where: 'id = ?',
      whereArgs: [picture.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deletePicture(int id) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'pictures',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
