/*
Author: Luca Lotito
This class handles the logic for displaying the map along with placing markers on the map.
This class also deals with locating the user, as well as requesting user permission
*/
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/models/constants/map_constants.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/utilities/map_marker.dart';
import 'package:campusmapper/widgets/drop_menu.dart';
import 'package:campusmapper/models/openrouteservice/directions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';

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
  //Sets the button style used throughout the map
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
      backgroundColor: Colors.cyan);
  //Creates geolocation settings
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5, //Updates when a change in this many meters is detected
  );
  late StreamSubscription<Position> positionStream;
  //DirectionManager deals with User current location, the the location of the place they want to go to
  Directions directionManager = Directions(
      initialPosition: MapConstants.mapCenter,
      locationPosition: MapConstants.mapCenter);
  //Handles marker display
  MapMarker displayValues = MapMarker(
      id: '0',
      type: 'Null',
      location: MapConstants.mapCenter,
      icon: const Icon(Icons.abc),
      additionalInfo: 'Null');
  //Array for choosing what markers to place on the map
  List<bool?> trueFalseArray =
      List<bool>.filled(MapConstants.categories.length, false);
  List<String> mapMarkers = [];
  List? selectedIndices = [];
  List<LatLng> routing = [];
//If the bottom card is displayed
  bool bottomCard = false;
  bool canFindLocation = false;

  @override
  void initState() {
    //Setting up the direction manager database
    directionManager = Directions(
        initialPosition: MapConstants.mapCenter,
        locationPosition: MapConstants.mapCenter,
        database: _database);
    //Timer triggers a location check every 10 seconds
    //If an initial value is being passed in,
    //Preforms async setups
    setUp();

    super.initState();
  }

  //Removes timer. Does not work properly on first timer dispose however
  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Updates whenever the user selects more markers
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
                            //Popup box displaying sourcing for the map and routing
                            builder: (context) => AlertDialog(
                                  title: const Text('Map Information'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                child: const Text(
                                                    'Map data © Mapbox'),
                                                onPressed: () => launchUrl(
                                                      Uri.parse(
                                                          'https://www.mapbox.com/about/maps/'),
                                                    ))),
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
                                                    'Improve this map'),
                                                onPressed: () => launchUrl(
                                                      Uri.parse(
                                                          'https://www.mapbox.com/map-feedback/#/-74.5/40/10'),
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
                                'https://api.mapbox.com/styles/v1/luc-lot/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                            additionalOptions: const {
                              'mapStyleId': MapConstants.mapBoxStyleId,
                              'accessToken': MapConstants.mapBoxAccessToken,
                            },
                          ),
                          //Marker handler logic
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
                              //Since the app is a campus mapper, can't really map directions if you're off campus
                              //(And saving us some questionable API calls)
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
                      //Button to clear routes on the map
                      Visibility(
                          visible: routing.isNotEmpty,
                          child: Positioned(
                            left: MediaQuery.of(context).size.width * .03,
                            top: MediaQuery.of(context).size.height * .05,
                            child: Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: FloatingActionButton(
                                    heroTag: 'hero_exit',
                                    onPressed: () {
                                      setState(() {
                                        routing = [];
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.close,
                                        color: Colors.cyan))),
                          )),
                      //Map control buttons
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
                bottomSheet: Visibility(
                    visible: bottomCard,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              leading: displayValues.icon,
                              //Translate category allows for some backend names to be translated into more user friendly versions
                              title: Text(MapConstants.translateCategory(
                                  displayValues.type)),
                              subtitle: Text(
                                  (displayValues.additionalInfo != 'None')
                                      ? displayValues.additionalInfo
                                      : '')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                style: style,
                                child: const Text('Navigate'),
                                onPressed: () {
                                  setMap("foot-walking");
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

  //List with all the markers
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
                  //List of all campus markers. Found through the MapConstants
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

  //Checks if within range of the map area
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

  //Warns the user that they are off campus
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

  //Checks location service, then updates position
  //If location services are disabled, the position will always be the center of Campus
  Future<bool> setUpLocation() async {
    await checkLocationService();
    return true;
  }

  //Creates routing information
  void setMap(String moveType) async {
    //Preforms a check for location before getting path, os it isn't a default to center
    //The reason why this exisst is so when a location is precalled, the location is set from your current location to their
    //If the one time call wasn't there, the route call would be made with the center of Polonsky as the coordinate instead

    await getPosition();
    if (isOnCampus()) {
      List<LatLng> returned = await directionManager.getDirections(moveType);
      setState(() {
        routing = returned;
      });
    } else {
      displayOffCampus();
    }
  }

  void setUp() async {
    //Getting location permissions allowed.
    await checkLocationService();
    //Starts location finder widget
    startListener();
    if (widget.findLocation != const LatLng(0.0, 0.0)) {
      mapMarkers = [widget.type];
      directionManager.setItemPos(widget.findLocation);
      setMap("wheelchair");
    }
  }

  //Updates position on the map

  Future<LatLng> getPosition() async {
    //Default location
    LatLng curLoc = MapConstants.mapCenter;
    if (canFindLocation) {
      Position pos = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.high);
      curLoc = LatLng(pos.latitude, pos.longitude);
    }
    return curLoc;
  }

  //Checker to see if location services are enabled
  //Triggers upon reopening the map for the second time if not allowed,
  //as the deniedForever permission appears to be bugged and only properly updates after
  //being denied twice
  Future<bool> checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      canFindLocation = false;
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          canFindLocation = false;
        } else {
          canFindLocation = true;
        }
      } else {
        canFindLocation = true;
      }
      if (permission == LocationPermission.deniedForever) {
        canFindLocation = false;
      }
    }
    return canFindLocation;
  }

  //Creates a stream for geolocating
  //I wanted to put it in it's own class, but didn't know how to get map_screen to get the sream updates
  void startListener() {
    if (canFindLocation) {
      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position != null) {
          setState(() {
            directionManager
                .setInitPos(LatLng(position.latitude, position.longitude));
          });
        }
      });
    }
  }
}
