/*
Author: Jaelen Wright - 100790481
This page manages the Event and EventsModel classes, which hold the event data
and interact with the events database respectively
*/
import 'package:cloud_firestore/cloud_firestore.dart';

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
