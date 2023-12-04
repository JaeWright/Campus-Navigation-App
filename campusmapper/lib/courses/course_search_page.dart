import 'package:flutter/material.dart';
import 'package:campusmapper/scheduler/courses.dart';
import 'course_details_page.dart';
import 'package:campusmapper/scheduler/courses.dart';
import 'package:provider/provider.dart';
import 'schedule_provider.dart';

class CourseSearchPage extends StatefulWidget {
  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Course> courses = [
    Course(
      id: 1,
      weekday: 'Mon',
      courseName: 'CSCI 101 - Introduction to Computer Science',
      profName: 'Dr. Smith',
      roomNum: '123',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
    ),
    Course(
      id: 2,
      weekday: 'Tue',
      courseName: 'CSCI 201 - Data Structures',
      profName: 'Dr. Johnson',
      roomNum: '456',
      startTime: '2:00 PM',
      endTime: '3:30 PM',
    ),
    Course(
      id: 3,
      weekday: 'Wed',
      courseName: 'CSCI 301 - Algorithms',
      profName: 'Dr. Williams',
      roomNum: '789',
      startTime: '9:00 AM',
      endTime: '10:30 AM',
    ),
    Course(
      id: 4,
      weekday: 'Thu',
      courseName: 'ENGL 101 - Introduction to Literature',
      profName: 'Prof. Davis',
      roomNum: '101',
      startTime: '11:00 AM',
      endTime: '12:30 PM',
    ),
    Course(
      id: 5,
      weekday: 'Fri',
      courseName: 'MATH 201 - Calculus II',
      profName: 'Prof. Brown',
      roomNum: '202',
      startTime: '1:00 PM',
      endTime: '2:30 PM',
    ),
    Course(
      id: 6,
      weekday: 'Mon',
      courseName: 'BIOL 202 - Genetics',
      profName: 'Dr. Martinez',
      roomNum: '303',
      startTime: '3:00 PM',
      endTime: '4:30 PM',
    ),
    Course(
      id: 7,
      weekday: 'Tue',
      courseName: 'PSYC 101 - Introduction to Psychology',
      profName: 'Dr. Wilson',
      roomNum: '404',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
    ),
    Course(
      id: 8,
      weekday: 'Thu',
      courseName: 'ANTH 201 - Cultural Anthropology',
      profName: 'Dr. Turner',
      roomNum: '2121',
      startTime: '9:00 AM',
      endTime: '10:30 AM',
    ),
    Course(
      id: 9,
      weekday: 'Fri',
      courseName: 'PHYS 202 - Electricity and Magnetism',
      profName: 'Prof. White',
      roomNum: '2222',
      startTime: '1:00 PM',
      endTime: '2:30 PM',
    ),
    Course(
      id: 10,
      weekday: 'Mon',
      courseName: 'PSYCH 201 - Abnormal Psychology',
      profName: 'Dr. Garcia',
      roomNum: '2323',
      startTime: '3:00 PM',
      endTime: '4:30 PM',
    ),
    Course(
      id: 11,
      weekday: 'Tue',
      courseName: 'CHEM 202 - Inorganic Chemistry',
      profName: 'Prof. Clark',
      roomNum: '2424',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
    ),
    Course(
      id: 12,
      weekday: 'Wed',
      courseName: 'BIOL 101 - Introduction to Biology',
      profName: 'Dr. Adams',
      roomNum: '2525',
      startTime: '2:30 PM',
      endTime: '4:00 PM',
    ),
    Course(
      id: 13,
      weekday: 'Thu',
      courseName: 'COMM 101 - Introduction to Communication',
      profName: 'Dr. Turner',
      roomNum: '2626',
      startTime: '9:30 AM',
      endTime: '11:00 AM',
    ),
    Course(
      id: 14,
      weekday: 'Fri',
      courseName: 'HIST 202 - Modern World History',
      profName: 'Prof. White',
      roomNum: '2727',
      startTime: '1:30 PM',
      endTime: '3:00 PM',
    ),
    Course(
      id: 15,
      weekday: 'Mon',
      courseName: 'SOC 201 - Social Theory',
      profName: 'Dr. Garcia',
      roomNum: '2828',
      startTime: '3:30 PM',
      endTime: '5:00 PM',
    ),
    Course(
      id: 16,
      weekday: 'Tue',
      courseName: 'ART 201 - Art History',
      profName: 'Prof. Clark',
      roomNum: '2929',
      startTime: '11:30 AM',
      endTime: '1:00 PM',
    ),
    Course(
      id: 17,
      weekday: 'Wed',
      courseName: 'LANG 101 - French Language',
      profName: 'Dr. Adams',
      roomNum: '3030',
      startTime: '2:00 PM',
      endTime: '3:30 PM',
    ),
    Course(
      id: 18,
      weekday: 'Thu',
      courseName: 'THEA 201 - Advanced Theater Production',
      profName: 'Prof. Turner',
      roomNum: '3131',
      startTime: '9:00 AM',
      endTime: '10:30 AM',
    ),
    Course(
      id: 19,
      weekday: 'Fri',
      courseName: 'PHIL 101 - Introduction to Philosophy',
      profName: 'Prof. White',
      roomNum: '3232',
      startTime: '1:00 PM',
      endTime: '2:30 PM',
    ),
    Course(
      id: 20,
      weekday: 'Mon',
      courseName: 'MUS 201 - Music Theory',
      profName: 'Dr. Garcia',
      roomNum: '3333',
      startTime: '3:00 PM',
      endTime: '4:30 PM',
    ),
    Course(
      id: 21,
      weekday: 'Tue',
      courseName: 'EDUC 101 - Foundations of Education',
      profName: 'Prof. Clark',
      roomNum: '3434',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
    ),
    Course(
      id: 22,
      weekday: 'Wed',
      courseName: 'GEOG 201 - Human Geography',
      profName: 'Dr. Adams',
      roomNum: '3535',
      startTime: '2:30 PM',
      endTime: '4:00 PM',
    ),
    Course(
      id: 23,
      weekday: 'Thu',
      courseName: 'POLI 101 - Introduction to Political Science',
      profName: 'Prof. Turner',
      roomNum: '3636',
      startTime: '9:30 AM',
      endTime: '11:00 AM',
    ),
    Course(
      id: 24,
      weekday: 'Fri',
      courseName: 'PHED 101 - Physical Fitness',
      profName: 'Prof. White',
      roomNum: '3737',
      startTime: '1:30 PM',
      endTime: '3:00 PM',
    ),
    Course(
      id: 25,
      weekday: 'Mon',
      courseName: 'ASTR 201 - Planetary Science',
      profName: 'Dr. Garcia',
      roomNum: '3838',
      startTime: '3:30 PM',
      endTime: '5:00 PM',
    ),
    Course(
      id: 26,
      weekday: 'Tue',
      courseName: 'POLI 202 - International Relations',
      profName: 'Prof. Clark',
      roomNum: '3939',
      startTime: '11:30 AM',
      endTime: '1:00 PM',
    ),
    Course(
      id: 27,
      weekday: 'Wed',
      courseName: 'ART 202 - Modern Art',
      profName: 'Dr. Adams',
      roomNum: '4040',
      startTime: '2:00 PM',
      endTime: '3:30 PM',
    ),
  ];


