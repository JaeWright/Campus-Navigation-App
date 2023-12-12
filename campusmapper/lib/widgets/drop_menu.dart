//Author: Luca Lotito
//Calls which creates and manages the widget that allows the user to log in and out
import 'package:campusmapper/utilities/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:campusmapper/screens/student_login.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/models/sqflite/scheduler_database_helper.dart';

enum Label { login, logout }

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});
  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  //Item that's selected
  Label? selectedMenu;
  //Current state
  bool loggedin = false;
  UserModel database = UserModel();
  //Default state
  User loggedIn =
      User(id: 'None', email: 'None', firstname: 'None', lastname: 'None');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Checks if user is logged in
    getLogInStatus();

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
              if (!context.mounted) return;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const StudentLoginPage(
                        forced: false,
                      )));
            },
          )
        else
          PopupMenuItem(
              enabled: false, child: Text("Hello ${loggedIn.firstname}")),
        //Needed it's own if statement, as didn't want to work properly in the else
        if (loggedin)
          PopupMenuItem<Label>(
              value: Label.logout,
              child: const Text('Log Out'),
              onTap: () {
                if (!context.mounted) return;
                logOut();
              }),
      ],
    );
  }

  //Check to see if a user is logged in. There should only be one user in the database at a time
  void getLogInStatus() async {
    List<User> user = await database.getUser();
    if (!context.mounted) return;
    setState(() {
      if (user.isEmpty) {
        loggedin = false;
        loggedIn = User(
            id: 'None', email: 'None', firstname: 'None', lastname: 'None');
      } else {
        loggedin = true;
        loggedIn = user[0];
      }
    });
  }

  //Logs the user out
  void logOut() async {
    await database.removeUser(loggedIn);
    await CoursesModel().clearLocal();
    await EventsModel().clearLocal();
    setState(() {
      loggedIn =
          User(id: 'None', email: 'None', firstname: 'None', lastname: 'None');
      loggedin = false;
    });
  }
}
