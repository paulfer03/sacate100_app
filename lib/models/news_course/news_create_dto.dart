class NewsCourseCreateDto {
  final String title;
  final String description;
  final String imageUrl;
  final int categoryId;

  NewsCourseCreateDto({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
  });

  factory NewsCourseCreateDto.fromJson(Map<String, dynamic> json) {
    return NewsCourseCreateDto(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
    };
  }
}
