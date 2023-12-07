import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:campusmapper/utilities/user.dart';

class DBUtils {
  static Future init() async {
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'tweetb_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user(id TEXT PRIMARY KEY, email TEXT, firstname TEXT, lastname TEXT, sid TEXT)');
      },
      version: 1,
    );

    return database;
  }
}

class UserModel {
  Future<List<User>> getUser() async {
    final db = await DBUtils.init();
    final List maps = await db.query('user');
    List<User> result = [];
    for (int i = 0; i < maps.length; i++) {
      result.add(User.fromMap(maps[i]));
    }
    return result;
  }

  Future<int> insertUser(User user) async {
    final db = await DBUtils.init();
    return db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeUser(User user) async {
    final db = await DBUtils.init();
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
