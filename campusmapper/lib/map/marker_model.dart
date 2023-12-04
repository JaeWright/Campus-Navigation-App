/*
Author: Luca Lotito
Firebase access class, handles reading from the firebase database and translating the data to the mapper (and in the future, other classes)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
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

/*
Unused Code
This was intended for use to find routing, but then I discovered there was an API online that did what I wanted with less errors
Kept in as an example of my struggles



  Future<String> getNearestNodes(LatLng pos) async {
    double lat = pos.latitude;
    double lon = pos.longitude;
    double change = 0.0003;
    double closest = 1000;
    double dist;
    String id = "11179092000";
    await _firestore
        .collection("Nodes")
        .where("location", isGreaterThan: GeoPoint(lat - change, lon - change))
        .where("location", isLessThan: GeoPoint(lat + change, lon + change))
        .orderBy("location")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if ((docSnapshot["location"].longitude > (lon - change)) &&
            (docSnapshot["location"].longitude < (lon + change))) {
          dist = sqrt(pow(lat - docSnapshot["location"].latitude, 2) +
              pow(lon - docSnapshot["location"].longitude, 2));
          if (dist < closest) {
            closest = dist;
            id = docSnapshot.id;
          }
        }
      }
    });
    return id;
  }

  Future<List<LatLng>> getPath(
      String startNode, String endNode, LatLng startPos, LatLng endPos) async {
    String curStartNode = startNode;
    String lastNode = startNode;
    String curEndNode = endNode;

    List<LatLng> startArr = [];
    bool cancel = false;
    Future.delayed(Duration(seconds: 5), () {
      cancel = true;
    });
    while (curStartNode != curEndNode && cancel == false) {
      print(curStartNode + ' ' + curEndNode);
      print('New Start');
      (curStartNode, lastNode, startPos) = await getShortDist(
          curStartNode, lastNode, startPos, endPos, curEndNode);
      startArr.add(endPos);
      if (curEndNode == curStartNode) {
        break;
      }
      /*
      print('New End');
      (curEndNode, endPos) =
          await getShortDist(curEndNode, endPos, startPos, curStartNode);
      endArr.add(startPos);
      */
    }
    if (cancel == true) {
      print('Operation exceeded time');
    }
    return startArr;
  }

  Future<(String, String, LatLng)> getShortDist(String curNode, String lastNode,
      LatLng startPos, LatLng endPos, String curClosestId) async {
    double closest = 1000;
    double furthest = 0;
    double distfromStart;
    double distToLoc;
    double curClosestLat = endPos.latitude;
    double curClosestLon = endPos.longitude;
    await _firestore
        .collection("Nodes")
        .doc(curNode)
        .get()
        .then((querySnapshot) async {
      for (var point in querySnapshot['connected']) {
        if (point.toString() != lastNode) {
          if (querySnapshot['connected'].length > 0) {
            await _firestore
                .collection("Nodes")
                .doc(point.toString())
                .get()
                .then((querySubCheck) {
              distfromStart = sqrt(pow(
                      startPos.latitude - querySubCheck["location"].latitude,
                      2) +
                  pow(startPos.longitude - querySubCheck["location"].longitude,
                      2));
              distToLoc = sqrt(pow(
                      endPos.latitude - querySubCheck["location"].latitude, 2) +
                  pow(endPos.longitude - querySubCheck["location"].longitude,
                      2));
              if (distToLoc < 0.0001) {
                curClosestId = curClosestId;
                curClosestLat = endPos.latitude;
                curClosestLon = endPos.longitude;
              } else if ((distToLoc < closest) &&
                  ((closest - distToLoc).abs() > 0.0001)) {
                closest = distToLoc;
                furthest = distfromStart;
                curClosestId = querySubCheck.id;
                curClosestLat = querySubCheck["location"].latitude;
                curClosestLon = querySubCheck["location"].longitude;
              } else if (distfromStart > furthest) {
                closest = distToLoc;
                furthest = distfromStart;
                curClosestId = querySubCheck.id;
                curClosestLat = querySubCheck["location"].latitude;
                curClosestLon = querySubCheck["location"].longitude;
              }
            });
          } else {
            curClosestId = curClosestId;
            curClosestLat = endPos.latitude;
            curClosestLon = endPos.longitude;
          }
        }
      }
    });
    return (curClosestId, curNode, LatLng(curClosestLat, curClosestLon));
  }
  */
}
