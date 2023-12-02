import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusmapper/scheduler/courses.dart';
import 'course_details_page.dart';
import 'schedule_provider.dart';

class SchedulePage extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Weekly Schedule'),
        leading: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            // Add any functionality you want when the icon is pressed
            // For example, you can navigate to a specific page or show a dialog
          },
        ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (coursesForDay != null && coursesForDay.isNotEmpty)
                      ...coursesForDay.map(
                            (course) => ListTile(
                          title: Text(course.courseName!),
                          subtitle: Text('${course.startTime!} - ${course.endTime!}'),
                          onTap: () {
                            // Handle tapping on a course to show details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsPage(course: course),
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
