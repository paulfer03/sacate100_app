// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user/user_info_dto.dart';

class AuthService {
  static const _baseUrl = 'https://tu-backend.azurewebsites.net/api';
  final _storage = const FlutterSecureStorage();

  /// Devuelve el usuario autenticado o lanza excepción si falla.
  Future<UserInfoDto> login(String email, String password) async {
    // Primero obtienes el token
    final resp = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Login failed: ${resp.statusCode}');
    }

    final body = jsonDecode(resp.body);
    final token = body['accessToken'] as String;
    // Guardas el token para futuras peticiones
    await _storage.write(key: 'jwt', value: token);

    // Suponiendo que el endpoint /users/me devuelve la info del usuario
    final profileResp = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (profileResp.statusCode != 200) {
      throw Exception('Fetching profile failed: ${profileResp.statusCode}');
    }
    return UserInfoDto.fromJson(jsonDecode(profileResp.body));
  }

  Future<void> logout() async => await _storage.delete(key: 'jwt');
}
