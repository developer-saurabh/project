import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/CourseaReviewModel.dart';
import 'package:project/GFormReviewModel.dart';
import 'package:project/coursea_review_card.dart';
import 'package:project/review_card.dart' show GFormReviewCard;
import 'package:project/uploaded_course.dart';
import 'package:project/UploadedCourseStore.dart';
import 'package:shimmer/shimmer.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<GFormReviewModel> _gformReviews = [];
  List<CourseraReviewModel> _courseaReviews = [];
  List<UploadedCourse> _uploadedCourses = [];

  List<GFormReviewModel> _gformResults = [];
  List<CourseraReviewModel> _courseaResults = [];
  List<UploadedCourse> _uploadedResults = [];

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final gformData = await rootBundle.loadString('assets/data1.json');
    final courseaData = await rootBundle.loadString('assets/coursea_data.json');
    final uploadedData = await UploadedCourseStore.getCourses();

    setState(() {
      _gformReviews =
          (json.decode(gformData) as List)
              .map((e) => GFormReviewModel.fromJson(e))
              .toList();

      _courseaReviews =
          (json.decode(courseaData) as List)
              .map((e) => CourseraReviewModel.fromJson(e))
              .toList();

      _uploadedCourses = uploadedData;
    });
  }

  void _search(String query) async {
    final lowerQuery = query.toLowerCase();

    final gformMatches =
        _gformReviews.where((e) {
          return e.name.toLowerCase().contains(lowerQuery) ||
              e.course.toLowerCase().contains(lowerQuery);
        }).toList();

    final uploadedMatches =
        _uploadedCourses.where((e) {
          return e.name.toLowerCase().contains(lowerQuery) ||
              e.organization.toLowerCase().contains(lowerQuery) ||
              e.review.toLowerCase().contains(lowerQuery);
        }).toList();

    setState(() {
      _gformResults = gformMatches;
      _uploadedResults = uploadedMatches;
      _courseaResults = [];
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(seconds: 2));

    final courseaMatches =
        _courseaReviews.where((e) {
          return e.organization.toLowerCase().contains(lowerQuery) ||
              e.certificateType.toLowerCase().contains(lowerQuery) ||
              e.difficulty.toLowerCase().contains(lowerQuery);
        }).toList();

    setState(() {
      _courseaResults = courseaMatches;
      _isLoadingMore = false;
    });
  }

  Widget _buildShimmerLoader() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Text("FewShot Data Loading...", style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUploadedCourseCard(UploadedCourse course) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "${course.organization} • ${course.difficulty}",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 6),
            Text(course.review),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "⭐ ${course.rating.toStringAsFixed(1)}",
                style: TextStyle(
                  color: Colors.amber[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Reviews")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                hintText:
                    "Search courses by name, certificate type, or organization...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ..._uploadedResults.map(_buildUploadedCourseCard).toList(),
                ..._gformResults
                    .map((e) => GFormReviewCard(review: e))
                    .toList(),
                if (_isLoadingMore) _buildShimmerLoader(),
                ..._courseaResults
                    .map((e) => CourseaReviewCard(course: e))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
