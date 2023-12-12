/*
Author: Jaelen Wright - 100790481
This page allows the user to edit an event that is on their account
*/

import 'package:flutter/material.dart';
import '../utilities/dateConversions.dart';

class EventEditPage extends StatefulWidget {
  final String? eventName;
  final String? location;
  final String? weekday;
  final String? time;
  final DateTime? date;

  const EventEditPage({
    super.key,
    required this.eventName,
    required this.location,
    required this.weekday,
    required this.time,
    required this.date,
  });

  @override
  EventEditPageState createState() => EventEditPageState();
}

class EventEditPageState extends State<EventEditPage> {
  //controllers for to-be-edited event data
  late TextEditingController eventNameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late String weekday;
  late DateTime date;
  //form key
  final _eventEditKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController(text: widget.eventName);
    locationController = TextEditingController(text: widget.location);
    dateController = TextEditingController(
        text:
            "${widget.weekday} on ${widget.date?.year}-${widget.date?.month}-${widget.date?.day}");
    timeController = TextEditingController(text: widget.time);
    weekday = widget.weekday!;
    date = widget.date!;
  }

  @override
  void dispose() {
    eventNameController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //Return to scheduler if user presses the back button
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(milliseconds: 750), () {
            Navigator.popUntil(context, ModalRoute.withName('/scheduler'));
          });

          // Return 'false' to prevent the default back button behavior
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text('Edit Event'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _eventEditKey,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //edit event name
                  TextFormField(
                    controller: eventNameController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  //edit location
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  //edit date
                  TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.date!,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2025),
                            selectableDayPredicate: (DateTime date) {
                              // Disable Saturday (day 6) and Sunday (day 7)
                              return date.weekday != DateTime.saturday &&
                                  date.weekday != DateTime.sunday;
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              date = picked;
                              weekday = convertWeekday(picked);
                              dateController.text =
                              "${convertWeekday(picked)} on ${picked.year}-${picked.month}-${picked.day}"; // format in weekday - date
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date (press the calendar icon)';
                      }
                      return null;
                    },
                  ),
                  //edit time
                  TextFormField(
                    readOnly: true,
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              timeController.text = picked
                                  .format(context); // Format as per requirement
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time (press the clock icon)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      //hide keyboard before navigation (causes a renderflex error if not)
                      FocusScope.of(context).unfocus();
                      //delay for keyboard to hide before navigation
                      if (_eventEditKey.currentState!.validate()) {
                      Future.delayed(const Duration(milliseconds: 750), () {
                        //pass updated data back to scheduler
                        var updatedData = {
                          'eventName': eventNameController.text,
                          'location': locationController.text,
                          'weekday': weekday,
                          'date': date,
                          'time': timeController.text,
                        };
                        Navigator.pop(context, updatedData);
                        });
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            )
          ),
        ));
  }
}
