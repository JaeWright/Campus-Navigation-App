import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'scheduler_database_helper.dart';
import 'dart:async';


class Event{
  int? eventId;
  String? eventName;
  String? location;
  String? weekday;
  String? time;

  Event({required this.eventId, required this.eventName, required this.location, required this.weekday, required this.time});

  Event.fromMap(Map map){
    eventId = map["eventId"];
    eventName = map["eventName"];
    location = map["location"];
    weekday = map["weekday"];
    time = map["time"];
  }

  Map<String,Object> toMap(){
    return{
      'id' : eventId!,
      'eventName': eventName!,
      'location': location!,
      'weekday' : weekday!,
      'time' : time!,
    };
  }

  String toString(){
    return "id: $eventId, Name: $eventName, location: $location, weekday: $weekday, time: $time";
  }
}

class EventsModel{

  Future getAllEvents() async{
    //returns list of grades in database
    final db = await DBUtils.initEvents();
    final List maps = await db.query('events');

    List results = [];

    if (maps.length>0){
      for (int i=0; i<maps.length; i++){
        results.add(Event.fromMap(maps[i]));
      }
    }

    return results;
  }

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
      where: 'eventId = ?',
      whereArgs: [event.eventId],
    );

  }

  Future<int> deleteEvent (int id) async{
    final db = await DBUtils.initEvents();
    return db.delete(
      'events',
      where: 'eventId = ?',
      whereArgs: [id],
    );

  }

}