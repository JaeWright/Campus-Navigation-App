/* 
Author: Brock Davidge - 100787894
A StatefulWidget for the Student Login page, featuring email and password input fields, login logic with error handling,
and a responsive UI.
*/
import 'package:flutter/material.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Implement your login logic here
    // For example, you could call an API with the email and password
    // Simulate a login by checking if the email and password are not empty.
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Here you should call your backend service and await for response.

      // If login is successful, pop the current page and return to HomePage.
      Navigator.of(context).pop();
    } else {
      // Show some error if login is not successful.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
