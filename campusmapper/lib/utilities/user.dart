class User {
  int? id;
  String? email;
  String? firstname;
  String? lastname;
  String? sid;
  User({this.id, this.email, this.firstname, this.lastname, this.sid});

  User.fromMap(Map map) {
    id = map['id'];
    email = map['email'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    sid = map['sid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'sid': sid
    };
  }
}
