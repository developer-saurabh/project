import 'package:flutter/material.dart';
import 'package:project/CourseaReviewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseaReviewCard extends StatelessWidget {
  final CourseraReviewModel course;

  const CourseaReviewCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label for certificate type as title substitute
            Text(
              "Title: ${course.organization}",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),

            // Organization clearly labeled
            Text(
              course.certificateType,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 8),

            Row(
              children: [
                Chip(label: Text(course.difficulty)),
                SizedBox(width: 8),
                Chip(label: Text(course.studentsEnrolled + " enrolled")),
              ],
            ),

            SizedBox(height: 6),

            Text("⭐ ${course.rating.toStringAsFixed(1)}"),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(course.certificateUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open the course link')),
                    );
                  }
                },

                child: Text("View Course"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
