import 'package:flutter/material.dart';

class InformationCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for class schedule
    final classSchedule = [
      {'time': '10:00 AM', 'room': 'A101', 'lecturer': 'Dr. Smith'},
      // Add more schedule entries
    ];

    // Placeholder for campus resources
    final campusResources = [
      {'name': 'Library', 'location': 'Building B'},
      // Add more resources
    ];

    // Placeholder for emergency contacts
    final emergencyContacts = [
      {'service': 'Campus Security', 'number': '123-456-7890'},
      // Add more contacts
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Information Center'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Timetable'),
              Tab(text: 'Resources'),
              Tab(text: 'Emergency'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Timetable Tab
            ListView.builder(
              itemCount: classSchedule.length,
              itemBuilder: (context, index) {
                var schedule = classSchedule[index];
                return ListTile(
                  title: Text('${schedule['time']} - ${schedule['room']}'),
                  subtitle: Text('Lecturer: ${schedule['lecturer']}'),
                );
              },
            ),
            // Resources Tab
            // Resources Tab
            ListView.builder(
              itemCount: campusResources.length,
              itemBuilder: (context, index) {
                var resource = campusResources[index];
                return ListTile(
                  title: Text(resource['name'] ?? 'No name provided'),
                  subtitle: Text('Location: ${resource['location']}'),
                );
              },
            ),

// Emergency Contacts Tab
            ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                var contact = emergencyContacts[index];
                return ListTile(
                  title: Text(contact['service'] ?? 'No service provided'),
                  trailing: Text(contact['number'] ?? 'No number provided'),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}