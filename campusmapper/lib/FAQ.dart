import 'package:flutter/material.dart';

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<FAQ> faqs = [
    // ... Your FAQs here
    FAQ(
        question: "I forgot my password. How can I reset it?",
        answer:
            "You can reset your password by clicking on the 'Forgot Password' link on the login screen. Follow the prompts to reset your password via email."),
    FAQ(
        question: "Can I access my schedule through the app?",
        answer:
            "Yes, you can view your schedule by logging into the app and accessing the 'My Schedule' section."),
    FAQ(
        question: "Can I access a campus map through the app?",
        answer:
            "Yes, you can view the campus map through the 'Campus Map' section."),
    FAQ(
        question: "Is my course schedule the same as my registered courses?",
        answer:
            "No, the courses on the app have to be added by you. They are not synced with your registered courses."),
    FAQ(
        question: "How can I report a technical issue or bug in the app?",
        answer:
            "If you encounter any technical issues or bugs, please contact our support team at support@universityapp.com. They will assist you in resolving the problem."),
    FAQ(
        question: "Is there a mobile version of the app for tablets?",
        answer:
            "Yes, the app is compatible with both smartphones and tablets, so you can use it on your tablet as well."),
    FAQ(
        question:
            "Can I pay my tuition fees or check my financial aid status through the app?",
        answer:
            "No, this app can only help you find your way around campus, and view your schedule. To pay tuition fees, please visit MyOntarioTech."),
    FAQ(
        question: "How do I log in to my profile?",
        answer:
            "To log in, tap the profile icon in the top right corner. Click 'Log In' to Log In or Register"),

    FAQ(
        question: "How do I log out of the app when I'm done using it?",
        answer:
            "To log out, tap the profile icon in the top right corner. Click 'Log Out' to safely log out"),
  ];

  String _searchQuery = '';
  List<FAQ> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = faqs;
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      if (_searchQuery.isEmpty) {
        _filteredFaqs = faqs;
      } else {
        _filteredFaqs = faqs
            .where((faq) =>
                faq.question
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Color(0xFFE67E22),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Search FAQs',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredFaqs[index].question),
                  subtitle: Text(_filteredFaqs[index].answer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
