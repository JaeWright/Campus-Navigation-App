import 'package:flutter/material.dart';
import 'package:campusmapper/scheduler/courses.dart';// Import your Course model

class CourseDetailsPage extends StatelessWidget {
  final Course course; // Replace Course with your actual model

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course Name: ${course.courseName}'),
            Text('Professor: ${course.profName}'),
            Text('Room: ${course.roomNum}'),
            Text('Day: ${course.weekday}'),
            Text('Time: ${course.startTime} - ${course.endTime}'),
            // Add other details as needed
          ],
        ),
      ),
    );
  }
}
