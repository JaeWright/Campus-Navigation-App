import 'package:flutter/material.dart';
import 'events.dart';
import 'courses.dart';

void main() {
  runApp(const MyApp());
}

//model for databases
final _events = EventsModel();
final _courses = CoursesModel();

//global ID tracker for events
var nextEventID = 0;

//classes for holding courses and event (TBA) data
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scheduler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CourseTile> coursesList = [];

  @override
  void initState() {
    super.initState();
    loadCoursesData();
  }

  //get all the data from local databases
  void loadCoursesData() async{
    List results = await _courses.getAllCourses();
    for (int i=0; i<results.length;i++){
      print(results[i]);
      coursesList.add(CourseTile(
          id: results[i].id, weekday: results[i].weekday, courseName: results[i].courseName,
          profName: results[i].profName, roomNum: results[i].roomNum, endTime: results[i].endTime,
          startTime: results[i].startTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(
            Icons.school, // temporary logo
            size: 30),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Display the first row with Monday and Tuesday
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 2; i++)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    height: 200, // Adjust the height as needed
                    width: double.infinity, // Match the width of the parent
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    height: 200, // Adjust the height as needed
                    width: double.infinity, // Match the width of the parent
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

          // Display the third row with Friday centered horizontally
          Center(
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(16),
              height: 200, // Adjust the height as needed
              width: 210, // Match the width of the parent
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
    );
  }

  //used chatgpt for this function
  List<Widget> getCourseWidgets(String weekday) {
    List<Widget> widgets = [];

    List<CourseTile> filteredCourses = coursesList
        .where((course) => course.weekday == weekday)
        .toList();

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
        if (i < filteredCourses.length - 1) // Add dotted line if not the last item
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
