import 'package:flutter/material.dart';
import 'package:campusmapper/widgets/drop_menu.dart';

class HoverNewsItem extends StatefulWidget {
  final NewsItem newsItem;

  HoverNewsItem({required this.newsItem});

  @override
  _HoverNewsItemState createState() => _HoverNewsItemState();
}

class _HoverNewsItemState extends State<HoverNewsItem> {
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
          leading: Icon(Icons.article, color: Colors.blue),
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
      // Add more news items
      NewsItem(
          title: 'Weather Alert',
          content:
              'There is a rainy weather forecast for the upcoming week. Please plan accordingly.'),
      NewsItem(
          title: 'Lockdown Drill',
          content:
              'A campus-wide lockdown drill is scheduled for this Friday.'),
      NewsItem(
          title: 'Christmas Weekend',
          content:
              'Christmas weekend starts December 5th. Enjoy the festive season!'),
      NewsItem(
          title: 'Winter Tuition Fee Due',
          content:
              'Reminder: Winter semester tuition fees are due by the end of this month.'),
      NewsItem(
          title: 'Kylie’s Day',
          content:
              'Special Event: Kylie Jenner visits our school for a meet and greet on March 12th.'),
      //
    ];

    final List<CampusResource> campusResources = [
      CampusResource(name: 'Library', location: 'Building B'),
      // Add more resources
    ];

    final List<EmergencyContact> emergencyContacts = [
      EmergencyContact(service: 'Campus Security', number: '123-456-7890'),
      // Add more contacts
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Information Center'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.newspaper), text: 'Campus News'),
              Tab(icon: Icon(Icons.place), text: 'Resources'),
              Tab(icon: Icon(Icons.warning), text: 'Emergency'),
            ],
          ),
          actions: const <Widget>[Dropdown()],
        ),
        body: TabBarView(
          children: [
            // Campus News Tab
            _buildNewsList(campusNews),
            // Resources Tab
            _buildResourceList(campusResources),
            // Emergency Contacts Tab
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
        var item = news[index];
        return HoverNewsItem(newsItem: item);
        return ListTile(
          leading: Icon(Icons.article, color: Colors.blue),
          title: Text(item.title),
          subtitle: Text(item.content),
        );
      },
    );
  }

  Widget _buildScheduleList(List<ClassInfo> schedule) {
    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        var classInfo = schedule[index];
        return ListTile(
          leading: Icon(Icons.class_, color: Colors.blue),
          title: Text('${classInfo.time} - ${classInfo.room}'),
          subtitle: Text('Lecturer: ${classInfo.lecturer}'),
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
          leading: Icon(Icons.local_library, color: Colors.green),
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
          leading: Icon(Icons.phone_in_talk, color: Colors.red),
          title: Text(contact.service),
          subtitle: Text(contact.number),
          onTap: () => _callNumber(contact.number),
        );
      },
    );
  }

  void _callNumber(String number) {
    // Implement functionality to call the number
    print('Calling $number...');
  }
}
