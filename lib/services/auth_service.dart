import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import '../models/user.dart';

class AuthService {
  // 🔹 Iniciar sesión y obtener token
  static Future<bool> login(User user) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);
      return true;
    }
    return false;
  }

  // 🔹 Obtener token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  // 🔹 Cerrar sesión y eliminar token
  static Future<void> logout() async {
    String? token = await getToken();
    if (token != null) {
      String baseUrl = await ApiConfig.getBaseUrl();
      await http.post(
        Uri.parse("$baseUrl/auth/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}