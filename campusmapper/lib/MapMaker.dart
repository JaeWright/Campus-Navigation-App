import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ListMapScreen extends StatefulWidget {
  const ListMapScreen({super.key});

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMapScreen> {
  final mapBoxStyleId = 'clomgqnky006x01qo1d507vrk';
  final mapBoxAccessToken =
      'pk.eyJ1IjoibHVjLWxvdCIsImEiOiJjbG9tNHpzdnkwam92MnFuMzgwNm5mNDRzIn0.45jDosysBYOtEdWZj39kTg';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
                initialCenter: LatLng(43.943754, -78.8960396), initialZoom: 18),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/luc-lot/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'mapStyleId': mapBoxStyleId,
                  'accessToken': mapBoxAccessToken,
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
