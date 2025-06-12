import 'package:flutter/material.dart';
import 'package:project/uploaded_course.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UploadedCourseStore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _ratingController = TextEditingController();
  final _reviewController = TextEditingController();

  List<UploadedCourse> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _resetDatabase() async {
    await UploadedCourseStore.clearAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Database reset — reload to see effect")),
    );
    setState(() => _courses.clear());
  }

  Future<void> _loadCourses() async {
    final data = await UploadedCourseStore.getCourses();
    setState(() => _courses = data);
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState?.validate() ?? false) {
      final course = UploadedCourse(
        name: _nameController.text,
        organization: _organizationController.text,
        difficulty: _difficultyController.text,
        rating: double.parse(_ratingController.text),
        courseLink: _difficultyController.text,

        review: _reviewController.text,
      );

      await UploadedCourseStore.insertCourse(course);

      _nameController.clear();
      _organizationController.clear();
      _difficultyController.clear();
      _ratingController.clear();
      _reviewController.clear();

      await _loadCourses();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Course uploaded successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Course", style: TextStyle(color: Colors.white)),

        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Add a New Course",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInput(_nameController, "Course Name"),
                      _buildInput(_organizationController, "Organization"),
                      _buildInput(_difficultyController, "Course Link"),
                      _buildInput(
                        _ratingController,
                        "Rating (e.g., 4.5)",
                        isNumber: true,
                      ),
                      _buildInput(_reviewController, "Course Review"),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveCourse,
                              child: Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (kIsWeb) ...[
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _resetDatabase,
                                child: Text("Reset Web DB"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 20),
                      Divider(thickness: 1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Uploaded Courses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ..._courses.map(
                        (c) => Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${c.organization} • ${c.difficulty}",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  c.review,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(height: 8),

                                if (c.courseLink.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final uri = Uri.tryParse(c.courseLink);
                                        if (uri != null &&
                                            await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Could not open the course link",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Open Course Link",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "⭐ ${c.rating.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      color: Colors.amber[800],
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator:
            (value) => (value == null || value.isEmpty) ? "Required" : null,
      ),
    );
  }
}
