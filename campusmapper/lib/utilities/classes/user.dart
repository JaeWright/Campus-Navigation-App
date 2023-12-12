class User {
  String? id;
  String? email;
  String? firstname;
  String? lastname;
  User({this.id, this.email, this.firstname, this.lastname});

  User.fromMap(Map map) {
    id = map['id'];
    email = map['email'];
    firstname = map['firstname'];
    lastname = map['lastname'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname
    };
  }
}
