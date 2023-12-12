/*
Author: Brock Davidge - 100787894
This class manages the user's course schedule. It provides methods to add,
remove, and get courses from the schedule. It uses ChangeNotifier to notify
listeners about any changes in the schedule.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/utilities/classes/courses.dart'; // Import your Course model
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/models/sqflite/scheduler_database_helper.dart';

class ScheduleProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  final FirebaseModel _database = FirebaseModel();

  final CoursesModel _localdatabase = CoursesModel();

  void addToSchedule(Course course) {
    _database.insertCourseCloud(course.id, course.weekday, course.courseName,
        course.profName, course.roomNum, course.endTime, course.startTime);
    _localdatabase.insertLocal(course);
    _courses.add(course);
    notifyListeners();
  }

  void removeFromSchedule(Course course) {
    _database.deleteCourseCloud(course.id);
    _localdatabase.deleteCourseLocal(course.id);
    _courses.remove(course);
    notifyListeners();
  }

  bool isCourseInSchedule(Course course) {
    // Check if the course is in the schedule list
    return _courses.contains(course);
  }
}
