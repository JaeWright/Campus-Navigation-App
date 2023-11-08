import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'courses.dart';
import 'events.dart';

class DBUtils {
  static Future<Database> initCourses() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'students_manager.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE courses(id INTEGER PRIMARY KEY, weekday TEXT, courseName TEXT, profName TEXT, roomNum TEXT, startTime TEXT, endTime TEXT)');
        // Call the function to insert pre-made values
        _insertValuesCourses(db);



      },
      version: 1,
    );
    print("created DB $database");
    return database;
  }

  static Future<Database> initEvents() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'students_manager.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE events(eventId INTEGER PRIMARY KEY, eventName TEXT, location TEXT)');
        // Call the function to insert pre-made values
        _insertValuesEvents(db);

      },
      version: 1,
    );
    print("created DB $database");
    return database;
  }

  //test functions for before online stuff
  static void _insertValuesCourses(Database db) {
    // Create a list of pre-made values (courses) to insert into the database
    final List<Course> preMadeCourses = [
      Course(
        id: 1,
        weekday: "Monday",
        courseName: "Mathematics",
        profName: "Dr. Smith",
        roomNum: "101",
        startTime: "9:00 AM",
        endTime: "10:30 AM",
      ),
      Course(
        id: 2,
        weekday: "Wednesday",
        courseName: "Computer Science",
        profName: "Prof. Johnson",
        roomNum: "202",
        startTime: "2:00 PM",
        endTime: "4:00 PM",
      ),
      // Add more values as needed
    ];

    // Insert the pre-made courses into the database
    for (final course in preMadeCourses) {
      db.insert(
        'courses',
        course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  static void _insertValuesEvents(Database db) {
    // Create a list of pre-made values (events) to insert into the database
    final List<Event> preMadeEvents = [
      Event(
        eventId: 1,
        eventName: "Conference",
        location: "Convention Center",
      ),
      Event(
        eventId: 2,
        eventName: "Concert",
        location: "Stadium",
      ),
      // Add more values as needed
    ];

    // Insert the pre-made events into the database
    for (final event in preMadeEvents) {
      db.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

}
