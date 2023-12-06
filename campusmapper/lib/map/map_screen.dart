/*
Author: Luca Lotito
This class handles the logic for displaying the map along with placing markers on the map.
In the final submission, will handle pathfinding and Geolocation logic
*/
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_constants.dart';
import 'marker_model.dart';
import 'map_marker.dart';
import 'directions.dart';
import 'geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key, required this.findLocation});
  //Variable used for passing in Resturant locatations to the map to be generated first
  final LatLng findLocation;
  @override
  ListMapState createState() => ListMapState();
}

class ListMapState extends State<ListMapScreen> {
  final MarkerModel _database = MarkerModel();
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();
  final Geolocation geoLocatorController = Geolocation();
  Directions directionManager = Directions(
      initialPosition: MapConstants.mapCenter,
      locationPosition: MapConstants.mapCenter);
  MapMarker displayValues = MapMarker(
      id: '0',
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
      mapMarkers = ["Food"];
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
                                    TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ));
                      },
                    )
                  ],
                ),
                /*
                floatingActionButton: Row(children: [
                  FloatingActionButton(
                      onPressed: () {}, child: const Icon(Icons.add)),
                  FloatingActionButton(
                      onPressed: () {}, child: const Icon(Icons.remove)),
                  FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.center_focus_strong))
                ]),*/
                //Handler for (as the name states) the sliding up panel at the bottom of the screen
                body: SlidingUpPanel(
                  controller: panelController,
                  minHeight: MediaQuery.of(context).size.height * .065,
                  parallaxEnabled: true,
                  parallaxOffset: 0.5,
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
                            maxZoom: 20,
                            minZoom: 16,
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
                                                  location: snapshot
                                                      .data![i].location,
                                                  icon: snapshot.data![i].icon,
                                                  additionalInfo: snapshot
                                                      .data![i].additionalInfo);
                                            });
                                          },
                                          child: snapshot.data![i].icon)),
                              if ((directionManager.initialPosition.latitude <
                                      MapConstants.mapUpperCorner.latitude &&
                                  directionManager.initialPosition.latitude >
                                      MapConstants.mapLowerCorner.latitude))
                                if ((directionManager
                                            .initialPosition.longitude <
                                        MapConstants.mapUpperCorner.longitude &&
                                    directionManager.initialPosition.longitude >
                                        MapConstants.mapLowerCorner.longitude))
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
                            title: Text(displayValues.id),
                            subtitle: Text(displayValues.additionalInfo),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Navigate'),
                                //For the full release, pressing this will display the route a user needs to take using pathways in the campus
                                //As Geolocation and OSM pathway information is not implemented yet, the UI is the only thing that is implemented right now
                                onPressed: () {
                                  setMap();
                                },
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
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 35),
            child: Column(children: [
              Flexible(
                  //List of all curently implemented campus markers. Found through the MapConstants
                  child: ListView.builder(
                      controller: sc,
                      itemCount: MapConstants.categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                            title: Text(MapConstants.categories[index]),
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
                            mapMarkers.add(
                                MapConstants.categories[selectedIndices![i]]);
                          }
                        });
                        panelController.close();
                      },
                      child: const Text('Apply Changes')))
            ])));
  }

  List<LatLng> initRoute() {
    return [];
  }

  void setMap() async {
    await updatePosition();
    List<LatLng> returned = await directionManager.getDirections();
    setState(() {
      routing = returned;
    });
  }

  Future<bool> updatePosition() async {
    LatLng newPos = await geoLocatorController.getPosition();
    setState(() {
      directionManager.setInitPos(newPos);
    });
    return true;
  }
}
