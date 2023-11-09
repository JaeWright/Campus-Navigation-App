import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/AppConstants.dart';
import 'package:campusmapper/MarkerModel.dart';
import 'package:campusmapper/MapMarker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key});

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMapScreen> {
  final _database = MarkerModel();
  final mapController = MapController();
  List<bool?> trueFalseArray =
      List<bool>.filled(AppConstants.categories.length, false);
  List<String> mapMarkers = [];
  List? selectedIndices = [];
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
                body: SlidingUpPanel(
              minHeight: 45,
              panelBuilder: (ScrollController sc) => _scrollingList(sc),
              collapsed: Column(
                children: [
                  Container(
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  Text("Search")
                ],
              ),
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
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
                                    onTap: () {},
                                    child: Icon(Icons.mark_chat_read_outlined)))
                      ])
                    ],
                  ),
                ],
              ),
            ));
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
