import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'courses.dart';
import 'scheduler_handler.dart';

class CalendarPage extends StatefulWidget {
  final List<EventTile>? events;
  final bool displayEvents;

  CalendarPage({required this.events, required this.displayEvents});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late LinkedHashMap<DateTime,List> toDisplay;

  @override
  void initState(){
    super.initState();
    toDisplay = convertToDynamicMap(groupEventsByDay(widget.events!));
  }

  List getEventForDay(DateTime day) {
    return toDisplay[day] ?? [];
  }
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
  @override
  Widget build(BuildContext context) {


    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(toDisplay);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible : false,
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
              onPageChanged: (focusedDay){
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
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
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(10.0),
              child: ListView(
              shrinkWrap: true,
              children: _selectedDay != null ? getEventForDay(_selectedDay!)
                  .map((event) => ListTile(
                title:
                Text(event.eventName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle:
                Text('${event.location} at ${event.time}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              ))
                  .toList() : [],
            ),
            )
            // Add other widgets or functionalities as needed below the calendar
          ],
        ),
      ),
    );
  }
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
  LinkedHashMap<DateTime, List<dynamic>> convertToDynamicMap(Map<DateTime, List<EventTile>> map) {
    LinkedHashMap<DateTime, List<dynamic>> convertedMap = LinkedHashMap();

    map.forEach((key, value) {
      convertedMap[key] = List<dynamic>.from(value);
    });

    return convertedMap;
  }
}