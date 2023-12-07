import 'package:campusmapper/utilities/user.dart';
import 'package:flutter/material.dart';
import 'package:campusmapper/screens/student_login.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';

enum Label { login, logout }

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});
  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  Label? selectedMenu;
  bool loggedin = false;
  UserModel database = UserModel();
  User loggedIn = User(
      id: 0, email: 'None', firstname: 'None', lastname: 'None', sid: 'None');
  @override
  void initState() {
    getLogInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Label>(
      icon: const Icon(Icons.account_circle),
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (Label item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Label>>[
        if (!loggedin)
          PopupMenuItem<Label>(
            value: Label.login,
            child: const Text('Log In'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StudentLoginPage()));
            },
          )
        else
          PopupMenuItem(
              enabled: false, child: Text("Hello ${loggedIn.firstname}")),
        if (loggedin)
          const PopupMenuItem<Label>(
              value: Label.logout, child: Text('Log Out')),
      ],
    );
  }

  //Check to see if a user is logged in. There should only be one user in the database at a time
  void getLogInStatus() async {
    List<User> user = await database.getUser();
    setState(() {
      if (user.isEmpty) {
        loggedin = false;
        loggedIn = User(
            id: 0,
            email: 'None',
            firstname: 'None',
            lastname: 'None',
            sid: 'None');
      } else {
        loggedin = true;
        loggedIn = user[0];
      }
    });
  }
}
