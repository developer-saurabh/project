import 'package:flutter/material.dart';
import 'package:project/GFormReviewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class GFormReviewCard extends StatelessWidget {
  final GFormReviewModel review;

  const GFormReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.indigo),
                SizedBox(width: 8),
                Text(
                  review.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(review.email, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 10),
            Chip(
              label: Text(review.course, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.indigo,
            ),
            SizedBox(height: 10),
            Text(
              "“${review.feedback}”",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(Icons.star, color: Colors.amber, size: 20),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => launchUrl(Uri.parse(review.certificateUrl)),
                  icon: Icon(Icons.open_in_new),
                  label: Text(
                    "View Certificate",
                    style: TextStyle(
                      color: Colors.white,
                    ), // Set the text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.indigo, // Background color of the button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
