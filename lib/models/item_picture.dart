import 'package:ood/models/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ItemPicture {
  ItemPicture({this.id, required this.itemId, required this.pictureId});

  final int? id;
  final int itemId;
  final int pictureId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'pictureId': pictureId,
    };
  }

  static Future<void> saveItemPicture(ItemPicture itemPicture) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.insert(
      'item_picture',
      itemPicture.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ItemPicture>> getItemPicturesByItemId(int itemId) async {
    final Database db = await DBHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_picture',
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
    return List.generate(maps.length, (index) {
      return ItemPicture(
        itemId: maps[index]['itemId'],
        pictureId: maps[index]['pictureId'],
      );
    });
  }

  static Future<List<ItemPicture>> getItemsByPictureId(int pictureId) async {
    final Database db = await DBHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_picture',
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );
    return List.generate(maps.length, (index) {
      return ItemPicture(
        itemId: maps[index]['itemId'],
        pictureId: maps[index]['pictureId'],
      );
    });
  }

  static Future<void> deleteItemPicture(int itemId, int pictureId) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'item_picture',
      where: 'itemId = ? AND pictureId = ?',
      whereArgs: [itemId, pictureId],
    );
  }

  static Future<void> deleteByItemId(int itemId) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'item_picture',
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
  }

  static Future<void> deleteByPictureId(int pictureId) async {
    final Database db = await DBHelper.initializeDatabase();
    await db.delete(
      'item_picture',
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );
  }
}
