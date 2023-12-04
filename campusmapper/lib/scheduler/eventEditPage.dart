import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dateConversions.dart';

class EventEditPage extends StatefulWidget {
  final int? id;
  final String? eventName;
  final String? location;
  final String? weekday;
  final String? time;
  final DateTime? date;

  EventEditPage({
    required this.id,
    required this.eventName,
    required this.location,
    required this.weekday,
    required this.time,
    required this.date,
  });

  @override
  _EventEditPageState createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  late TextEditingController eventNameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late String weekday;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController(text: widget.eventName);
    locationController = TextEditingController(text: widget.location);
    dateController = TextEditingController(text: "${widget.weekday} - ${widget.date.toString()}");
    timeController = TextEditingController(text: widget.time);
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
      //Return to home page
      Navigator.pushReplacementNamed(context, '/events');

      // Return 'false' to prevent the default back button behavior
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Edit Event'),
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
                      initialDate: widget.date!,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2025),
                      selectableDayPredicate: (DateTime date) {
                        // Disable Saturday (day 6) and Sunday (day 7)
                        return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        date = picked;
                        weekday = convertWeekday(picked);
                        dateController.text = "${convertWeekday(picked)} on ${picked.year}-${picked.month}-${picked.day}"; // format in weekday - date
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
                        timeController.text = picked.format(context); // Format as per requirement
                      });
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var times = convertToText();
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
    )
    );
  }

  convertToText(){

  }
}
