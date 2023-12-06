/*
Author: Darshilkumar Patel - 100832600
This page manages the HelpButton shown on home page for now and will add more functionality.
It shows just text now for demonstration purpose.
*/

import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback
      onPressed; // defined callback function to be triggered when pressed

  HelpButton(
      {required this.onPressed}); // constructor to initialize the onpressed callback

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        bottom: 8.0, // bottom padding as needed
        child: FloatingActionButton(
          // customized onpressed function
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Help'),
                  content: Text('This is the help message.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8.0,
          child: Icon(Icons.help),
          tooltip: 'Help',
        ),
      )
    ]);
  }
}
