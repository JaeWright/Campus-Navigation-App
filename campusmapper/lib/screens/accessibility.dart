/*
Luca Lotito
Samiur Rahman -100824221

Display page listing accessible entrances to buildings on campus.
Allows the user to get directions to these locations
*/
import 'package:flutter/material.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/utilities/map_marker.dart';
import 'package:campusmapper/screens/map_screen.dart';
import 'package:campusmapper/widgets/drop_menu.dart';

class AccessibilityDirectoryPage extends StatelessWidget {
  final FirebaseModel _database = FirebaseModel();

  AccessibilityDirectoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    //Uses the map marker, as it has all the required information in it's calss
    return FutureBuilder<List<MapMarker>>(
        future: _database.getMarkersofType(["Accessible"]),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapMarker>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Blank screen while loading
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
                actions: const <Widget>[Dropdown()],
              ),
              //Lists all the buildings
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

  //Menu that when clicked, takes the user to the map to plot the directions to the location
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
