import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'AppConstants.dart';
import 'MarkerModel.dart';
import 'MapMarker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key});

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMapScreen> {
  final _database = MarkerModel();
  final mapController = MapController();
  final panelController = PanelController();
  List<bool?> trueFalseArray =
      List<bool>.filled(AppConstants.categories.length, false);
  List<String> mapMarkers = [];
  List? selectedIndices = [];
  bool bottomCard = false;
  MapMarker displayValues = MapMarker(
      id: '0',
      location: const LatLng(43.943754, -78.8960396),
      icon: const Icon(Icons.abc),
      additionalInfo: 'Null');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapMarker>>(
        future: _database.getMarkersofType(mapMarkers),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapMarker>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Campus Map"),
                  backgroundColor: Colors.red,
                ),
                body: SlidingUpPanel(
                  controller: panelController,
                  minHeight: 42,
                  panelBuilder: (ScrollController sc) => _scrollingList(sc),
                  collapsed: Column(
                    children: [
                      Container(
                        child: const Icon(Icons.keyboard_arrow_up),
                      ),
                      Text("Add Icons to Map")
                    ],
                  ),
                  body: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                            onTap: (tapPosition, point) {
                              panelController.show();
                              setState(() {
                                bottomCard = false;
                              });
                            },
                            initialCenter: const LatLng(43.943754, -78.8960396),
                            initialZoom: 18,
                            cameraConstraint: CameraConstraint.contain(
                                bounds: LatLngBounds(
                                    const LatLng(43.952142, -78.902931),
                                    const LatLng(43.940242, -78.889625)))),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                            /*'https://api.mapbox.com/styles/v1/luc-lot/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                        additionalOptions: {
                          'mapStyleId': mapBoxStyleId,
                          'accessToken': mapBoxAccessToken,
                        },*/
                          ),
                          MarkerLayer(markers: [
                            if (snapshot.data != null)
                              for (int i = 0; i < snapshot.data!.length; i++)
                                Marker(
                                    point: snapshot.data![i].location,
                                    child: GestureDetector(
                                        onTap: () {
                                          panelController.hide();
                                          setState(() {
                                            bottomCard = true;
                                            displayValues = MapMarker(
                                                id: snapshot.data![i].id,
                                                location:
                                                    snapshot.data![i].location,
                                                icon: snapshot.data![i].icon,
                                                additionalInfo: snapshot
                                                    .data![i].additionalInfo);
                                          });
                                        },
                                        child: snapshot.data![i].icon))
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                bottomSheet: Visibility(
                    visible: bottomCard,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: displayValues.icon,
                            title: Text(displayValues.id),
                            subtitle: Text(displayValues.additionalInfo),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Navigate'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  setState(() {
                                    bottomCard = false;
                                    panelController.show();
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    )));
          }
        });
  }

  Widget _scrollingList(ScrollController sc) {
    return Scaffold(
        body: Column(children: [
      Flexible(
          child: ListView.builder(
              controller: sc,
              itemCount: AppConstants.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                    title: Text(AppConstants.categories[index]),
                    value: trueFalseArray[index],
                    onChanged: (bool? value) {
                      if (value == true) {
                        selectedIndices!.add(index);
                      } else {
                        selectedIndices!.remove(index);
                      }
                      setState(() {
                        trueFalseArray[index] = value;
                      });
                    });
              })),
      Flexible(
          child: TextButton(
              onPressed: () {
                mapMarkers = [];
                setState(() {
                  for (int i = 0; i < selectedIndices!.length; i++) {
                    mapMarkers
                        .add(AppConstants.categories[selectedIndices![i]]);
                  }
                });
              },
              child: Text('Apply Changes')))
    ]));
  }
}
