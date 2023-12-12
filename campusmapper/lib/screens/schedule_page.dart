/*
Author: Brock Davidge - 100787894
This page displays the user's weekly course schedule. It listens for changes
in the ScheduleProvider using the Provider package and organizes courses by day
of the week. The app bar is styled with a lilac-colored background and white
bold text. Each day's schedule is presented in a card format, showing course
names and times. Tapping on a course navigates to the CourseDetailsPage.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusmapper/utilities/courses.dart';
import 'course_details_page.dart';
import '../utilities/schedule_provider.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the ScheduleProvider
    List<Course> courses = Provider.of<ScheduleProvider>(context).courses;

    // Create a map to organize courses by weekday
    Map<String, List<Course>> coursesByDay = {};

    // Organize courses based on the day of the week
    for (Course course in courses) {
      if (!coursesByDay.containsKey(course.weekday!)) {
        coursesByDay[course.weekday!] = [];
      }
      coursesByDay[course.weekday!]!.add(course);
    }

    // Define the order of weekdays
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Scaffold(
      // Inside the SchedulePage widget, update the appBar property
      appBar: AppBar(
        title: const Text(
          'Weekly Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple[700], // Lilac-colored background
        leading: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: weekdays.map((day) {
            List<Course>? coursesForDay = coursesByDay[day];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$day:',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (coursesForDay != null && coursesForDay.isNotEmpty)
                      ...coursesForDay.map(
                        (course) => ListTile(
                          title: Text(course.courseName!),
                          subtitle:
                              Text('${course.startTime!} - ${course.endTime!}'),
                          onTap: () {
                            // Handle tapping on a course to show details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailsPage(course: course),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Text('No courses for $day'),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
