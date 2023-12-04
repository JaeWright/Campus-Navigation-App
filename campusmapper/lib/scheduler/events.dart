/*
Author: Jaelen Wright - 100790481
This page manages the Event and EventsModel classes, which hold the event data
and interact with the events database respectively
*/
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'scheduler_database_helper.dart';
import 'dart:async';
import 'dateConversions.dart';

//class to hold event data
class Event {
  int? id;
  String? eventName;
  String? location;
  String? weekday;
  String? time;
  DateTime? date; // New field for the date

  Event({
    required this.id,
    required this.eventName,
    required this.location,
    required this.weekday,
    required this.time,
    required this.date, // Include the new date field in the constructor
  });

  Event.fromMap(Map map) {
    id = map["id"];
    eventName = map["eventName"];
    location = map["location"];
    weekday = map["weekday"];
    time = map["time"];
    date = DateTime.parse(map["date"]);
  }

  Map<String, Object> toMap() {
    return {
      'id': id!,
      'eventName': eventName!,
      'location': location!,
      'weekday': weekday!,
      'time': time!,
      'date': date!.toIso8601String(), // Include 'date' in the returned map
    };
  }

  String toString() {
    return "id: $id, Name: $eventName, location: $location, weekday: $weekday, time: $time, date: $date";
  }
}


//class for interaction between event class and local database
class EventsModel{

  Future getAllEvents() async{
    //returns list of grades in database
    final db = await DBUtils.initEvents();
    final List maps = await db.query('events');
//
    List results = [];

    if (maps.length>0){
      for (int i=0; i<maps.length; i++){
        results.add(Event.fromMap(maps[i]));
      }
    }

    return results;
  }
  //functions below are functional but not currently implemented in the current page
  Future<int> insertEvent (Event event) async {
    //adds new grade to database
    final db = await DBUtils.initEvents();
    return db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }
  Future<int> updateEvent (Event event) async{
    final db = await DBUtils.initEvents();
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );

  }

  Future<int> deleteEvent (int id) async{
    final db = await DBUtils.initEvents();
    return db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

  }

}