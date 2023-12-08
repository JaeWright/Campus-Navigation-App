/*
Author: Brock Davidge - 100787894
This class manages the user's course schedule. It provides methods to add,
remove, and get courses from the schedule. It uses ChangeNotifier to notify
listeners about any changes in the schedule.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/models/sqflite/courses.dart'; // Import your Course model

class ScheduleProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addToSchedule(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void removeFromSchedule(Course course) {
    _courses.remove(course);
    notifyListeners();
  }

  bool isCourseInSchedule(Course course) {
    // Check if the course is in the schedule list
    return _courses.contains(course);
  }
}
