import 'package:flutter/material.dart';
import 'package:campusmapper/screens/student_login.dart';

enum Label { login, logout }

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});
  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  Label? selectedMenu;
  bool loggedin = false;
  @override
  void initState() {
    // TODO: implement initState
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
            child: Text('Log In'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StudentLoginPage()));
            },
          )
        else
          const PopupMenuItem(enabled: false, child: Text("Hello User")),
        if (loggedin)
          const PopupMenuItem<Label>(
              value: Label.logout, child: Text('Log Out')),
      ],
    );
  }
}
