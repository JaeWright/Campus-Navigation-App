import 'package:flutter/material.dart';
import '../Registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  bool _isLoginSelected = true; // Indicates whether login is selected

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  void _toggleLoginSignup(bool isLoginSelected) {
    setState(() {
      _isLoginSelected = isLoginSelected;
    });
  }

  void _login() {
    // Implement your login logic here...
  }

  void _register() {
    // Check if it's a registration attempt
    if (!_isLoginSelected) {
      // Registration logic as per your requirements
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String studentId = _studentIdController.text;

      // Check if the email is valid (ends with @school.net)
      if (!email.endsWith('@school.net')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email must end with @school.net'),
          ),
        );
        return;
      }

      // Check if the password has at least 7 characters
      if (password.length < 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password must have at least 7 characters'),
          ),
        );
        return;
      }

      // Check if the student ID has 1-9 digits
      if (studentId.isEmpty ||
          int.tryParse(studentId) == null ||
          studentId.length < 1 ||
          studentId.length > 9) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student ID must be 1-9 digits long'),
          ),
        );
        return;
      }

      // Your registration logic here, e.g., sending data to a backend or database
      // If registration is successful, you can navigate back to the login page or perform any other action.
      // If registration fails, you can show an error message.

      // Example:
      // If registration is successful, you can navigate back to the login page.
      Navigator.of(context).pop();
    } else {
      // Login logic as per your requirements...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        title: const Row(children: [
          Icon(Icons.school),
          Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text("Student Login"))
        ]),
        actions: [
          GestureDetector(
            onTap: () => _toggleLoginSignup(true),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                'Login',
                style: TextStyle(
                  color: _isLoginSelected ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _toggleLoginSignup(false),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                'SignUp',
                style: TextStyle(
                  color: _isLoginSelected ? Colors.grey : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!_isLoginSelected) ...[
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoginSelected ? _login : _register,
              child: Text(_isLoginSelected ? 'Login' : 'Register'),
              style: ElevatedButton.styleFrom(
                primary: _isLoginSelected ? Colors.blue : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
