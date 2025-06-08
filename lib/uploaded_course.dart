class UploadedCourse {
  final int? id;
  final String name;
  final String organization;
  final String difficulty;
  final double rating;
  final String courseLink;

  UploadedCourse({
    this.id,
    required this.name,
    required this.organization,
    required this.difficulty,
    required this.rating,
    required this.courseLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'organization': organization,
      'difficulty': difficulty,
      'rating': rating,
      'courseLink': courseLink,
    };
  }

  factory UploadedCourse.fromMap(Map<String, dynamic> map) {
    return UploadedCourse(
      id: map['id'],
      name: map['name'],
      organization: map['organization'],
      difficulty: map['difficulty'],
      rating: map['rating'],
      courseLink: map['courseLink'],
    );
  }
}
