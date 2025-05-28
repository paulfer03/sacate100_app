class NewsCourseDto {
  final String id;
  final String title;
  final String content;
  final String courseId;
  final DateTime createdAt;

  NewsCourseDto({
    required this.id,
    required this.title,
    required this.content,
    required this.courseId,
    required this.createdAt,
  });

  factory NewsCourseDto.fromJson(Map<String, dynamic> json) {
    return NewsCourseDto(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      courseId: json['courseId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
