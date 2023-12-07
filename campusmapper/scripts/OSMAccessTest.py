import overpy
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore import GeoPoint
from google.cloud.firestore_v1.base_query import FieldFilter

cred = credentials.Certificate("../../key/campusmapper-5bbf5-firebase-adminsdk-muovl-5c9f8afc4a.json")
app = firebase_admin.initialize_app(cred)

db = firestore.client()
api = overpy.Overpass()
# fetch all ways and nodes

nodes = db.collection("Nodes")
query = nodes.where(filter=FieldFilter("location", ">", GeoPoint(43.9440,-78.898))).where(filter=FieldFilter("location", "<", GeoPoint(43.9445,-78.870))).order_by(
    "location"
)
results = query.stream()
reduced = [item for item in results if (item.to_dict().get('location').longitude < -78.898 and item.to_dict().get('location').longitude > -78.899)]
for r in reduced:
    print(r.to_dict().get('location').latitude, ' ', r.to_dict().get('location').longitude)
    