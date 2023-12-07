import overpy
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore import GeoPoint
from google.cloud.firestore import ArrayUnion


cred = credentials.Certificate("../../key/campusmapper-5bbf5-firebase-adminsdk-muovl-5c9f8afc4a.json")
app = firebase_admin.initialize_app(cred)

db = firestore.client()
api = overpy.Overpass()
# fetch all ways and nodes
result = api.query("""
    area[name="Durham College"];
    way(area)["highway"];
    (._;>;);
    out body;
    """)

for way in result.ways:
    for i in range(len(way.nodes)):
        location = GeoPoint(way.nodes[i].lat, way.nodes[i].lon)
        adjacent = []
        if i!=0:
            adjacent.append(way.nodes[i-1].id)
        if i!=len(way.nodes)-1:
            adjacent.append(way.nodes[i+1].id)
        data = {"location": location, "connected": ArrayUnion(adjacent)}
        db.collection("Nodes").document(str(way.nodes[i].id)).set(data, merge=True)



