/*
Author: Brock Davidge - 100787894
This page manages the Accessibility Directory for campus buildings, displaying 
details about accessible entrances and departments. 
*/
import 'package:flutter/material.dart';

class AccessibilityDirectoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This data should ideally come from a backend or a local JSON file
    final buildings = [
      {
        'name': 'UA',
        'accessibleEntrances': ['North entrance', 'South ramp'],
        'departments': [
          {'name': 'Biology', 'room': '102'},
          {'name': 'Chemistry', 'room': '105'},
          // Add more departments
        ],
      },
      {
        'name': 'UB',
        'accessibleEntrances': ['South entrance', 'South ramp'],
        'departments': [
          {'name': 'Arts', 'room': '202'},
          {'name': 'Music', 'room': '201'},
          // Add more departments
        ],
      }
      // Add more buildings
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Row(children: [
          Icon(Icons.accessible),
          Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text("Accessibility"))
        ]),
      ),
      body: ListView.builder(
        itemCount: buildings.length,
        itemBuilder: (context, index) {
          var building = buildings[index];
          return ExpansionTile(
            title: Text(building['name'] as String? ?? 'Unknown Building'),
            children: (building['departments'] as List<dynamic>?)
                    ?.map<Widget>((department) {
                  return ListTile(
                    title: Text(
                        '${department['name']} - Room ${department['room']}'),
                  );
                }).toList() ??
                [ListTile(title: Text('No departments'))],
          );
        },
      ),
    );
  }
}
