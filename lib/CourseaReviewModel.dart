// class CourseraReviewModel {
//   final String organization;
//   final String certificateType;
//   final double rating;
//   final String difficulty;
//   final String studentsEnrolled;
//   final String certificateUrl;

//   CourseraReviewModel({
//     required this.organization,
//     required this.certificateType,
//     required this.rating,
//     required this.difficulty,
//     required this.studentsEnrolled,
//     required this.certificateUrl,
//   });

//   factory CourseraReviewModel.fromJson(Map<String, dynamic> json) {
//     return CourseraReviewModel(
//       organization: json['course_Organization'] ?? '',
//       certificateType: json['course_Certificate_type'] ?? '',
//       rating: (json['course_rating'] ?? 0).toDouble(),
//       difficulty: json['course_difficulty'] ?? '',
//       studentsEnrolled: json['course_students_enrolled'] ?? '',
//       certificateUrl: json['link'] ?? '',
//     );
//   }
// }

class CourseraReviewModel {
  final String organization;
  final String certificateType;
  final double rating;
  final String difficulty;
  final String studentsEnrolled;
  final String certificateUrl;
  bool isBookmarked; // New field for bookmark

  CourseraReviewModel({
    required this.organization,
    required this.certificateType,
    required this.rating,
    required this.difficulty,
    required this.studentsEnrolled,
    required this.certificateUrl,
    this.isBookmarked = false, // Initialize to false
  });

  factory CourseraReviewModel.fromJson(Map<String, dynamic> json) {
    return CourseraReviewModel(
      organization: json['course_Organization'] ?? '',
      certificateType: json['course_Certificate_type'] ?? '',
      rating: (json['course_rating'] ?? 0).toDouble(),
      difficulty: json['course_difficulty'] ?? '',
      studentsEnrolled: json['course_students_enrolled'] ?? '',
      certificateUrl: json['link'] ?? '',
      isBookmarked:
          json['isBookmarked'] ?? false, // Set bookmark status from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_Organization': organization,
      'course_Certificate_type': certificateType,
      'course_rating': rating,
      'course_difficulty': difficulty,
      'course_students_enrolled': studentsEnrolled,
      'link': certificateUrl,
      'isBookmarked': isBookmarked, // Add bookmark to JSON
    };
  }
}
