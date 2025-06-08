class GFormReviewModel {
  final String timestamp;
  final String name;
  final String email;
  final String course;
  final String feedback;
  final String certificateUrl;

  GFormReviewModel({
    required this.timestamp,
    required this.name,
    required this.email,
    required this.course,
    required this.feedback,
    required this.certificateUrl,
  });

  factory GFormReviewModel.fromJson(Map<String, dynamic> json) {
    return GFormReviewModel(
      timestamp: json['Timestamp'] ?? '',
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      course: json['Course/Internship'] ?? '',
      feedback: json['Review/Feedback'] ?? '',
      certificateUrl: json['Certificate URL'] ?? '',
    );
  }
}
