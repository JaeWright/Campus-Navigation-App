/*
Author: Jaelen Wright - 100790481
This page allows the user to view their events in a calendar view
Used https://dipeshgoswami.medium.com/table-calendar-3-0-0-null-safety-818ba8d4c45e for help
 */

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../screens/scheduler_handler.dart';

class CalendarPage extends StatefulWidget {
  final List<EventTile>? events;
  final bool displayEvents;

  const CalendarPage(
      {super.key, required this.events, required this.displayEvents});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  //preset calendar values
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late LinkedHashMap<DateTime, List> toDisplay;

  @override
  void initState() {
    super.initState();
    toDisplay = convertToDynamicMap(groupEventsByDay(widget.events!));
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    //convert list of events into a LinkedHashMap
    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(toDisplay);

    //gets the events per each day
    List getEventForDay(DateTime day) {
      return events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: getEventForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
            ),
            const SizedBox(height: 20),
            //shows a List View of the events on selected day
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: _selectedDay != null
                    ? getEventForDay(_selectedDay!)
                        .map((event) => ListTile(
                              title: Text(event.eventName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${event.location} at ${event.time}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ))
                        .toList()
                    : [],
              ),
            )
            // Add other widgets or functionalities as needed below the calendar
          ],
        ),
      ),
    );
  }

  //creates a list that maps each event and sorts them by matching dates
  //Uses chatGPT for this
  Map<DateTime, List<EventTile>> groupEventsByDay(List<EventTile> events) {
    Map<DateTime, List<EventTile>> groupedEvents = {};

    for (EventTile event in events) {
      DateTime? eventDate = event.date;
      if (eventDate != null) {
        if (!groupedEvents.containsKey(eventDate)) {
          groupedEvents[eventDate] = [];
        }
        groupedEvents[eventDate]!.add(event);
      }
    }

    return groupedEvents;
  }

  //converts the mapped lists into a LinkedHashMap
  //used ChatGPT for this
  LinkedHashMap<DateTime, List<dynamic>> convertToDynamicMap(
      Map<DateTime, List<EventTile>> map) {
    LinkedHashMap<DateTime, List<dynamic>> convertedMap = LinkedHashMap();

    map.forEach((key, value) {
      convertedMap[key] = List<dynamic>.from(value);
    });

    return convertedMap;
  }
}
