import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore import GeoPoint
from google.cloud.firestore import ArrayUnion

cred = credentials.Certificate("../../key/campusmapper-5bbf5-firebase-adminsdk-muovl-5c9f8afc4a.json")
app = firebase_admin.initialize_app(cred)

db = firestore.client()

location = GeoPoint(48.0, -78.0)
data = {"location": location, "connected": ArrayUnion(['12032320'])}
db.collection("Nodes").document("10019201").set(data, merge=True)
