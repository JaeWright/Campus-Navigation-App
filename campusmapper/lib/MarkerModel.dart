import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusmapper/MapMarker.dart';
import 'package:latlong2/latlong.dart';

class MarkerModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<MapMarker>> getMarkersofType(List<String> type) async {
    print(type);
    List<MapMarker> results = [];
    for (int i = 0; i < type.length; i++) {
      await _firestore
          .collection("MapMarker")
          .doc('OntarioTech')
          .collection(type[i])
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          results.add(MapMarker(
              id: docSnapshot.id,
              location: LatLng(docSnapshot["position"].latitude,
                  docSnapshot["position"].longitude),
              additionalInfo: docSnapshot["addInfo"]));
        }
      });
    }
    print(results);
    return results;
  }

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
