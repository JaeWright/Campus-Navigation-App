/*
Author: Jaelen Wright - 100790481
This page initializes the courses and events databases, and helper functions
*/
import 'package:campusmapper/utilities/classes/events.dart';
import 'package:campusmapper/utilities/classes/courses.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

//class for initialization of databases for courses and events
class DBUtilsSQL {
  //initialize local courses database
  static Future<Database> initCourses() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'course_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE courses(id TEXT PRIMARY KEY, weekday TEXT, courseName TEXT, profName TEXT, roomNum TEXT, startTime TEXT, endTime TEXT)');
        // Call the function to insert pre-made values
        //_insertValuesCourses(db);
      },
      version: 1,
    );
    return database;
  }

  //initialize local events database
  static Future<Database> initEvents() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'event_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE events(id TEXT PRIMARY KEY, eventName TEXT, location TEXT, weekday TEXT, time TEXT, date DATETIME)');
        // Call the function to insert pre-made values
        //_insertValuesEvents(db);
      },
      version: 1,
    );
    return database;
  }
}

class CoursesModel {
  //sql database interactions

  //get course data from sqlLite database
  Future getAllCoursesLocal() async {
    final db = await DBUtilsSQL.initCourses();
    final List maps = await db.query('courses');

    List results = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        results.add(Course.fromMapLocal(maps[i]));
      }
    }

    return results;
  }

  //insert course data to sqlLite database
  Future insertLocal(Course course) async {
    final db = await DBUtilsSQL.initCourses();
    return db.insert(
      'courses',
      course.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //delete course from sql database
  Future<int> deleteCourseLocal(String? id) async {
    final db = await DBUtilsSQL.initCourses();
    return db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //clear local database when the user logs out
  Future clearLocal() async {
    databaseFactory.deleteDatabase(
        "/data/data/com.example.campusmapper/databases/courses_manager.db");
  }
}

//class for interaction between event class and local database
class EventsModel {
  //sql database interactions

  //get event data from sqlLite database
  Future getAllEventsLocal() async {
    final db = await DBUtilsSQL.initEvents();
    final List maps = await db.query('events');

    List results = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        results.add(Event.fromMapLocal(maps[i]));
      }
    }

    return results;
  }

  //adds new event to sql database
  Future<int> insertEventLocal(Event event) async {
    final db = await DBUtilsSQL.initEvents();
    return db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //update event in sql database
  Future<int> updateEventLocal(Event event) async {
    final db = await DBUtilsSQL.initEvents();
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  //delete event from sql database
  Future<int> deleteEventLocal(String id) async {
    final db = await DBUtilsSQL.initEvents();
    return db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //clear local database when user logs out
  Future clearLocal() async {
    databaseFactory.deleteDatabase(
        "/data/data/com.example.campusmapper/databases/events_manager.db");
  }
}
