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
import 'package:latlong2/latlong.dart';

class AccessibilityDirectoryPage extends StatelessWidget {
  final FirebaseModel _database = FirebaseModel();

  AccessibilityDirectoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    //Uses the map marker, as it has all the required information in it's calss
    return FutureBuilder<List<Building>>(
        future: _database.getBuildings(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Building>> snapshot) {
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
                  Building building = snapshot.data![index];
                  return ExpansionTile(
                      title: Text(building.buildingName),
                      subtitle: Text(building.buildingUse),
                      children: <Widget>[
                        ListTile(
                          title: Text("Building Owner: ${building.owner}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.directions),
                          title: const Text("Find Accessible Entrance"),
                          onTap: () {
                            _showAccessibilityOptions(
                                context, building.accessibleEntrance);
                          },
                        )
                      ]);
                },
              ),
            );
          }
        });
  }

  //Menu that when clicked, takes the user to the map to plot the directions to the location
  void _showAccessibilityOptions(BuildContext context, LatLng entrance) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMapScreen(
            findLocation: entrance,
            type: "Accessible",
          ),
        ));
  }
}
