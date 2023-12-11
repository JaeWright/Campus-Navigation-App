import 'package:flutter/material.dart';
// Ensure 'drop_menu.dart' exists and is correct; if not, this line should be commented out or fixed.
// import 'package:campusmapper/widgets/drop_menu.dart';
import 'package:campusmapper/widgets/drop_menu.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HoverNewsItem extends StatefulWidget {
  final NewsItem newsItem;

  const HoverNewsItem({super.key, required this.newsItem});

  @override
  HoverNewsItemState createState() => HoverNewsItemState();
}

class HoverNewsItemState extends State<HoverNewsItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onHover(true),
      onExit: (event) => _onHover(false),
      child: Container(
        color: _isHovering
            ? Colors.lightBlueAccent.withOpacity(0.5)
            : Colors.transparent,
        child: ListTile(
          leading: const Icon(Icons.article, color: Colors.blue),
          title: Text(widget.newsItem.title),
          subtitle: Text(widget.newsItem.content),
        ),
      ),
    );
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }
}

class NewsItem {
  final String title;
  final String content;

  NewsItem({required this.title, required this.content});
}

class ClassInfo {
  final String time;
  final String room;
  final String lecturer;

  ClassInfo({required this.time, required this.room, required this.lecturer});
}

class CampusResource {
  final String name;
  final String location;

  CampusResource({required this.name, required this.location});
}

class EmergencyContact {
  final String service;
  final String number;

  EmergencyContact({required this.service, required this.number});
}

class InformationCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<NewsItem> campusNews = [
      NewsItem(
          title: 'Spring Semester Registration',
          content: 'Registration for the Spring semester begins next Monday.'),
      NewsItem(
          title: 'Weather Alert',
          content: 'There is a rainy weather forecast for the upcoming week. Please plan accordingly.'),
      NewsItem(
          title: 'Lockdown Drill',
          content: 'A campus-wide lockdown drill is scheduled for this Friday.'),
      NewsItem(
          title: 'Christmas Weekend',
          content: 'Christmas weekend starts December 5th. Enjoy the festive season!'),
      NewsItem(
          title: 'Winter Tuition Fee Due',
          content: 'Reminder: Winter semester tuition fees are due by the end of this month.'),
      NewsItem(
          title: 'Kylie’s Day',
          content: 'Special Event: Kylie Jenner visits our school for a meet and greet on March 12th.'),
    ];

    final List<CampusResource> campusResources = [
      CampusResource(name: 'Library', location: 'Building B'),
      // Add more resources as needed
    ];

    final List<EmergencyContact> emergencyContacts = [
      EmergencyContact(service: 'Campus Security', number: '123-456-7890'),
      EmergencyContact(service: 'Campus Medical', number: '287-654-3210'),
      EmergencyContact(service: 'Campus FacultyScience', number: '387-654-3210'),
      EmergencyContact(service: 'Campus FacultyBusines', number: '487-654-3210'),
      EmergencyContact(service: 'Campus FacultyMedical', number: '587-654-3210'),
      EmergencyContact(service: 'Campus FacutyRecreational', number: '687-654-3210'),
      EmergencyContact(service: 'Campus FacultyEngineering', number: '787-654-3210'),
      EmergencyContact(service: 'Campus Registration', number: '887-654-3210'),

      // Add more contacts as needed
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Information Center'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.newspaper), text: 'Campus News'),
              Tab(icon: Icon(Icons.place), text: 'Resources'),
              Tab(icon: Icon(Icons.warning), text: 'Emergency'),
            ],
          ),
          actions: const <Widget>[
            //Dropdown(), // Make sure you have this widget defined or remove this line.
          ],
        ),
        body: TabBarView(
          children: [
            _buildNewsList(campusNews),
            _buildResourceList(campusResources),
            _buildContactList(emergencyContacts),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(List<NewsItem> news) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        var newsItem = news[index];
        return ListTile(
          leading: const Icon(Icons.article, color: Colors.blue),
          title: Text(newsItem.title),
          subtitle: Text(newsItem.content),
        );
      },
    );
  }

  Widget _buildResourceList(List<CampusResource> resources) {
    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        var resource = resources[index];
        return ListTile(
          leading: const Icon(Icons.local_library, color: Colors.green),
          title: Text(resource.name),
          subtitle: Text('Location: ${resource.location}'),
        );
      },
    );
  }

  Widget _buildContactList(List<EmergencyContact> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        var contact = contacts[index];
        return ListTile(
          leading: const Icon(Icons.phone_in_talk, color: Colors.red),
          title: Text(contact.service),
          subtitle: Text(contact.number),
          onTap: () {
            _showContactOptions(
                context, contact); //Implement your calling functionality here
          },
        );
      },
    );
  }

  void _showContactOptions(BuildContext context, EmergencyContact contact) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call'),
              onTap: () => _callNumber(contact.number),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Text Message'),
              onTap: () => _sendTextMessage(contact.number),
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy Number'),
              onTap: () => _copyToClipboard(context, contact.number),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Email'),
              onTap: () {
                // Replace with actual email address if available
                _sendEmail('email@example.com');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _callNumber(String number) async {
    Uri uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _sendTextMessage(String number) async {
    Uri uri = Uri.parse('sms:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context); // Close the bottom sheet after copying
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $text to clipboard'),
      ),
    );
  }

  void _sendEmail(String email) async {
    Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
