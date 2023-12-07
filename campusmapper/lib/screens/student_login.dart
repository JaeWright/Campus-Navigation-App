import 'package:flutter/material.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/utilities/user.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  StudentLoginPageState createState() => StudentLoginPageState();
}

class StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loggingIn = true;
  final _formKey = GlobalKey<FormState>();
  final FirebaseModel _fireDatabase = FirebaseModel();
  final UserModel _sqlDatabase = UserModel();
  String email = '';
  String firstName = '';
  String lastName = '';
  String password = '';
  String id = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white38,
          title: Row(children: [
            const Icon(Icons.school),
            Padding(
                padding: const EdgeInsetsDirectional.only(start: 10),
                child: (loggingIn)
                    ? const Text("Student Login")
                    : const Text("Register an Account"))
          ]),
        ),
        body: (loggingIn) ? login() : register());
  }

  Widget login() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be null';
                  } else {
                    email = value;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  } else {
                    password = value;
                  }
                  return null;
                },
              ),
              Row(children: [
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      setState(() {
                        loggingIn = false;
                      });
                    },
                    child: const Text('Sign Up'))
              ]),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              SizedBox(
                width: 175,
                height: 30,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _attemptLogin(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget register() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be null';
                  } else {
                    email = value;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  } else {
                    password = value;
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name cannot be null';
                  } else {
                    firstName = value;
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name cannot be null';
                  } else {
                    lastName = value;
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SID cannot be null';
                  } else {
                    id = value;
                  }
                  return null;
                },
              ),
              Row(children: [
                const Text('Have an account?'),
                TextButton(
                    onPressed: () {
                      loggingIn = true;
                    },
                    child: const Text('Log In'))
              ]),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              SizedBox(
                width: 175,
                height: 30,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _attemptRegistration(
                            email, password, firstName, lastName, id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              ),
            ],
          ),
        ));
  }

  Future _attemptLogin(String email, String password) async {
    User user = await _fireDatabase.login(email, password);
    if (user.id == "None") {
      var warningSnackbar = const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Username or Password is Incorrect!",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });
    } else {
      _sqlDatabase.insertUser(user);
      var successSnackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Successfully logged in. Welcome ${user.firstname}",
          style: const TextStyle(fontSize: 16),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      Navigator.pop(context);
    }
  }

  Future _attemptRegistration(String email, String password, String firstname,
      String lastname, String sid) async {
    User user = await _fireDatabase.login(email, password);
    if (user.id == "None") {
      id = await _fireDatabase.register(
          email, password, firstname, lastname, sid);
      _sqlDatabase.insertUser(User(
          id: id,
          email: email,
          firstname: firstname,
          lastname: lastname,
          sid: sid));
      var successSnackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Successfully registered. Welcome $firstname",
          style: const TextStyle(fontSize: 16),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      Navigator.pop(context);
    } else {
      var warningSnackbar = const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "User is already registered!",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });
    }
  }
}
