// lib/models/news_course/materia_type.dart

enum MateriaType {
  calculo1,
  fundamentosDeProgramacion,
  fundamentosDeMatematicas,
  redes,
  otros;

  /// Convierte un string de la API a un enum, con fallback
  static MateriaType fromApiString(String value) {
    return MateriaType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MateriaType.otros,
    );
  }

  /// Convierte el enum al string que espera la API
  String toApiString() => name.toLowerCase();
}

// lib/models/news_course/news_course_detail_dto.dart


/// DTO para detalles completos de un curso (NewCourse)
class NewsCourseDetailDto {
  final int id;
  final String title;
  final String url;
  final String description;
  final int authorId;
  final DateTime publishDate;
  final MateriaType materiaType;

  NewsCourseDetailDto({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.authorId,
    required this.publishDate,
    required this.materiaType,
  });

  factory NewsCourseDetailDto.fromJson(Map<String, dynamic> json) {
    return NewsCourseDetailDto(
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as int,
      publishDate: DateTime.parse(json['publishDate'] as String),
      materiaType: MateriaType.fromApiString(json['category'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'description': description,
        'authorId': authorId,
        'publishDate': publishDate.toIso8601String(),
        'category': materiaType.toApiString(),
      };
}