import 'package:flutter/material.dart';
import 'package:project/uploaded_course.dart';
import 'database_helper.dart';

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

  List<UploadedCourse> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final data = await DatabaseHelper.instance.getCourses();
    setState(() => _courses = data);
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState?.validate() ?? false) {
      final course = UploadedCourse(
        name: _nameController.text,
        organization: _organizationController.text,
        difficulty: _difficultyController.text,
        rating: double.parse(_ratingController.text),
        courseLink: '',
      );

      await DatabaseHelper.instance.insertCourse(course);

      _nameController.clear();
      _organizationController.clear();
      _difficultyController.clear();
      _ratingController.clear();

      _loadCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Course"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(_nameController, "Course Name"),
                  _buildInput(_organizationController, "Organization"),
                  _buildInput(_difficultyController, "Difficulty"),
                  _buildInput(
                    _ratingController,
                    "Rating (e.g., 4.5)",
                    isNumber: true,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveCourse,
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final c = _courses[index];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text("${c.organization} • ${c.difficulty}"),
                    trailing: Text("⭐ ${c.rating.toStringAsFixed(1)}"),
                  );
                },
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
          border: OutlineInputBorder(),
        ),
        validator:
            (value) => (value == null || value.isEmpty) ? "Required" : null,
      ),
    );
  }
}
