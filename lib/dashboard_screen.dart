import 'package:flutter/material.dart';
import 'package:project/about_page.dart';
import 'package:project/review_screen.dart';
import 'package:project/upload_page.dart';

class AcademicDashboard extends StatefulWidget {
  const AcademicDashboard({super.key});

  @override
  State<AcademicDashboard> createState() => _AcademicDashboardState();
}

class _AcademicDashboardState extends State<AcademicDashboard> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReviewScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => UploadPage()));
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Center(child: Text('Search Page', style: TextStyle(fontSize: 18))),
    HomePage(),
    Center(child: Text('Upload Page', style: TextStyle(fontSize: 18))),
    AboutPage(), // ✅ Directly load AboutPage widget here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _selectedIndex == 1
              ? AppBar(
                backgroundColor: Colors.indigo,
                elevation: 0,
                centerTitle: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rajiv Gandhi College & Research and Technology",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                ],
              )
              : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
            ),
            child: Center(
              child: Text(
                "Virtual Academic Guidance & Personalized Recommendation",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/image.jpg', fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '''Department of Computer Science and Engineering

About the Department:
The Computer Science and Engineering (CSE) department began in 1987 with 60 seats, expanding to 150 seats in 2023-24. A Master in Technology (M.Tech) program was introduced in 2008-2009 with 18 seats. In 2018-2019, the college affiliated with Dr. Babasaheb Ambedkar Technological University, offering a B.Tech in Computer Science and Engineering.

The curriculum emphasizes project-based learning, digital transformation technologies, and industry-relevant skills like Full Stack Programming, Big Data, AI, and IoT. The department has state-of-the-art infrastructure with various specialized servers and softwares. It boasts a strong academic record with over 95% final-year results and encourages participation in competitive exams.

The faculty is highly qualified, experienced, and actively involved in research and regional academic activities.''',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
