/*
Author: Luca Lotito
This class handles the logic for displaying the map along with placing markers on the map.
In the final submission, will handle pathfinding and Geolocation logic
*/
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/models/constants/map_constants.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/utilities/map_marker.dart';
import 'package:campusmapper/widgets/drop_menu.dart';
import 'package:campusmapper/models/geolocation/geolocation.dart';
import 'package:campusmapper/models/openrouteservice/directions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen(
      {Key? key, required this.findLocation, required this.type})
      : super(key: key);
  //Variable used for passing in Resturant locatations to the map to be generated first
  final LatLng findLocation;
  final String type;
  @override
  ListMapState createState() => ListMapState();
}

class ListMapState extends State<ListMapScreen> {
  final FirebaseModel _database = FirebaseModel();
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();
  final Geolocation geoLocatorController = Geolocation();
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
      backgroundColor: Colors.cyan);

  Directions directionManager = Directions(
      initialPosition: MapConstants.mapCenter,
      locationPosition: MapConstants.mapCenter);
  MapMarker displayValues = MapMarker(
      id: '0',
      type: 'Null',
      location: MapConstants.mapCenter,
      icon: const Icon(Icons.abc),
      additionalInfo: 'Null');
  //If a Resturant location is requested, map it out
  Timer timer = Timer(const Duration(seconds: 120), () {});

  List<bool?> trueFalseArray =
      List<bool>.filled(MapConstants.categories.length, false);
  List<String> mapMarkers = [];
  List? selectedIndices = [];
  List<LatLng> routing = [];

  bool bottomCard = false;

  //Holds the vlaues for any clicked marker on the map

  @override
  void initState() {
    updatePosition();
    directionManager = Directions(
        initialPosition: MapConstants.mapCenter,
        locationPosition: MapConstants.mapCenter,
        database: _database);
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => updatePosition());
    if (widget.findLocation != const LatLng(0.0, 0.0)) {
      mapMarkers = [widget.type];
      directionManager.setItemPos(widget.findLocation);
      setMap();
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
                  title: const Row(children: [
                    Icon(Icons.map),
                    Padding(
                        padding: EdgeInsetsDirectional.only(start: 10),
                        child: Text("Campus Map"))
                  ]),
                  backgroundColor: Colors.cyan,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.question_mark),
                      onPressed: () {
                        showDialog(
                            context: context,
                            //Popup box displaying sourcing for the map
                            builder: (context) => AlertDialog(
                                  title: const Text('Map Information'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                child: const Text(
                                                    'Map data © OpenStreetMap contributors'),
                                                onPressed: () => launchUrl(
                                                      Uri.parse(
                                                          'https://openstreetmap.org/copyright'),
                                                    ))),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                child: const Text(
                                                    '© openrouteservice.org by HeiGIT '),
                                                onPressed: () => launchUrl(
                                                      Uri.parse(
                                                          'https://openrouteservice.org/terms-of-service/'),
                                                    ))),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        style: style,
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ));
                      },
                    ),
                    const Dropdown()
                  ],
                ),
                //Handler for (as the name states) the sliding up panel at the bottom of the screen
                body: SlidingUpPanel(
                  controller: panelController,
                  minHeight: MediaQuery.of(context).size.height * .065,
                  parallaxEnabled: true,
                  parallaxOffset: 0.4,
                  panelBuilder: (ScrollController sc) => _scrollingList(sc),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  collapsed: Container(
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.keyboard_arrow_up),
                          Text("Add Icons to Map")
                        ],
                      )),
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
                            initialCenter: MapConstants.mapCenter,
                            initialZoom: 18,
                            maxZoom: 21,
                            minZoom: 15,
                            cameraConstraint: CameraConstraint.contain(
                                bounds: LatLngBounds(
                                    MapConstants.mapUpperCorner,
                                    MapConstants.mapLowerCorner))),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            //Current tile provider is OSM for testing purpsoes,a s there is no API limit for limited use
                            //Final app will use a free MapBox map. It is not currently used due to the API limit that may be hit during testing
                            userAgentPackageName: 'com.example.app',
                            /*'https://api.mapbox.com/styles/v1/luc-lot/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                        additionalOptions: {
                          'mapStyleId': mapBoxStyleId,
                          'accessToken': mapBoxAccessToken,
                        },*/
                          ),
                          //Marker handler logic
                          //On the current OpenStreetMap tile provider there are static icons already on the map.
                          //Again, this is just for testing purposes, the final release map will not have static icons
                          MarkerLayer(
                            markers: [
                              if (snapshot.data != null)
                                for (int i = 0; i < snapshot.data!.length; i++)
                                  Marker(
                                      point: snapshot.data![i].location,
                                      child: GestureDetector(
                                          onTap: () {
                                            directionManager.setItemPos(
                                                snapshot.data![i].location);
                                            panelController.hide();
                                            setState(() {
                                              bottomCard = true;
                                              displayValues = MapMarker(
                                                  id: snapshot.data![i].id,
                                                  type: snapshot.data![i].type,
                                                  location: snapshot
                                                      .data![i].location,
                                                  icon: snapshot.data![i].icon,
                                                  additionalInfo: snapshot
                                                      .data![i].additionalInfo);
                                            });
                                          },
                                          child: snapshot.data![i].icon)),
                              if (isOnCampus())
                                Marker(
                                    point: directionManager.initialPosition,
                                    child: MapConstants.circle)
                            ],
                          ),
                          PolylineLayer(polylines: [
                            Polyline(
                                points: routing,
                                color: Colors.blue,
                                strokeWidth: 3.0)
                          ])
                        ],
                      ),
                      Positioned(
                          right: MediaQuery.of(context).size.width * .03,
                          bottom: MediaQuery.of(context).size.height * .265,
                          child: Column(children: [
                            Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: FloatingActionButton(
                                    heroTag: 'hero_add',
                                    onPressed: () {
                                      mapController.move(
                                          mapController.camera.center,
                                          mapController.camera.zoom + 1);
                                    },
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.add,
                                        color: Colors.cyan))),
                            Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: FloatingActionButton(
                                    heroTag: 'hero_remove',
                                    onPressed: () {
                                      mapController.move(
                                          mapController.camera.center,
                                          mapController.camera.zoom - 1);
                                    },
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.remove,
                                        color: Colors.cyan))),
                            Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: FloatingActionButton(
                                    heroTag: 'hero_focus',
                                    onPressed: () {
                                      setState(() {
                                        if (isOnCampus()) {
                                          mapController.move(
                                              directionManager.initialPosition,
                                              mapController.camera.zoom);
                                        } else {
                                          displayOffCampus();
                                        }
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.center_focus_strong,
                                        color: Colors.cyan)))
                          ])),
                    ],
                  ),
                ),
                //When a Map Marker is pressed, a card will pop up displaying information about the marker
                //Currently very WIP
                bottomSheet: Visibility(
                    visible: bottomCard,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: displayValues.icon,
                            title: Text(MapConstants.translateCategory(
                                displayValues.type)),
                            subtitle: Text(
                                (displayValues.additionalInfo != 'None')
                                    ? displayValues.additionalInfo
                                    : ''),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                style: style,
                                child: const Text('Navigate'),

                                //For the full release, pressing this will display the route a user needs to take using pathways in the campus
                                //As Geolocation and OSM pathway information is not implemented yet, the UI is the only thing that is implemented right now
                                onPressed: () {
                                  setMap();
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: style,
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
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 35),
            child: Column(children: [
              Flexible(
                  flex: 5,
                  //List of all curently implemented campus markers. Found through the MapConstants
                  child: ListView.builder(
                      controller: sc,
                      itemCount: MapConstants.categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                            title: Text(MapConstants.translateCategory(
                                MapConstants.categories[index])),
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
                  flex: 1,
                  child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        mapMarkers = [];
                        setState(() {
                          for (int i = 0; i < selectedIndices!.length; i++) {
                            mapMarkers.add(
                                MapConstants.categories[selectedIndices![i]]);
                          }
                        });
                        panelController.close();
                      },
                      child: const Text('Apply Changes')))
            ])));
  }

  bool isOnCampus() {
    if ((directionManager.initialPosition.latitude <
            MapConstants.mapUpperCorner.latitude &&
        directionManager.initialPosition.latitude >
            MapConstants.mapLowerCorner.latitude)) {
      if (directionManager.initialPosition.longitude <
              MapConstants.mapUpperCorner.longitude &&
          directionManager.initialPosition.longitude >
              MapConstants.mapLowerCorner.longitude) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> displayOffCampus() {
    return showDialog(
        context: context,
        //Popup box displaying sourcing for the map
        builder: (context) => Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                          'You are currently off campus. To display your current location, please come on campus'),
                      ElevatedButton(
                          style: style,
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  )),
            ));
  }

  void setMap() async {
    await updatePosition();
    if (isOnCampus()) {
      List<LatLng> returned = await directionManager.getDirections();
      setState(() {
        routing = returned;
      });
    } else {
      displayOffCampus();
    }
  }

  Future<bool> updatePosition() async {
    LatLng newPos = await geoLocatorController.getPosition();
    setState(() {
      directionManager.setInitPos(newPos);
    });
    return true;
  }
}
