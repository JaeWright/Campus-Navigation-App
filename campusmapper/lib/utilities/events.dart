/*
Author: Jaelen Wright - 100790481
This page manages the Event and EventsModel classes, which hold the event data
and interact with the events database respectively
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../utilities/user.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/models/sqflite/scheduler_database_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';

//class to hold event data
class Event {
  String? id;
  String? eventName;
  String? location;
  String? weekday;
  String? time;
  DateTime? date;
  DocumentReference? reference;

  Event(
      {required this.id,
      required this.eventName,
      required this.location,
      required this.weekday,
      required this.time,
      required this.date,
      this.reference});

  //convert from map for sql
  Event.fromMapLocal(Map map) {
    id = map["id"];
    eventName = map["eventName"];
    location = map["location"];
    weekday = map["weekday"];
    time = map["time"];
    date = DateTime.parse(map["date"]);
  }
  //convert from map for cloud
  Event.fromMapCloud(Map map, {this.reference}) {
    id = reference?.id;
    eventName = map["eventName"];
    location = map["location"];
    weekday = map["weekday"];
    time = map["time"];
    date = DateTime.parse(map["date"]);
  }
  //convert to map for sql
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
  Future clearLocal() async{
    databaseFactory.deleteDatabase("/data/data/com.example.campusmapper/databases/events_manager.db");
  }

  //cloud database interactions

  //get event data from cloud database
  Future getAllEventsCloud() async {
    //get user id
    List<User> user = await UserModel().getUser();
    List results = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user[0].id)
        .collection("Events")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        results.add(Event(
          id: docSnapshot.id,
          weekday: docSnapshot["weekday"],
          eventName: docSnapshot["eventName"],
          location: docSnapshot["location"],
          time: docSnapshot["time"],
          date: DateTime.parse(docSnapshot["date"].split(" – ").first),
        ));
      }
    });
    return results;
  }

  //insert new event data to cloud database
  Future<String> insertEventCloud(String weekday, String eventName,
      String location, String time, DateTime date) async {
    //get user id
    List<User> user = await UserModel().getUser();
    //adds new event to online database
    DocumentReference ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Events")
        .add(<String, dynamic>{
      'weekday': weekday,
      'eventName': eventName,
      'location': location,
      'time': time,
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(date)
    });
    //returns new id
    return ref.id;
  }

  //update event data in cloud database
  Future updateEventCloud(Event event) async {
    //get user id
    List<User> user = await UserModel().getUser();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
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

  //delete event data from cloud database
  Future deleteEventCloud(String id) async {
    //get user id
    List<User> user = await UserModel().getUser();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Events")
        .doc(id)
        .delete()
        .then((doc) => print("Document deleted"),
            onError: (e) => print("Error deleting document $e"));
  }


}