  List<Course> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    filteredCourses = List.from(courses);
  }

  void filterCourses(String query) {
    setState(() {
      filteredCourses = courses
          .where((course) =>
      course.courseName!.toLowerCase().contains(query.toLowerCase()) ||
          course.profName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void viewCourseDetails(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsPage(course: course),
      ),
    );
  }

  void addToSchedule(Course course) {
    print('Adding ${course.courseName} to schedule');
    // Access the ScheduleProvider
    ScheduleProvider scheduleProvider =
    Provider.of<ScheduleProvider>(context, listen: false);

    // Call the addToSchedule method
    scheduleProvider.addToSchedule(course);

    // Show a SnackBar using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${course.courseName} to schedule.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality if needed
            scheduleProvider.removeFromSchedule(course);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Course Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String>(
                context: context,
                delegate: CourseSearchDelegate(
                  courses: courses,
                  addToScheduleCallback: addToSchedule,
                  scaffoldKey: _scaffoldKey, // Corrected variable name
                ),
              );
              if (query != null && query.isNotEmpty) {
                filterCourses(query);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredCourses[index].courseName ?? 'Unknown Course'),
            subtitle: Text(filteredCourses[index].profName ?? 'Unknown Professor'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    viewCourseDetails(filteredCourses[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addToSchedule(filteredCourses[index]);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseDetailsPage(course: filteredCourses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CourseSearchDelegate extends SearchDelegate<String> {
  final List<Course> courses;
  final Function(Course) addToScheduleCallback;
  final GlobalKey<ScaffoldState> scaffoldKey; // Corrected the parameter name

  CourseSearchDelegate({
    required this.courses,
    required this.addToScheduleCallback,
    required this.scaffoldKey,
  });

  void viewCourseDetails(Course course, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsPage(course: course),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultList = courses
        .where((course) =>
    course.courseName!.toLowerCase().contains(query.toLowerCase()) ||
        course.profName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(resultList[index].courseName ?? 'Unknown Course'),
        subtitle: Text(resultList[index].profName ?? 'Unknown Professor'),
        onTap: () {
          // View course details when a result is tapped
          viewCourseDetails(resultList[index], context);
        },
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Add to schedule when the add button is pressed
            addToScheduleCallback(resultList[index]);
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? courses
        : courses
        .where((course) =>
    course.courseName!.toLowerCase().contains(query.toLowerCase()) ||
        course.profName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].courseName ?? 'Unknown Course'),
        subtitle: Text(suggestionList[index].profName ?? 'Unknown Professor'),
        onTap: () {
          query = suggestionList[index].courseName ?? '';
          showResults(context);
          // View course details when a suggestion is tapped
          viewCourseDetails(suggestionList[index], context);
        },
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Add to schedule when the add button is pressed
            addToScheduleCallback(suggestionList[index]);
          },
        ),
      ),
    );
  }
}
