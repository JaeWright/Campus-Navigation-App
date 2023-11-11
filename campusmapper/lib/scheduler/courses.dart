import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'scheduler_database_helper.dart';
import 'dart:async';

class Course{
  int? id;
  String? weekday;
  String? courseName;
  String? profName;
  String? roomNum;
  String? startTime;
  String? endTime;

  Course({required this.id, required this.weekday, required this.courseName, required this.profName, required this.roomNum,
    required this.endTime, required this.startTime});

  Course.fromMap(Map map){
    id = map["id"];
    weekday = map["weekday"];
    courseName = map["courseName"];
    profName= map["profName"];
    roomNum = map["roomNum"];
    startTime = map["startTime"];
    endTime = map["endTime"];
  }

  Map<String,Object> toMap(){
    return{
      'id' : id!,
      'weekday' : weekday!,
      'courseName': courseName!,
      'profName': profName!,
      'roomNum': roomNum!,
      'startTime': startTime!,
      'endTime' : endTime!
    };
  }

  String toString(){
    return "id: $id, weekday: $weekday, course: $courseName, prof: $profName, roomNum: $roomNum, start: $startTime, end: $endTime ";
  }
}

class CoursesModel{

  Future getAllCourses() async{
    //returns list of grades in database
    final db = await DBUtils.initCourses();
    final List maps = await db.query('courses');

    List results = [];

    if (maps.length>0){
      for (int i=0; i<maps.length; i++){
        results.add(Course.fromMap(maps[i]));
      }
    }

    return results;
  }
}