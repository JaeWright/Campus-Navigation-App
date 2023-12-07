import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities/dateConversions.dart';

class EventAddPage extends StatefulWidget {
  @override
  _EventAddPageState createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  late TextEditingController eventNameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late String weekday;
  late DateTime date;

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
        // Return to scheduler
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
          title: Text('Add Event'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: setInitialDate(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2025),
                        selectableDayPredicate: (DateTime date) {
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
              ),
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(const Duration(milliseconds: 750), () {
                    var updatedData = {
                      'eventName': eventNameController.text,
                      'location': locationController.text,
                      'weekday': weekday,
                      'date': date,
                      'time': timeController.text,
                    };
                    Navigator.pop(context, updatedData);
                  });
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
