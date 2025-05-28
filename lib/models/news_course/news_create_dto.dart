// lib/models/news_course/new_course_dto.dart

import 'materia_type.dart';

/// DTO para representar un recurso en lista (nueva materia)
class NewCourseDto {
  final int id;
  final String title;
  final String url;
  final String description;
  final MateriaType materiaType;

  NewCourseDto({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
    required this.materiaType,
  });

  factory NewCourseDto.fromJson(Map<String, dynamic> json) {
    return NewCourseDto(
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      materiaType: MateriaType.fromApiString(json['category'] as String),
    );
  }
}


// lib/services/new_course_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_course/new_course_dto.dart';
import '../models/news_course/new_course_create_dto.dart';
import '../models/news_course/new_course_detail_dto.dart';
import 'auth_service.dart';

class NewCourseService {
  static const _baseUrl = 'https://tu-backend.azurewebsites.net/api/new_course';
  final AuthService _auth = AuthService();

  Future<List<NewCourseDto>> fetchNewCourses() async {
    final token = await _auth.token;
    final resp = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    final List data = jsonDecode(resp.body) as List;
    return data.map((e) => NewCourseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<NewCourseDetailDto> fetchNewCourseDetail(int id) async {
    final token = await _auth.token;
    final resp = await http.get(
      Uri.parse('$_baseUrl/\$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return NewCourseDetailDto.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<void> createNewCourse(NewCourseCreateDto dto) async {
    final token = await _auth.token;
    await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
  }

  Future<void> updateNewCourse(int id, NewCourseCreateDto dto) async {
    final token = await _auth.token;
    await http.put(
      Uri.parse('$_baseUrl/\$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
  }

  Future<void> deleteNewCourse(int id) async {
    final token = await _auth.token;
    await http.delete(
      Uri.parse('$_baseUrl/\$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
