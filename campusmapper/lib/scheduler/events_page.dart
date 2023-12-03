/*
Author: Jaelen Wright - 100790481
This page manages the events page, where the user's scheduled events are displayed and
connects to the course scheduler page
*/

import 'package:flutter/material.dart';
import 'events.dart';
import 'scheduler_handler.dart';
import 'eventEditPage.dart';

void main() {
  runApp(const MyApp());
}

//model for events database
final _events = EventsModel();

//variable to track IDs for events when inserted (to be implemented)
var nextEventId = 0;

//class to hold event tile data
class EventTile {
  int? id;
  String? eventName;
  String? location;
  String? weekday;
  String? time;

  EventTile({
    required this.id,
    required this.eventName,
    required this.location,
    required this.weekday,
    required this.time,
  });

  Event toEvent(){
    return Event(
      id: id,
      eventName: eventName,
      location: location,
      weekday: weekday,
      time: time,
    );
  }
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
      home: const EventsScheduler(title: 'Events Scheduler'),
    );
  }
}

class EventsScheduler extends StatefulWidget {
  const EventsScheduler({Key? key,required this.title, String? eventName, String? location,  String? weekday, String? time, int? id});

  final String title;

  @override
  State<EventsScheduler> createState() => _EventsSchedulerState();
}

class _EventsSchedulerState extends State<EventsScheduler> {
  //holds list of events to be populated by database
  List<EventTile> eventsList = [];
  //boolean check for switch toggles
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadEventsData();
    });
  }

  //loads data from local database
  void loadEventsData() async {
    if (ModalRoute.of(context)!.isCurrent) {
      List results = await _events.getAllEvents();
      print(results);

      for (int i = 0; i < results.length; i++) {
        eventsList.add(EventTile(
            id: results[i].id,
            eventName: results[i].eventName,
            location: results[i].location,
            weekday: results[i].weekday,
            time: results[i].time));
      }
      nextEventId = eventsList.length;
      setState(() {}); // rebuilds everytime page is loaded
    }
  }

  //functions to interact with event maker (not implemented yet)
  //function to add event to database
  Future<void> _addEvent(String eventName, String location, String weekday, String time) async {
    // Add the new data to the gradesList
    setState(() {
      final newEvent = EventTile(
          id: nextEventId,
          eventName: eventName,
          location: location,
          weekday: weekday,
          time: time);
      eventsList.add(newEvent);
    });

    // Insert the new data into the database
    _events
        .insertEvent(Event(
            id: nextEventId,
            eventName: eventName,
            location: location,
            weekday: weekday,
            time: time))
        .then((insertedId) {
      if (insertedId != null) {
        print('Data inserted with ID: $insertedId');
      } else {
        print('Failed to insert data');
      }
    });
    nextEventId++;
  }

  void _confirmDeleteEvent(EventTile eventToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Do you want to delete ${eventToDelete.eventName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(eventToDelete.id!); // Perform delete operation
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  //function to remove event from database
  Future<void> _deleteEvent(int id) async {
    setState(() {
      eventsList.removeWhere((event) => event.id == id);
    });
    int deleted = await _events.deleteEvent(id!);
    print("index $deleted was deleted");
  }

  //Used ChatGPT +L
  void _editEvent(EventTile event) async {
    final initialId = event.id;
    final initialEventName = event.eventName;
    final initialLocation = event.location;
    final initialWeekday = event.weekday;
    final initialTime = event.time;

    var updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          id: initialId,
          eventName: initialEventName,
          location: initialLocation,
          weekday: initialWeekday,
          time: initialTime,
        ),
      ),
    );

    if (updatedData != null) {
      final updatedEvent = Event(
        id: initialId,
        eventName: updatedData['eventName'],
        location: updatedData['location'],
        weekday: updatedData['weekday'],
        time: updatedData['time'],
      );

      setState(() {
        final index = eventsList.indexWhere((eventTile) => eventTile.id == initialId);
        if (index != -1) {
          eventsList[index] = EventTile(
            id: updatedEvent.id,
            eventName: updatedEvent.eventName,
            location: updatedEvent.location,
            weekday: updatedEvent.weekday,
            time: updatedEvent.time,
          );
        }
      });

      // Update the event in the database
      int updated = await _events.updateEvent(updatedEvent);
      print("updated: $updated");

    }
  }


  //used chatgpt for this function
  List<Widget> getEventWidgets(String weekday) {
    List<Widget> widgets = [];

    List<int> indexes = eventsList.asMap().entries.where((entry) => entry.value.weekday == weekday).map((entry) => entry.key).toList();


    for (int i = 0; i < indexes.length; i++) {
      widgets.addAll([
        GestureDetector(
          onTap: () {
            _editEvent(eventsList[indexes[i]]);
          },
          onLongPress: (){
            _confirmDeleteEvent(eventsList[indexes[i]]);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                eventsList[indexes[i]].eventName!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                eventsList[indexes[i]].location!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                eventsList[indexes[i]].time!,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              if (i < indexes.length - 1)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  width: double.infinity,
                  color: Colors.black54,
                ),
            ],
          ),
        ),
      ]);
    }

    return widgets;
  }

  String getWeekday(int index) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          iconSize: 25,
        ),
        title: const Row(
          children: [
            Text("Events Scheduler"),
          ],
        ),
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
                    if (!isSwitched) {
                      // Load the events page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SchedulerHandlerPage()),
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
          //Monday and Tuesday row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 2; i++)
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: getEventWidgets(getWeekday(i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          //Wednesday and Thursday Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 2; i < 4; i++)
                Flexible(
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
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: getEventWidgets(getWeekday(i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          //Friday row
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
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: getEventWidgets(getWeekday(4)),
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
}
