/*
Author: Jaelen Wright - 100790481
This page allows the user to add an event to their account
*/

import 'package:flutter/material.dart';
import '../utilities/date_conversions.dart';

class EventAddPage extends StatefulWidget {
  const EventAddPage({super.key});

  @override
  EventAddPageState createState() => EventAddPageState();
}

class EventAddPageState extends State<EventAddPage> {
  //controllers for to-be-added event data
  late TextEditingController eventNameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late String weekday;
  late DateTime date;
  //form key
  final _eventAddKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    locationController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
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
        // Return to scheduler if back button is pressed
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
          title: const Text('Add Event'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _eventAddKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //enter event name
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
                  //enter location
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
                  //select date
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
                            initialDate:
                                setInitialDate(), //sets initial date to monday if user is accessing on a weekend
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2025),
                            selectableDayPredicate: (DateTime date) {
                              //user cannot pick saturday or sunday
                              return date.weekday != DateTime.saturday &&
                                  date.weekday != DateTime.sunday;
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              date = picked;
                              weekday = convertWeekday(picked);
                              dateController.text =
                                  "${convertWeekday(picked)} on ${picked.year}-${picked.month}-${picked.day}";
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
                  //select time
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
                              timeController.text = picked.format(context);
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
                      if (_eventAddKey.currentState!.validate()) {
                        Future.delayed(const Duration(milliseconds: 750), () {
                          //pass new data back to scheduler
                          var newData = {
                            'eventName': eventNameController.text,
                            'location': locationController.text,
                            'weekday': weekday,
                            'date': date,
                            'time': timeController.text,
                          };
                          Navigator.pop(context, newData);
                        });
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
