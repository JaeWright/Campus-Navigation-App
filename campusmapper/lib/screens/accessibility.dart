/*
Author: Brock Davidge - 100787894
This page manages the Accessibility Directory for campus buildings, displaying 
details about accessible entrances and departments. 
*/
import 'package:flutter/material.dart';

class AccessibilityDirectoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buildings = [
      {
        'name': 'Health Centre',
        'accessibleEntrances': ['North entrance', 'South ramp'],
        'departments': [
          {'name': 'StudentUnion', 'info': 'Room 102, Capacity 50'},
          {'name': 'Physical Checkup Centre', 'info': 'Room 105, Capacity 30'},
          {'name': 'Examination Centre', 'info': 'Room 105, Capacity 40'},
        ],
      },
      {
        'name': 'Handicap Parking',
        'accessibleEntrances': ['South entrance', 'South ramp'],
        'departments': [
          {'name': 'Engineering Building', 'info': 'Capacity 100'},
          {'name': 'Science Building', 'info': 'Capacity 60'},
        ],
      },
      {
        'name': 'Seek Refuge',
        'accessibleEntrances': ['East Wing', 'Main Lobby'],
        'departments': [
          {'name': 'Emergency Shelter', 'info': 'Capacity 200'},
          {'name': 'Crisis Management Office', 'info': 'Room 112, Capacity 20'},
          // Add more departments/services
        ],
      },
      {
        'name': 'Advanced Vehicles Services',
        'accessibleEntrances': ['Garage Entry', 'Side Entrance'],
        'departments': [
          {'name': 'Electric Vehicle Charging', 'info': '10 Stations'},
          {'name': 'Vehicle Repair Bay', 'info': 'Bay 3, 4'},
          // Add more departments/services
        ],
      },
      {
        'name': 'Student Union Services',
        'accessibleEntrances': ['North Door', 'South Door'],
        'departments': [
          {'name': 'Student Advocacy Center', 'info': 'Room 204, Capacity 15'},
          {'name': 'Legal Aid Clinic', 'info': 'Room 101, Open Hours 9am-5pm'},
          // Add more departments/services
        ],
      },
      // Add more buildings
    ];

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Row(children: [
        Icon(Icons.accessible),
    Padding(
    padding: EdgeInsetsDirectional.only(start: 10),
    child: Text("Accessibility")),
    ]),
    ),
    body: Container(
    color: Colors.black26, // Setting light pink background color
    child: ListView.builder(
    itemCount: buildings.length,
    itemBuilder: (context, index) {
    var building = buildings[index];
    return ExpansionTile(
    title: Text(building['name']),
    children: building['departments'].map<Widget>((department) {
    return ListTile(
    title: Text(department['name']),
    subtitle: Text(department['info']),
    );
    }).toList(),
    );
    },
    ),
    ),
    );
  }
}