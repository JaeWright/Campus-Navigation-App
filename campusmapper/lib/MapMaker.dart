import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/MapMarker.dart';
import 'package:campusmapper/MarkerModel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key});

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMapScreen> {
  final mapBoxStyleId = 'clomgqnky006x01qo1d507vrk';
  final mapBoxAccessToken =
      'pk.eyJ1IjoibHVjLWxvdCIsImEiOiJjbG9tNHpzdnkwam92MnFuMzgwNm5mNDRzIn0.45jDosysBYOtEdWZj39kTg';
  final _database = MarkerModel();
  final mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _database.getAllCategoryTypes(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
                body: SlidingUpPanel(
              panelBuilder: (ScrollController sc) =>
                  _scrollingList(sc, snapshot.data),
              collapsed: Container(child: Text("Search")),
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
                    ],
                  ),
                ],
              ),
            ));
          }
        });
  }

  Widget _scrollingList(ScrollController sc, List<String>? categories) {
    int selectedIndex = -1;
    return ListView.builder(
      controller: sc,
      itemCount: categories!.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              setState(() {
                if (selectedIndex != index) {
                  selectedIndex = index;
                } else {
                  selectedIndex = -1;
                }
              });
            },
            child: Container(
                child: ListTile(
              title: Text(categories[index]),
            )));
      },
    );
  }
}
