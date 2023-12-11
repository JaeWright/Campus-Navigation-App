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
        question: "How do I download and install the app?",
        answer:
        "You can download and install the app from the App Store (iOS) or Google Play Store (Android). Search for 'Our University App' and follow the installation instructions."),
    FAQ(
        question: "I forgot my password. How can I reset it?",
        answer:
        "You can reset your password by clicking on the 'Forgot Password' link on the login screen. Follow the prompts to reset your password via email."),
    FAQ(
        question: "Can I access my course schedule through the app?",
        answer:
        "Yes, you can view your course schedule by logging into the app and accessing the 'Schedule' section."),
    FAQ(
        question: "How can I report a technical issue or bug in the app?",
        answer:
        "If you encounter any technical issues or bugs, please contact our support team at support@universityapp.com. They will assist you in resolving the problem."),
    FAQ(
        question: "Is there a mobile version of the app for tablets?",
        answer:
        "Yes, the app is compatible with both smartphones and tablets, so you can use it on your tablet as well."),
    FAQ(
        question: "Can I update my contact information (phone number, address) through the app?",
        answer:
        "Yes, you can update your contact information by going to the 'Profile' or 'Settings' section of the app and making the necessary changes."),
    FAQ(
        question: "How do I find my grades and transcripts in the app?",
        answer:
        "You can access your grades and transcripts through the 'Academic Records' or 'Grades' section of the app. Your latest academic information will be available there."),
    FAQ(
        question: "Can I pay my tuition fees or check my financial aid status through the app?",
        answer:
        "Yes, you can make tuition payments and check your financial aid status in the 'Financial' or 'Student Accounts' section of the app."),
    FAQ(
        question: "Is there a mobile version of the campus map available in the app?",
        answer:
        "Absolutely! The app features a campus map that you can use to navigate your way around the university."),
    FAQ(
        question: "How do I log out of the app when I'm done using it?",
        answer:
        "To log out, go to the 'Settings' or 'Profile' section of the app, and you'll find an option to log out. Tap it to safely exit the app."),

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
        faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
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
