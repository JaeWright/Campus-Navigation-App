/*
Author: Jaelen Wright - 100790481
This page initializes the courses and events databases, and adds premade values for local testing
*/
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'courses.dart';
import 'events.dart';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//class for initialization of databases for courses and events
class DBUtilsSQL {
  static Future<Database> initCourses() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'courses_manager.db'),
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

  static Future<Database> initEvents() async {
    final database = await openDatabase(
      path.join(await getDatabasesPath(), 'events_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE events(id TEXT PRIMARY KEY, eventName TEXT, location TEXT, weekday TEXT, time TEXT, date DATETIME)');
        // Call the function to insert pre-made values
        //_insertValuesEvents(db);
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
        id: "1",
        weekday: "Mon",
        courseName: "Mathematics",
        profName: "Dr. Smith",
        roomNum: "101",
        startTime: "9:00 AM",
        endTime: "10:30 AM",
      ),
      Course(
        id: "2",
        weekday: "Tue",
        courseName: "History",
        profName: "Dr. Johnson",
        roomNum: "202",
        startTime: "11:00 AM",
        endTime: "12:30 PM",
      ),
      Course(
        id: "3",
        weekday: "Wed",
        courseName: "Computer Science",
        profName: "Prof. Johnson",
        roomNum: "303",
        startTime: "2:00 PM",
        endTime: "4:00 PM",
      ),
      Course(
        id: "4",
        weekday: "Thu",
        courseName: "Physics",
        profName: "Dr. Davis",
        roomNum: "404",
        startTime: "3:00 PM",
        endTime: "5:00 PM",
      ),
      Course(
        id: "5",
        weekday: "Fri",
        courseName: "Chemistry",
        profName: "Dr. Brown",
        roomNum: "505",
        startTime: "5:00 PM",
        endTime: "6:30 PM",
      ),
      // Add more values as needed
      Course(
        id: "6",
        weekday: "Tue",
        courseName: "Literature",
        profName: "Dr. Wilson",
        roomNum: "606",
        startTime: "1:00 PM",
        endTime: "2:30 PM",
      ),
      Course(
        id: "7",
        weekday: "Fri",
        courseName: "Art",
        profName: "Prof. Miller",
        roomNum: "707",
        startTime: "4:30 PM",
        endTime: "6:00 PM",
      ),
    ];

    // Insert the pre-made courses into the database
    for (final course in preMadeCourses) {
      db.insert(
        'courses',
        course.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static void _insertValuesEvents(Database db) {
    // Create a list of pre-made values (events) to insert into the database
    final List<Event> preMadeEvents = [
      Event(
        id: "1",
        eventName: "Conference",
        location: "Convention Center",
        weekday: "Mon",
        time: "2:00 PM",
        date: DateTime(2023, 12, 11),
      ),
      Event(
        id: "2",
        eventName: "Concert",
        location: "Stadium",
        weekday: "Wed",
        time: "5:35 PM",
        date: DateTime(2023, 12, 13),
      ),
      Event(
        id: "3",
        eventName: "Seminar",
        location: "Meeting Room",
        weekday: "Fri",
        time: "10:00 AM",
        date: DateTime(2023, 12, 15),
      ),
      Event(
        id: "4",
        eventName: "Movie Night",
        location: "Community Hall",
        weekday: "Tue",
        time: "7:00 PM",
        date: DateTime(2023, 12, 12),
      ),
      Event(
        id: "5",
        eventName: "Sports Event",
        location: "Sports Complex",
        weekday: "Thu",
        time: "3:30 PM",
        date: DateTime(2023, 12, 14),
      ),
      Event(
        id: "6",
        eventName: "Exhibition",
        location: "Art Gallery",
        weekday: "Mon",
        time: "1:30 PM",
        date: DateTime(2023, 12, 11),
      ),
      Event(
        id: "7",
        eventName: "Team Building",
        location: "Outdoor Park",
        weekday: "Wed",
        time: "4:45 PM",
        date: DateTime(2023, 12, 13),
      ),
      Event(
        id: "8",
        eventName: "Networking",
        location: "Coffee Shop",
        weekday: "Thu",
        time: "8:15 AM",
        date: DateTime(2023, 12, 14),
      ),
      Event(
        id: "9",
        eventName: "Dinner Party",
        location: "Restaurant",
        weekday: "Fri",
        time: "6:45 PM",
        date: DateTime(2023, 12, 15),
      ),
      Event(
        id: "10",
        eventName: "Tech Talk",
        location: "Tech Hub",
        weekday: "Tue",
        time: "12:15 PM",
        date: DateTime(2023, 12, 12),
      ),
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
