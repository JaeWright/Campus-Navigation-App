/*
Author: Jaelen Wright - 100790481
This page manages the course schedule page, which displays the user's courses and connects
to the events page
*/
import 'package:flutter/material.dart';
import 'events.dart';
import 'courses.dart';
import 'events_page.dart';
import 'package:campusmapper/main.dart';

//model for course database
final _courses = CoursesModel();

//classes for holding course tile data
class CourseTile {
  int? id;
  String? weekday;
  String? courseName;
  String? profName;
  String? roomNum;
  String? startTime;
  String? endTime;

  CourseTile({
    required this.id,
    required this.weekday,
    required this.courseName,
    required this.profName,
    required this.roomNum,
    required this.endTime,
    required this.startTime,
  });
}

/*class SchedulerHandler extends StatelessWidget {
  const SchedulerHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SchedulerHandlerPage(title: 'Scheduler'),
    );
  }
}*/

class SchedulerHandlerPage extends StatefulWidget {
  const SchedulerHandlerPage({Key? key});

  @override
  State<SchedulerHandlerPage> createState() => _SchedulerHandlerPageState();
}

class _SchedulerHandlerPageState extends State<SchedulerHandlerPage> {
  //list of courses to be populated by database
  List<CourseTile> coursesList = [];
  //flag for switch
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadCoursesData();
    });
  }

  //get all the data from local databases
  void loadCoursesData() async {
    if (ModalRoute.of(context)!.isCurrent) {
      List results = await _courses.getAllCourses();
      for (int i = 0; i < results.length; i++) {
        coursesList.add(CourseTile(
          id: results[i].id,
          weekday: results[i].weekday,
          courseName: results[i].courseName,
          profName: results[i].profName,
          roomNum: results[i].roomNum,
          endTime: results[i].endTime,
          startTime: results[i].startTime,
        ));
      }
      setState(() {}); // rebuild when page is loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      //Return to home page
      Navigator.pushReplacementNamed(context, '/home');

      // Return 'false' to prevent the default back button behavior
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        /*
        leading: const Icon(Icons.school, // temporary logo
            size: 30),
            */
        title: const Row(children: [
          Icon(Icons.calendar_month),
          Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text('Scheduler'))
        ]),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Show Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    if (isSwitched) {
                      // Load the events page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventsScheduler(title: 'Scheduler')),
                      );
                    }
                  });
                },
              ),
              const Text(
                'Show Planned Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Display the first row with Monday and Tuesday
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 2; i++)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: getCourseWidgets(getWeekday(i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Display the second row with Wednesday and Thursday
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 2; i < 4; i++)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: getCourseWidgets(getWeekday(i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Display the third row with Friday centered horizontally and NOT vertically
          Center(
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(16),
              height: 200,
              width: 210,
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getWeekday(4),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: getCourseWidgets(getWeekday(4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  //used chatgpt for this function
  List<Widget> getCourseWidgets(String weekday) {
    List<Widget> widgets = [];

    List<CourseTile> filteredCourses =
        coursesList.where((course) => course.weekday == weekday).toList();

    for (int i = 0; i < filteredCourses.length; i++) {
      widgets.addAll([
        Text(
          filteredCourses[i].courseName!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          filteredCourses[i].profName!,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Text(
          filteredCourses[i].roomNum!,
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          '${filteredCourses[i].startTime!} - ${filteredCourses[i].endTime!}',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        if (i <
            filteredCourses.length - 1) // Add dotted line if not the last item
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: 1,
            width: double.infinity,
            color: Colors.black54,
          ),
      ]);
    }

    return widgets;
  }

  String getWeekday(int index) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index];
  }
}
