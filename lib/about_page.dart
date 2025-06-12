import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final String description = '''
This project is about creating a smart system that helps students by giving them academic guidance based on their questions or feedback. When a student types a question, it can also help students find useful study materials or guide them to the right place for help.
''';

  final List<String> emails = [
    'ganeshbukkawar@gmail.com',
    'abhinavgandhewar@gmail.com',
    'rashmigargam14@gmail.com',
    'achalbutale852@gmail.com',
    'sanketmeshram325@gmail.com',
  ];

  Future<void> _launchEmail(String email) async {
    final Uri mailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Project",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Project Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(description, style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            Text(
              "Contributors",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...emails.map(
              (email) => InkWell(
                onTap: () => _launchEmail(email),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.email, color: Colors.indigo, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
