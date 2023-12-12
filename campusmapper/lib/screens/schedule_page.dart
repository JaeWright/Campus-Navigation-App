/*
Author: Brock Davidge - 100787894
This page displays the user's weekly course schedule. It gets courses from the 
scheduler_handler organizes courses by day
of the week. The app bar is styled with a lilac-colored background and white
bold text. Each day's schedule is presented in a card format, showing course
names and times. Tapping on a course navigates to the CourseDetailsPage.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/utilities/classes/courses.dart';
import 'course_details_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.courses});
  final List<Course> courses;
  @override
  State<SchedulePage> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    // Create a map to organize courses by weekday
    Map<String, List<Course>> coursesByDay = {};

    // Organize courses based on the day of the week
    for (Course course in widget.courses) {
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
                          onTap: () async {
                            // Handle tapping on a course to show details

                            bool check = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailsPage(course: course),
                              ),
                            );
                            if (check) {
                              setState(() {
                                widget.courses.remove(course);
                              });
                            }
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
