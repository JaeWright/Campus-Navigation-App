import 'package:flutter/material.dart';
import 'Food.dart';
import 'StudentLogin.dart';
import 'informationCentrePage.dart';
import 'Accessebility.dart';
import 'dart:math' as math;

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This flag will change based on the user's login status
  bool isLoggedIn = false;

  void navigateToSection(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Call this method when the login is successful
  void loginUser() {
    setState(() {
      isLoggedIn = true;
    });
  }

  // Call this method when the user logs out
  void logoutUser() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navigationCards = [
      NavigationCard(
        icon: Icons.info,
        title: 'Information Center',
        color: Colors.blueAccent,
        onTap: () {
          navigateToSection(context, InformationCenterPage());
        },
      ),
      NavigationCard(
        icon: Icons.fastfood_sharp,
        title: 'CampusFood',
        color: Colors.yellowAccent,
        onTap: () {
          navigateToSection(context, FoodPage());
        },
      ),
      NavigationCard(
        icon: Icons.accessible,
        title: 'Accessibility',
        color: Colors.redAccent,
        onTap: () {
          navigateToSection(context, AccessibilityDirectoryPage());
        },
      ),
      // ... Add other NavigationCard widgets as needed ...
    ];

    if (!isLoggedIn) {
      navigationCards.insert(
        1, // Adjust index as needed to place the login card in the desired position
        NavigationCard(
          icon: Icons.school,
          title: 'Student Login',
          color: Colors.white38,
          onTap: () {
            navigateToSection(context, StudentLoginPage());
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Navigator'),
        actions: isLoggedIn
            ? [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logoutUser, // Calls logoutUser to update the state
          ),
        ]
            : [],
      ),
      body: AnimatedBackground(
        child: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(8.0),
          childAspectRatio: 0.8 / 1.0,
          children: navigationCards,
        ),
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();

    // Start the animation
    _animateBackgroundColor();
  }

  void _animateBackgroundColor() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (mounted) {
        setState(() {
          // Generate a random color with full opacity
          _color = Color((0xFF000000 | math.Random().nextInt(0xFFFFFF)));
        });
        _animateBackgroundColor();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      color: _color,
      child: widget.child,
    );
  }
}

class NotificationsPage extends StatelessWidget {
  // ... Your existing NotificationsPage code ...
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
  // ... Your existing NavigationCard code, make sure the colors are set to transparent ...
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