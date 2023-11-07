import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusmapper/MapMarker.dart';

class MarkerModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<MapMarker>> getMarkersofType(String type) async {
    List<MapMarker> result = [];
    await _firestore
        .collection("MapMarker")
        .doc('OntarioTech')
        .collection(type)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        print(docSnapshot.id);
        print(docSnapshot["position"].latitude);
        print(docSnapshot["position"].longitude);
        print(docSnapshot["addInfo"]);
      }
    });
    print(result);
    return result;
  }
}
