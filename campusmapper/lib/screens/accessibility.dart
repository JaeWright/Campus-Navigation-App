/*
Samiur Rahman -100824221

This page manages the Accessibility Directory for campus buildings, displaying 
details about accessible entrances and departments. 
*/
import 'package:flutter/material.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/utilities/map_marker.dart';
import 'package:campusmapper/screens/map_screen.dart';

class AccessibilityDirectoryPage extends StatelessWidget {
  final FirebaseModel _database = FirebaseModel();

  AccessibilityDirectoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapMarker>>(
        future: _database.getMarkersofType(["Accessible"]),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapMarker>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
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
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  MapMarker building = snapshot.data![index];
                  return ListTile(
                    title: Text(building.additionalInfo),
                    onTap: () {
                      _showAccessibilityOptions(context, building);
                    },
                  );
                },
              ),
            );
          }
        });
  }

  void _showAccessibilityOptions(BuildContext context, MapMarker entrance) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Directions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListMapScreen(
                        findLocation: entrance.location,
                        type: "Accessible",
                      ),
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
