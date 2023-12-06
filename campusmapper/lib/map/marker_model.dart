/*
Author: Luca Lotito
Firebase access class, handles reading from the firebase database and translating the data to the mapper (and in the future, other classes)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map_marker.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MarkerModel {
  //Returns the requested marker type
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<MapMarker>> getMarkersofType(List<String> type) async {
    List<MapMarker> results = [];
    for (int i = 0; i < type.length; i++) {
      //Firebase database is stared as a collection in a collection. Made it less messier if the document was the University, instead of the individual marker
      await _firestore
          .collection("MapMarker")
          .doc('OntarioTech')
          .collection(type[i])
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          results.add(MapMarker(
              id: docSnapshot.id,
              type: type[i],
              location: LatLng(docSnapshot["location"].latitude,
                  docSnapshot["location"].longitude),
              icon: Icon(
                  IconData(docSnapshot["icon"], fontFamily: 'MaterialIcons')),
              additionalInfo: docSnapshot["addInfo"]));
        }
      });
    }
    return results;
  }

  //Curently unused. Was originally intended to get all the marker types (As marker types are stored as individual collections within the OntarioTech document),
  //but decided it was easier to keep them as part of the app constants class
  Future<List<String>> getAllCategoryTypes() async {
    List<String> categories = [];
    await _firestore.collection("MapMarker").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        categories.add(docSnapshot.id);
      }
    });
    return categories;
  }
}
