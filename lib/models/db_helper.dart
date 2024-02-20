import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> initializeDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'ood_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE dictionaries(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING NOT NULL, category STRING)',
        );
        await db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING NOT NULL, subTitle STRING, text TEXT NOT NULL, dictionaryId INTEGER NOT NULL, FOREIGN KEY (dictionaryId) REFERENCES dictionaries (id) ON DELETE CASCADE)',
        );
        await db.execute(
          'CREATE TABLE pictures(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT NOT NULL)',
        );
        await db.execute(
          'CREATE TABLE item_picture(id INTEGER PRIMARY KEY AUTOINCREMENT, itemId INTEGER NOT NULL, pictureId INTEGER NOT NULL, FOREIGN KEY (itemId) REFERENCES items (id) ON DELETE CASCADE, FOREIGN KEY (pictureId) REFERENCES pictures (id) ON DELETE CASCADE, UNIQUE(itemId, pictureId))',
        );
      },
      version: 1,
    );

    return database;
  }
}
