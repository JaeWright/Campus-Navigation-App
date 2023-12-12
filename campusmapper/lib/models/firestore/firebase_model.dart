/*
Author: Luca Lotito
Author: Jaelen Wright - 100790481
Firebase access class, handles reading from the firebase database and translating the data to the mapper (and in the future, other classes)
Handles reading MapMarkers, Courses and Events
*/
import 'package:campusmapper/utilities/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusmapper/utilities/classes/map_marker.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/utilities/classes/events.dart';
import 'package:campusmapper/utilities/classes/courses.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FirebaseModel {
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

  Future<List<Building>> getBuildings() async {
    List<Building> results = [];
    //Firebase database is stared as a collection in a collection. Made it less messier if the document was the University, instead of the individual marker

    await _firestore
        .collection("MapMarker")
        .doc('OntarioTech')
        .collection('Buildings')
        .orderBy("name")
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        results.add(Building(
            accessibleEntrance: LatLng(docSnapshot["entrance"].latitude,
                docSnapshot["entrance"].longitude),
            buildingName: docSnapshot["name"],
            owner: docSnapshot["owner"],
            buildingUse: docSnapshot["use"]));
      }
    });
    return results;
  }

  //Checks to see if a user exists
  Future<User> login(String email, String password) async {
    User user =
        User(id: 'None', email: 'None', firstname: 'None', lastname: 'None');
    await _firestore.collection("users").get().then((querySnapshot) {
      //If a user exixsts for that combonation email and password, return the id
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot['Email'] == email &&
            docSnapshot["Password"] == password) {
          user = User(
              id: docSnapshot.id,
              email: docSnapshot["Email"],
              firstname: docSnapshot["FirstName"],
              lastname: docSnapshot["LastName"]);
          return user;
        }
      }
    });
    return user;
  }

  //Creates a new user. The checks if the user can be created were done earlier
  Future<String> register(String email, String password, String firstname,
      String lastname, String sid) async {
    String id = "None";
    final data = {
      "Email": email,
      "FirstName": firstname,
      "LastName": lastname,
      "Password": password,
      "StudentID": sid
    };
    await _firestore
        .collection("users")
        .add(data)
        .then((docSnapshot) => id = docSnapshot.id);
    return id;
  }

  Future getAllEventsCloud() async {
    //get user id
    List<User> user = await UserModel().getUser();
    List results = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user[0].id)
        .collection("Events")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        results.add(Event(
          id: docSnapshot.id,
          weekday: docSnapshot["weekday"],
          eventName: docSnapshot["eventName"],
          location: docSnapshot["location"],
          time: docSnapshot["time"],
          date: DateTime.parse(docSnapshot["date"].split(" – ").first),
        ));
      }
    });
    return results;
  }

  //insert new event data to cloud database
  Future<String> insertEventCloud(String weekday, String eventName,
      String location, String time, DateTime date) async {
    //get user id
    List<User> user = await UserModel().getUser();
    //adds new event to online database
    DocumentReference ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Events")
        .add(<String, dynamic>{
      'weekday': weekday,
      'eventName': eventName,
      'location': location,
      'time': time,
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(date)
    });
    //returns new id
    return ref.id;
  }

  //update event data in cloud database
  Future updateEventCloud(Event event) async {
    //get user id
    List<User> user = await UserModel().getUser();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Events")
        .doc(event.id)
        .update({
      'weekday': event.weekday,
      'eventName': event.eventName,
      'location': event.location,
      'time': event.time,
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(event.date!)
    });
  }

  //delete event data from cloud database
  Future deleteEventCloud(String id) async {
    //get user id
    List<User> user = await UserModel().getUser();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Events")
        .doc(id)
        .delete()
        .then((doc) => print("Document deleted"),
            onError: (e) => print("Error deleting document $e"));
  }

  Future getAllCoursesCloud() async {
    //get user id
    List<User> user = await UserModel().getUser();
    //returns list of user's course(s) in database
    List results = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user[0].id)
        .collection("Courses")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        results.add(Course(
            id: docSnapshot.id,
            weekday: docSnapshot["weekday"],
            courseName: docSnapshot["courseName"],
            profName: docSnapshot["profName"],
            roomNum: docSnapshot["roomNum"],
            endTime: docSnapshot["endTime"],
            startTime: docSnapshot["startTime"]));
      }
    });

    return results;
  }

  //insert course into cloud database
  Future<String?> insertCourseCloud(
      String? id,
      String? weekday,
      String? courseName,
      String? profName,
      String? roomNum,
      String? endTime,
      String? startTime) async {
    //get user id
    List<User> user = await UserModel().getUser();
    //adds new event to online database
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Courses")
        .doc(id)
        .set(<String, dynamic>{
      'weekday': weekday,
      'courseName': courseName,
      'profName': profName,
      'roomNum': roomNum,
      'endTime': endTime,
      'startTime': startTime
    });
    //returns id
    return id;
  }

  //delete event data from cloud database
  Future deleteCourseCloud(String? id) async {
    //get user id
    List<User> user = await UserModel().getUser();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("Courses")
        .doc(id)
        .delete()
        .then((doc) => print("Document deleted"),
            onError: (e) => print("Error deleting document $e"));
  }
}
