/*
Author: Jaelen Wright - 100790481
This page manages the Course and CoursesModel classes, which hold the course data
and interact with the courses database respectively
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../utilities/user.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/models/sqflite/scheduler_database_helper.dart';
import 'dart:async';

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

  //clear local database when the user logs out
  Future clearLocal() async {
    databaseFactory.deleteDatabase(
        "/data/data/com.example.campusmapper/databases/courses_manager.db");
  }

  //cloud database interactions

  //get course data from cloud database
  Future getAllCoursesCloud() async {
    //get user id
    List<User> user = await UserModel().getUser();
    //returns list of user's course(s) in database
    List results = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user[0].id)
        .collection("Courses")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        results.add(Course(
            id: docSnapshot.id,
            weekday: docSnapshot["weekday"],
            courseName: docSnapshot["courseName"],
            profName: docSnapshot["profName"],
            roomNum: docSnapshot["roomNum"],
            endTime: docSnapshot["endTime"],
            startTime: docSnapshot["startTime"]));
      }
    });

    return results;
  }
}
