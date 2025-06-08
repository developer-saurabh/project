import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/CourseaReviewModel.dart';
import 'package:project/GFormReviewModel.dart';
import 'package:project/coursea_review_card.dart';
import 'package:project/review_card.dart' show GFormReviewCard;
import 'package:shimmer/shimmer.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<GFormReviewModel> _gformReviews = [];
  List<CourseraReviewModel> _courseaReviews = [];
  List<GFormReviewModel> _gformResults = [];
  List<CourseraReviewModel> _courseaResults = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final gformData = await rootBundle.loadString(
      'assets/fixed_form_responses_clean.json',
    );
    final courseaData = await rootBundle.loadString('assets/coursea_data.json');

    setState(() {
      _gformReviews =
          (json.decode(gformData) as List)
              .map((e) => GFormReviewModel.fromJson(e))
              .toList();

      _courseaReviews =
          (json.decode(courseaData) as List)
              .map((e) => CourseraReviewModel.fromJson(e))
              .toList();
    });
  }

  void _search(String query) async {
    final lowerQuery = query.toLowerCase();

    final gformMatches =
        _gformReviews.where((e) {
          return e.name.toLowerCase().contains(lowerQuery) ||
              e.course.toLowerCase().contains(lowerQuery);
        }).toList();

    setState(() {
      _gformResults = gformMatches;
      _courseaResults = [];
      _isLoadingMore = true;
    });

    // Simulate few-shot delay
    await Future.delayed(Duration(seconds: 3));

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
