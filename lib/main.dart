import 'package:flutter/material.dart';
import 'informationCentrePage.dart';
import 'Accessebility.dart';
void main() => runApp(CampusNavigatorApp());

class CampusNavigatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Navigator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void navigateToSection(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Navigator'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          // ... Other NavigationCard widgets ...
          NavigationCard(
            icon: Icons.info,
            title: 'Information Center',
            color: Colors.lightBlue,
            onTap: () {
              navigateToSection(context, InformationCenterPage());
            },
          ),

          NavigationCard(
            icon: Icons.info,
            title: 'Accessibility',
            color: Colors.redAccent,
            onTap: () {
              navigateToSection(context, AccessibilityDirectoryPage());
            },
          ),

          NavigationCard(
            icon: Icons.notifications,
            title: 'Notifications',
            color: Colors.amber,
            onTap: () {
              navigateToSection(context, NotificationsPage());
            },
          ),

          // ... Add other sections here ...
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for events
    final events = [
      {'name': 'Tech Workshop', 'date': 'Nov 10', 'location': 'Auditorium'},
      // Add more events
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          var event = events[index];
          return ListTile(
            title: Text(event['name'] ?? 'Unknown Event'), // Provide a default value
            subtitle: Text('${event['date'] ?? 'Date not set'} at ${event['location'] ?? 'Location not set'}'),
            onTap: () {
              // Your onTap code
            },
          );

        },
      ),
    );
  }
}

class NavigationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const NavigationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0),
            SizedBox(height: 16.0),
            Text(title, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
