/*
Author: Jaelen Wright - 100790481
This page manages the Course and CoursesModel classes, which hold the course data
and interact with the courses database respectively
*/
import 'package:cloud_firestore/cloud_firestore.dart';

//class to hold course data
class Course {
  String? id;
  String? weekday;
  String? courseName;
  String? profName;
  String? roomNum;
  String? startTime;
  String? endTime;
  DocumentReference? reference;

  Course(
      {required this.id,
      required this.weekday,
      required this.courseName,
      required this.profName,
      required this.roomNum,
      required this.endTime,
      required this.startTime,
      this.reference});

  //convert from map for sql
  Course.fromMapLocal(Map map) {
    id = map["id"];
    weekday = map["weekday"];
    courseName = map["courseName"];
    profName = map["profName"];
    roomNum = map["roomNum"];
    startTime = map["startTime"];
    endTime = map["endTime"];
  }
  //convert from map for cloud
  Course.fromMapCloud(Map map, {this.reference}) {
    id = reference?.id;
    weekday = map["weekday"];
    courseName = map["courseName"];
    profName = map["profName"];
    roomNum = map["roomNum"];
    startTime = map["startTime"];
    endTime = map["endTime"];
  }
  //convert to map for sql
  Map<String, Object> toMapLocal() {
    return {
      'id': id!,
      'weekday': weekday!,
      'courseName': courseName!,
      'profName': profName!,
      'roomNum': roomNum!,
      'startTime': startTime!,
      'endTime': endTime!
    };
  }

  @override
  String toString() {
    return "id: $id, weekday: $weekday, course: $courseName, prof: $profName, roomNum: $roomNum, start: $startTime, end: $endTime ";
  }
}

//class for interactions between course class and local database

