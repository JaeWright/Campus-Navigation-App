/*
Author: Jaelen Wright - 100790481
This page manages the Event and EventsModel classes, which hold the event data
and interact with the events database respectively
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'scheduler_database_helper.dart';
import 'dart:async';
import 'dateConversions.dart';
import 'package:intl/intl.dart';

//class to hold event data
class Event {
  String? id;
  String? eventName;
  String? location;
  String? weekday;
  String? time;
  DateTime? date; // New field for the date
  DocumentReference? reference;

  Event({
    required this.id,
    required this.eventName,
    required this.location,
    required this.weekday,
    required this.time,
    required this.date,
    this.reference
  });

  Event.fromMapLocal(Map map) {
    id = map["id"];
    eventName = map["eventName"];
    location = map["location"];
    weekday = map["weekday"];
    time = map["time"];
    date = DateTime.parse(map["date"]);
  }

  Event.fromMapCloud(Map map,{this.reference}) {
    id = reference?.id;
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

  @override
  String toString() {
    return "id: $id, Name: $eventName, location: $location, weekday: $weekday, time: $time, date: $date";
  }
}


//class for interaction between event class and local database
class EventsModel{

  Future getAllEventsLocal() async{
    //returns list of grades in database
    final db = await DBUtilsSQL.initEvents();
    final List maps = await db.query('events');
//
    List results = [];

    if (maps.isNotEmpty){
      for (int i=0; i<maps.length; i++){
        results.add(Event.fromMapLocal(maps[i]));
      }
    }

    return results;
  }
  //functions below are functional but not currently implemented in the current page
  Future<int> insertEventLocal (Event event) async {
    //adds new grade to database
    final db = await DBUtilsSQL.initEvents();
    return db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }
  Future<int> updateEventLocal (Event event) async{
    final db = await DBUtilsSQL.initEvents();
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );

  }

  Future<int> deleteEventLocal (String id) async{
    final db = await DBUtilsSQL.initEvents();
    return db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

  }

  //cloud database interactions
  Future getAllEventsCloud() async{
    //make it get the user reference later when all connected
    String userRef = "1000";
    List results = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userRef)
        .collection("Events")
        .get()
        .then((querySnapshot){
      for (var docSnapshot in querySnapshot.docs){
        results.add(
            Event(
              id: docSnapshot.id,
              weekday: docSnapshot["weekday"],
              eventName: docSnapshot["eventName"],
              location: docSnapshot["location"],
              time: docSnapshot["time"],
              date: DateTime.parse(docSnapshot["date"].split(" – ").first),
            )
        );
      }
    });
    return results;
  }
  Future<String> insertEventCloud (String weekday, String eventName, String location, String time, DateTime date) async {
    //remove test variable once fully implemented
    String userRef = "1000";
    //adds new event to online database
    DocumentReference ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(userRef)
        .collection("Events")
        .add(<String, dynamic>{
      'weekday': weekday,
      'eventName': eventName,
      'location': location,
      'time': time,
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(date!)
    });
    //returns new id
    return ref.id;
  }
  Future updateEventCloud (Event event) async{
    //remove test variable once fully implemented
    String userRef = "1000";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userRef)
        .collection("Events")
        .doc(event.id)
        .update({
      'weekday': event.weekday,
      'eventName': event.eventName,
      'location': event.location,
      'time': event.time,
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(event.date!)
    });
  }
  Future deleteEventCloud (String id) async{
    //remove test variable once fully implemented
    String userRef = "1000";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userRef)
        .collection("Events")
        .doc(id)
        .delete()
        .then(
            (doc) => print("Document deleted"),
        onError: (e) => print("Error deleting document $e")
    );
  }


}