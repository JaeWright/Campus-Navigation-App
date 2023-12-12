//Author: Luca Lotito
//SQL database managing the currently logged in user. Used for checking the user accross multiple pages, and for persistence
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:campusmapper/utilities/classes/user.dart';

class DBUtils {
  static Future init() async {
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'user_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user(id TEXT PRIMARY KEY, email TEXT, firstname TEXT, lastname TEXT)');
      },
      version: 1,
    );

    return database;
  }
}

class UserModel {
  //Gets the current user
  Future<List<User>> getUser() async {
    final db = await DBUtils.init();
    final List maps = await db.query('user');
    List<User> result = [];
    for (int i = 0; i < maps.length; i++) {
      result.add(User.fromMap(maps[i]));
    }
    return result;
  }

  //Places a user in the database. Should only be at most one user at any time
  Future<int> insertUser(User user) async {
    final db = await DBUtils.init();
    return db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Clears the database
  Future<int> removeUser(User user) async {
    final db = await DBUtils.init();
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
