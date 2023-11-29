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
area[name="Ontario Tech University"];
node(area)["highway"="bus_stop"];
(._;>;);
out body;
area[name="Durham College"];
node(area)["highway"="bus_stop"];
(._;>;);
out body;
    """)
print(len(result.nodes))
for i in range(len(result.nodes)):
    location = GeoPoint(result.nodes[i].lat, result.nodes[i].lon)
    name = result.nodes[i].tags.get('name')
    data = {"location": location, "icon": 0xe1d5, "addInfo":name}
    print(data)
    db.collection("MapMarker").document("OntarioTech").collection("Bus").document(str(result.nodes[i].id)).set(data)



