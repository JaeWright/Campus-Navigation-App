import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/MapMarker.dart';
import 'package:campusmapper/MarkerModel.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapMarker>>(
        future: _database.getMarkersofType('Washroom'),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapMarker>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print('Data');
            print(snapshot.data);
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    options: const MapOptions(
                        initialCenter: LatLng(43.943754, -78.8960396),
                        initialZoom: 18),
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
            );
          }
        });
  }
}
