// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user/token_dto.dart';
import '../models/user/user_info_dto.dart';

class AuthService {
  static const _baseUrl = 'https://app-250528131418.azurewebsites.net/api';
  final _storage = const FlutterSecureStorage();

  // LOGIN: obtiene y guarda el token
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);
    final token = data['token'];
    print('Token recibido del backend: $token');
    await _storage.write(key: 'jwt', value: token);
    final savedToken = await _storage.read(key: 'jwt');
    print('Token guardado en storage: $savedToken');
    return true;
  }

  // GET: usuario actual desde /users/me
  Future<UserInfoDto?> getCurrentUser() async {
    final token = await _storage.read(key: 'jwt');
    print('Token usado para /users: $token');
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      print('Error al obtener usuario actual: ${response.statusCode}');
      print('Body: ${response.body}');
      return null;
    }

    return UserInfoDto.fromJson(jsonDecode(response.body));
  }

  // Getter del token para otros servicios
  Future<String?> get token async => await _storage.read(key: 'jwt');

  // Logout
  Future<void> logout() async => await _storage.delete(key: 'jwt');
}