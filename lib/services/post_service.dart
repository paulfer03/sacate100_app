import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_post/news_post_dto.dart';
import '../models/news_post/news_post_create_dto.dart';
import '../models/news_post/news_post_detail_dto.dart';

class PostService {
  final String _baseUrl = 'https://app-250528131418.azurewebsites.net/api/posts';

  Future<List<NewsPostDto>> getAllPosts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => NewsPostDto.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener publicaciones');
    }
  }

  Future<void> createPost(NewsPostCreateDto dto) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear publicación');
    }
  }

  Future<void> updatePost(int id, NewsPostCreateDto dto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al actualizar publicación');
    }
  }

  Future<bool> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    return response.statusCode == 204;
  }
  
  Future<NewsPostDetailDto> getPostById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NewsPostDetailDto.fromJson(data);
    } else {
      throw Exception('Error al obtener la publicación');
    }
  }
  
}